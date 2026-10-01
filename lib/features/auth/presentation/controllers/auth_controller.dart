import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/network_providers.dart';
import '../../../../core/storage/storage_providers.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

import '../../../notifications/presentation/controllers/notifications_controller.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteDataSourceImpl(apiClient);
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final storageService = ref.watch(secureStorageServiceProvider);
  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    storageService: storageService,
  );
}

@Riverpod(keepAlive: true)
LoginUseCase loginUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
}

@Riverpod(keepAlive: true)
LogoutUseCase logoutUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository);
}

@Riverpod(keepAlive: true)
GetCurrentUserUseCase getCurrentUserUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(repository);
}

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  FutureOr<User?> build() async {
    final authRepo = ref.watch(authRepositoryProvider);
    final isAuth = await authRepo.isAuthenticated();
    if (!isAuth) return null;

    // Do NOT catch errors silently — propagate so the router can redirect
    // to login and no fictitious session is fabricated.
    final getCurrentUser = ref.watch(getCurrentUserUseCaseProvider);
    final user = await getCurrentUser();
    Future.microtask(() {
      ref.read(notificationsControllerProvider.notifier).syncPushToken();
    });
    return user;
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final loginUseCase = ref.read(loginUseCaseProvider);
      await loginUseCase(email: email, password: password);

      final getCurrentUser = ref.read(getCurrentUserUseCaseProvider);
      final user = await getCurrentUser();
      Future.microtask(() {
        ref.read(notificationsControllerProvider.notifier).requestPermissionContextual();
      });
      return user;
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // 1. Revoke push token before destroying local tokens / session
      await ref.read(notificationsControllerProvider.notifier).revokeAndCleanupToken();

      // 2. Clear remote and local auth session
      final logoutUseCase = ref.read(logoutUseCaseProvider);
      await logoutUseCase();
      // Invalidate borrower state so it doesn't leak across sessions.
      // Use a delayed invalidation to avoid provider not yet mounted errors.
      ref.invalidateSelf();
      return null;
    });
  }
}
