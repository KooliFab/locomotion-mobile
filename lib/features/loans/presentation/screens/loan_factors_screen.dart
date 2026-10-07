import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/loan.dart';
import '../../domain/entities/loan_factors_update.dart';
import '../controllers/loan_factors_controller.dart';
import '../controllers/loans_controller.dart';

/// Mileage, expenses and their pictures, as in the web factors box.
/// Saved with `PUT /loans/{id}/factors`; validation stays on the loan screen.
class LoanFactorsScreen extends ConsumerWidget {
  final int loanId;

  const LoanFactorsScreen({super.key, required this.loanId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loanAsync = ref.watch(loanDetailProvider(loanId));
    return Scaffold(
      appBar: AppBar(title: const Text('Informations de retour')),
      body: loanAsync.when(
        data: (loan) => _LoanFactorsForm(loan: loan),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(e is AppException ? e.message : e.toString()),
          ),
        ),
      ),
    );
  }
}

class _LoanFactorsForm extends ConsumerStatefulWidget {
  final Loan loan;

  const _LoanFactorsForm({required this.loan});

  @override
  ConsumerState<_LoanFactorsForm> createState() => _LoanFactorsFormState();
}

class _LoanFactorsFormState extends ConsumerState<_LoanFactorsForm> {
  late final TextEditingController _mileageStart;
  late final TextEditingController _mileageEnd;
  late final TextEditingController _expenses;
  late final Map<String, Map<String, dynamic>?> _images;
  final Set<String> _uploading = {};
  bool _saving = false;
  String? _error;

  Loan get _loan => widget.loan;

  @override
  void initState() {
    super.initState();
    _mileageStart = TextEditingController(
      text: _loan.mileageStart?.toString() ?? '',
    );
    _mileageEnd = TextEditingController(
      text: _loan.mileageEnd?.toString() ?? '',
    );
    _expenses = TextEditingController(
      text: _loan.expensesAmount?.toStringAsFixed(2) ?? '',
    );
    _images = {
      LoanFactorsImageField.mileageStart: _loan.mileageStartImage,
      LoanFactorsImageField.mileageEnd: _loan.mileageEndImage,
      LoanFactorsImageField.expense: _loan.expenseImage,
    };
    WidgetsBinding.instance.addPostFrameCallback((_) => _recoverLostPhoto());
  }

  @override
  void dispose() {
    _mileageStart.dispose();
    _mileageEnd.dispose();
    _expenses.dispose();
    super.dispose();
  }

  int? get _userId => ref.read(authControllerProvider).value?.id;

  Future<void> _recoverLostPhoto() async {
    final userId = _userId;
    if (userId == null) return;
    final result = await ref
        .read(loanFactorsControllerProvider)
        .recoverLostCapture(userId: userId, loanId: _loan.id);
    if (result != null) _applyPhotoResult(result);
  }

  Future<void> _takePhoto(String field, ImageSource source) async {
    final userId = _userId;
    if (userId == null) return;
    setState(() => _uploading.add(field));
    final result = await ref
        .read(loanFactorsControllerProvider)
        .captureAndUpload(
          userId: userId,
          loanId: _loan.id,
          field: field,
          source: source,
        );
    if (!mounted) return;
    setState(() => _uploading.remove(field));
    _applyPhotoResult(result);
  }

  void _applyPhotoResult(FactorsPhotoResult result) {
    if (!mounted) return;
    switch (result) {
      case FactorsPhotoUploaded(:final field, :final image):
        setState(() => _images[field] = image);
      case FactorsPhotoFailed(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: AppColors.danger),
        );
      case FactorsPhotoCancelled():
        break;
    }
  }

  int? _parseInt(TextEditingController c) =>
      c.text.trim().isEmpty ? null : int.tryParse(c.text.trim());

  double? _parseAmount(TextEditingController c) => c.text.trim().isEmpty
      ? null
      : double.tryParse(c.text.trim().replaceAll(',', '.'));

  int? _imageId(String field) {
    final id = _images[field]?['id'];
    if (id is int) return id;
    if (id is String) return int.tryParse(id);
    return null;
  }

  String? _validate() {
    final start = _parseInt(_mileageStart);
    final end = _parseInt(_mileageEnd);
    if (_loan.needsDetailedMileage) {
      if (end != null && start == null) {
        return 'Indiquez le kilométrage au départ.';
      }
      if (start != null && end != null && end <= start) {
        return 'Le kilométrage au retour doit être supérieur à celui du départ.';
      }
      if (_imageId(LoanFactorsImageField.mileageEnd) != null && end == null) {
        return 'Indiquez le kilométrage au retour correspondant à la photo.';
      }
    }
    if (_loan.canAddExpenses &&
        _imageId(LoanFactorsImageField.expense) != null &&
        _parseAmount(_expenses) == null) {
      return 'Indiquez le montant des dépenses correspondant au reçu.';
    }
    return null;
  }

  Future<void> _save() async {
    final validationError = _validate();
    if (validationError != null) {
      setState(() => _error = validationError);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(loanFactorsControllerProvider)
          .save(
            _loan.id,
            LoanFactorsUpdate(
              mileageStart: _parseInt(_mileageStart),
              mileageStartImageId: _imageId(LoanFactorsImageField.mileageStart),
              mileageEnd: _parseInt(_mileageEnd),
              mileageEndImageId: _imageId(LoanFactorsImageField.mileageEnd),
              includeExpenses: _loan.canAddExpenses,
              expensesAmount: _parseAmount(_expenses),
              expenseImageId: _imageId(LoanFactorsImageField.expense),
            ),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informations enregistrées.'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).maybePop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e is AppException ? e.message : e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasFields = _loan.needsDetailedMileage || _loan.canAddExpenses;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (!hasFields)
          const Text(
            'Aucune information de kilométrage ou de dépense n\'est requise pour cet emprunt.',
          ),
        if (_loan.needsDetailedMileage) ...[
          _numberField(
            key: const Key('factors_mileage_start'),
            controller: _mileageStart,
            label: 'Kilométrage au départ',
            suffix: 'km',
          ),
          _photoButton(LoanFactorsImageField.mileageStart, 'Photo du compteur'),
          const SizedBox(height: 16),
          _numberField(
            key: const Key('factors_mileage_end'),
            controller: _mileageEnd,
            label: 'Kilométrage au retour',
            suffix: 'km',
          ),
          _photoButton(LoanFactorsImageField.mileageEnd, 'Photo du compteur'),
          const SizedBox(height: 16),
        ],
        if (_loan.canAddExpenses) ...[
          _numberField(
            key: const Key('factors_expenses'),
            controller: _expenses,
            label: 'Dépenses (essence, etc.)',
            suffix: '\$',
            decimal: true,
          ),
          _photoButton(LoanFactorsImageField.expense, 'Photo du reçu'),
          const SizedBox(height: 16),
        ],
        if (_error != null) ...[
          Container(
            key: const Key('factors_error'),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.dangerBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(_error!),
          ),
          const SizedBox(height: 12),
        ],
        if (hasFields)
          ElevatedButton(
            key: const Key('factors_save_button'),
            onPressed: _saving || _uploading.isNotEmpty ? null : _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Enregistrer'),
          ),
      ],
    );
  }

  Widget _numberField({
    required Key key,
    required TextEditingController controller,
    required String label,
    required String suffix,
    bool decimal = false,
  }) {
    return TextField(
      key: key,
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          decimal ? RegExp(r'[0-9.,]') : RegExp(r'[0-9]'),
        ),
      ],
      decoration: InputDecoration(labelText: label, suffixText: suffix),
    );
  }

  Widget _photoButton(String field, String label) {
    final hasImage = _images[field] != null;
    final uploading = _uploading.contains(field);
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              hasImage ? '$label ajoutée' : '$label (facultative)',
              style: TextStyle(
                color: hasImage ? AppColors.success : AppColors.textSecondary,
              ),
            ),
          ),
          if (uploading)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else ...[
            IconButton(
              key: Key('${field}_camera'),
              tooltip: 'Prendre une photo',
              icon: const Icon(Icons.photo_camera_outlined),
              onPressed: () => _takePhoto(field, ImageSource.camera),
            ),
            IconButton(
              tooltip: 'Choisir une photo',
              icon: const Icon(Icons.photo_library_outlined),
              onPressed: () => _takePhoto(field, ImageSource.gallery),
            ),
            if (hasImage)
              IconButton(
                tooltip: 'Retirer la photo',
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => _images[field] = null),
              ),
          ],
        ],
      ),
    );
  }
}
