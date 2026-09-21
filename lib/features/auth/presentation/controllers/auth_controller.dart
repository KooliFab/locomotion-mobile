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

    try {
      final getCurrentUser = ref.watch(getCurrentUserUseCaseProvider);
      return await getCurrentUser();
    } catch (_) {
      return null;
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final loginUseCase = ref.read(loginUseCaseProvider);
      await loginUseCase(email: email, password: password);

      final getCurrentUser = ref.read(getCurrentUserUseCaseProvider);
      return await getCurrentUser();
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final logoutUseCase = ref.read(logoutUseCaseProvider);
      await logoutUseCase();
      return null;
    });
  }
}
