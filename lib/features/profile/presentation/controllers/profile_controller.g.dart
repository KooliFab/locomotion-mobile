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
    r'9a654c1085e644e4b6f470ec8e84e2040eb49f98';

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
