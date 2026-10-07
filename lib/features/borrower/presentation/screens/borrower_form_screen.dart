import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/borrower_submission_request.dart';
import '../../domain/entities/uploaded_file_ref.dart';
import '../controllers/borrower_controller.dart';

/// A locally-tracked uploaded file (pending or uploaded).
class _LocalFile {
  final String name;
  final File file;
  UploadedFileRef? uploaded;
  bool isUploading;
  String? error;

  _LocalFile({required this.name, required this.file})
    : isUploading = false,
      uploaded = null,
      error = null;

  bool get isUploaded => uploaded != null;
}

class BorrowerFormScreen extends ConsumerStatefulWidget {
  const BorrowerFormScreen({super.key});

  @override
  ConsumerState<BorrowerFormScreen> createState() => _BorrowerFormScreenState();
}

class _BorrowerFormScreenState extends ConsumerState<BorrowerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _licenseController = TextEditingController();
  bool _licenseObscured = true;
  bool _attestation = false;
  bool _isSubmitting = false;
  String? _submitError;
  Map<String, List<String>>? _fieldErrors;

  final List<_LocalFile> _gaaFiles = [];
  final List<_LocalFile> _saaqFiles = [];

  @override
  void dispose() {
    _licenseController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    if (_licenseController.text.trim().isEmpty) return false;
    if (!_attestation) return false;
    if (_gaaFiles.isEmpty || _saaqFiles.isEmpty) return false;
    if (_gaaFiles.any((f) => !f.isUploaded)) return false;
    if (_saaqFiles.any((f) => !f.isUploaded)) return false;
    return true;
  }

  Future<void> _pickFile(String field) async {
    final picked = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (!mounted) return;
    if (picked == null || picked.path == null) return;

    final localFile = _LocalFile(name: picked.name, file: File(picked.path!));

    setState(() {
      if (field == 'gaa') {
        _gaaFiles.add(localFile);
      } else {
        _saaqFiles.add(localFile);
      }
    });

    await _uploadFile(field, localFile);
  }

  Future<void> _uploadFile(String field, _LocalFile localFile) async {
    if (!mounted) return;
    setState(() {
      localFile.isUploading = true;
      localFile.error = null;
    });

    try {
      final ref_ = ref.read(borrowerControllerProvider.notifier);
      final uploaded = await ref_.uploadFile(
        field: field,
        file: localFile.file,
      );
      if (!mounted) return;
      setState(() {
        localFile.uploaded = uploaded;
        localFile.isUploading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        localFile.isUploading = false;
        localFile.error = _friendlyError(e);
      });
    }
  }

  void _removeFile(String field, _LocalFile localFile) {
    setState(() {
      if (field == 'gaa') {
        _gaaFiles.remove(localFile);
      } else {
        _saaqFiles.remove(localFile);
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_canSubmit) return;

    final user = ref.read(authControllerProvider).value;
    if (user == null) return;

    setState(() {
      _isSubmitting = true;
      _submitError = null;
      _fieldErrors = null;
    });

    final request = BorrowerSubmissionRequest(
      userId: user.id,
      driversLicenseNumber: _licenseController.text.trim(),
      hasNotBeenSuedLastTenYears: _attestation,
      gaa: _gaaFiles
          .where((f) => f.uploaded != null)
          .map((f) => FileIdRef(id: f.uploaded!.id))
          .toList(),
      saaq: _saaqFiles
          .where((f) => f.uploaded != null)
          .map((f) => FileIdRef(id: f.uploaded!.id))
          .toList(),
    );

    try {
      await ref.read(borrowerControllerProvider.notifier).submit(request);
      if (!mounted) return;
      context.go(AppRoutes.borrower);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dossier soumis avec succès !'),
          backgroundColor: AppColors.success,
        ),
      );
    } on UnauthorizedException {
      if (!mounted) return;
      ref.read(authControllerProvider.notifier).logout();
      context.go(AppRoutes.login);
    } on ForbiddenException catch (e) {
      if (!mounted) return;
      setState(() {
        _submitError = e.message;
        _isSubmitting = false;
      });
    } on ValidationException catch (e) {
      if (!mounted) return;
      // Preserve local form content — do NOT mark as submitted.
      final errors = <String, List<String>>{};
      if (e.errors != null) {
        e.errors!.forEach((key, value) {
          if (value is List) {
            errors[key] = value.map((v) => v.toString()).toList();
          }
        });
      }
      setState(() {
        _fieldErrors = errors;
        _submitError = e.message;
        _isSubmitting = false;
      });
    } on NetworkException {
      if (!mounted) return;
      // Network error: allow retry, do NOT deduce submission succeeded.
      setState(() {
        _submitError = 'Erreur réseau. Vérifiez votre connexion et réessayez.';
        _isSubmitting = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _submitError = 'Une erreur inattendue est survenue.';
        _isSubmitting = false;
      });
    }
  }

  String _friendlyError(Object e) {
    if (e is NetworkException) return 'Erreur réseau — réessayez.';
    if (e is ValidationException) return e.message;
    if (e is AppException) return e.message;
    return 'Erreur d\'envoi.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compléter mon dossier'),
        leading: BackButton(onPressed: () => context.go(AppRoutes.borrower)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // License number
            const Text(
              'Numéro de permis de conduire',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _licenseController,
              obscureText: _licenseObscured,
              decoration: InputDecoration(
                hintText: 'Ex: A12345-678901-23',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _licenseObscured
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () =>
                      setState(() => _licenseObscured = !_licenseObscured),
                  tooltip: _licenseObscured ? 'Afficher' : 'Masquer',
                ),
                errorText: _fieldErrors?['drivers_license_number']?.first,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Le numéro de permis est requis';
                }
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),

            // Attestation
            Card(
              elevation: 0,
              color: AppColors.surface,
              child: CheckboxListTile(
                value: _attestation,
                onChanged: (v) => setState(() => _attestation = v ?? false),
                title: const Text(
                  'J\'atteste ne pas avoir fait l\'objet de poursuites judiciaires au cours des dix dernières années.',
                  style: TextStyle(fontSize: 13),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),

            // GAA Files
            _FileSection(
              title: 'Document GAA',
              subtitle: 'Pièce d\'identité (PDF, JPG, PNG)',
              field: 'gaa',
              files: _gaaFiles,
              onPickFile: () => _pickFile('gaa'),
              onRemoveFile: (f) => _removeFile('gaa', f),
              onRetryFile: (f) => _uploadFile('gaa', f),
              fieldError: _fieldErrors?['gaa']?.first,
            ),
            const SizedBox(height: 16),

            // SAAQ Files
            _FileSection(
              title: 'Document SAAQ',
              subtitle: 'Dossier de conduite (PDF, JPG, PNG)',
              field: 'saaq',
              files: _saaqFiles,
              onPickFile: () => _pickFile('saaq'),
              onRemoveFile: (f) => _removeFile('saaq', f),
              onRetryFile: (f) => _uploadFile('saaq', f),
              fieldError: _fieldErrors?['saaq']?.first,
            ),
            const SizedBox(height: 24),

            // Submit error
            if (_submitError != null) ...[
              Card(
                elevation: 0,
                color: AppColors.dangerBg,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.danger),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _submitError!,
                          style: const TextStyle(color: AppColors.danger),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Submit button
            ElevatedButton(
              onPressed: (_canSubmit && !_isSubmitting) ? _submit : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Soumettre le dossier'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _FileSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final String field;
  final List<_LocalFile> files;
  final VoidCallback onPickFile;
  final void Function(_LocalFile) onRemoveFile;
  final void Function(_LocalFile) onRetryFile;
  final String? fieldError;

  const _FileSection({
    required this.title,
    required this.subtitle,
    required this.field,
    required this.files,
    required this.onPickFile,
    required this.onRemoveFile,
    required this.onRetryFile,
    this.fieldError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 8),
        ...files.map(
          (f) => _FileTile(
            localFile: f,
            onRemove: () => onRemoveFile(f),
            onRetry: () => onRetryFile(f),
          ),
        ),
        if (fieldError != null) ...[
          const SizedBox(height: 4),
          Text(
            fieldError!,
            style: const TextStyle(color: AppColors.danger, fontSize: 12),
          ),
        ],
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onPickFile,
          icon: const Icon(Icons.attach_file_rounded),
          label: Text('Ajouter un fichier ${field.toUpperCase()}'),
        ),
      ],
    );
  }
}

class _FileTile extends StatelessWidget {
  final _LocalFile localFile;
  final VoidCallback onRemove;
  final VoidCallback onRetry;

  const _FileTile({
    required this.localFile,
    required this.onRemove,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      color: localFile.error != null ? AppColors.dangerBg : AppColors.surface,
      child: ListTile(
        dense: true,
        leading: localFile.isUploading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                localFile.isUploaded
                    ? Icons.check_circle_rounded
                    : Icons.error_outline_rounded,
                color: localFile.isUploaded
                    ? AppColors.success
                    : AppColors.danger,
                size: 20,
              ),
        title: Text(
          localFile.name,
          style: const TextStyle(fontSize: 13),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: localFile.error != null
            ? Text(
                localFile.error!,
                style: const TextStyle(color: AppColors.danger, fontSize: 11),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (localFile.error != null)
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: onRetry,
                tooltip: 'Réessayer',
                iconSize: 18,
              ),
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: onRemove,
              tooltip: 'Supprimer',
              iconSize: 18,
            ),
          ],
        ),
      ),
    );
  }
}
