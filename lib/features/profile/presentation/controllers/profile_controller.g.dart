// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserBalanceController)
final userBalanceControllerProvider = UserBalanceControllerProvider._();

final class UserBalanceControllerProvider
    extends $AsyncNotifierProvider<UserBalanceController, double> {
  UserBalanceControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userBalanceControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userBalanceControllerHash();

  @$internal
  @override
  UserBalanceController create() => UserBalanceController();
}

String _$userBalanceControllerHash() =>
    r'ef4bb96bf7be9c87e940395792c5fe9be483a68d';

abstract class _$UserBalanceController extends $AsyncNotifier<double> {
  FutureOr<double> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<double>, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<double>, double>,
              AsyncValue<double>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
