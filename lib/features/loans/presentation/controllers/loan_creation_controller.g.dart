// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_creation_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoanCreationController)
final loanCreationControllerProvider = LoanCreationControllerFamily._();

final class LoanCreationControllerProvider
    extends $NotifierProvider<LoanCreationController, LoanCreationState> {
  LoanCreationControllerProvider._({
    required LoanCreationControllerFamily super.from,
    required LoanDraft super.argument,
  }) : super(
         retry: null,
         name: r'loanCreationControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loanCreationControllerHash();

  @override
  String toString() {
    return r'loanCreationControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  LoanCreationController create() => LoanCreationController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoanCreationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoanCreationState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LoanCreationControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loanCreationControllerHash() =>
    r'a287a46ef33a246296f518c3f7671dfbf36a4c1b';

final class LoanCreationControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          LoanCreationController,
          LoanCreationState,
          LoanCreationState,
          LoanCreationState,
          LoanDraft
        > {
  LoanCreationControllerFamily._()
    : super(
        retry: null,
        name: r'loanCreationControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoanCreationControllerProvider call(LoanDraft initialDraft) =>
      LoanCreationControllerProvider._(argument: initialDraft, from: this);

  @override
  String toString() => r'loanCreationControllerProvider';
}

abstract class _$LoanCreationController extends $Notifier<LoanCreationState> {
  late final _$args = ref.$arg as LoanDraft;
  LoanDraft get initialDraft => _$args;

  LoanCreationState build(LoanDraft initialDraft);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<LoanCreationState, LoanCreationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LoanCreationState, LoanCreationState>,
              LoanCreationState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
