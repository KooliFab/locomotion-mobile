import 'package:flutter/material.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/loan.dart';

enum OwnerDecisionType {
  accept,
  reject,
}

class OwnerDecisionDialog extends StatefulWidget {
  final Loan loan;
  final OwnerDecisionType decisionType;
  final Future<void> Function(String? comment) onConfirm;
  final VoidCallback? onAccessLost;
  final VoidCallback? onSwitchToReject;

  const OwnerDecisionDialog({
    super.key,
    required this.loan,
    required this.decisionType,
    required this.onConfirm,
    this.onAccessLost,
    this.onSwitchToReject,
  });

  @override
  State<OwnerDecisionDialog> createState() => _OwnerDecisionDialogState();
}

class _OwnerDecisionDialogState extends State<OwnerDecisionDialog> {
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAccessLost = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  bool get _isAccept => widget.decisionType == OwnerDecisionType.accept;

  Future<void> _submit() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _isAccessLost = false;
    });

    final commentText = _commentController.text.trim();
    final comment = commentText.isNotEmpty ? commentText : null;

    try {
      await widget.onConfirm(comment);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          if (e is ServerException && e.statusCode == 422) {
            _errorMessage = e.message.isNotEmpty
                ? e.message
                : 'Le véhicule n\'est pas disponible sur cette période.';
          } else if (e is ForbiddenException ||
              (e is ServerException && (e.statusCode == 403 || e.statusCode == 404))) {
            _isAccessLost = true;
            _errorMessage =
                'Cette demande n\'est plus disponible ou a déjà été traitée.';
          } else if (e is AppException) {
            _errorMessage = e.message;
          } else {
            _errorMessage = 'Une erreur inattendue est survenue. Veuillez réessayer.';
          }
        });
        if (_isAccessLost) {
          widget.onAccessLost?.call();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _isAccept ? 'Accepter la demande' : 'Refuser la demande';
    final actionLabel = _isAccept ? 'Confirmer l\'acceptation' : 'Confirmer le refus';
    final actionColor = _isAccept ? AppColors.success : AppColors.danger;
    final hintText = _isAccept
        ? 'Ajouter un mot pour l\'emprunteur (facultatif)...'
        : 'Indiquer un motif de refus pour l\'emprunteur (conseillé)...';

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            _isAccept
                ? Icons.check_circle_outline_rounded
                : Icons.cancel_outlined,
            color: actionColor,
            size: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isAccept
                  ? 'Vous vous apprêtez à accepter la demande de prêt pour "${widget.loan.displayLoanableName}".'
                  : 'Vous vous apprêtez à refuser la demande de prêt pour "${widget.loan.displayLoanableName}".',
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            if (_errorMessage != null) ...[
              Container(
                key: const Key('owner_decision_dialog_error'),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.dangerBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: AppColors.danger,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    if (_isAccept && !_isAccessLost) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            key: const Key('dialog_422_reject_button'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.danger,
                              side: const BorderSide(color: AppColors.danger),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                            icon: const Icon(Icons.cancel_outlined, size: 14),
                            label: const Text(
                              'Refuser',
                              style: TextStyle(fontSize: 12),
                            ),
                            onPressed: _isLoading
                                ? null
                                : () {
                                    Navigator.of(context).pop(false);
                                    widget.onSwitchToReject?.call();
                                  },
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            key: const Key('dialog_422_retry_button'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                            icon: const Icon(Icons.refresh_rounded, size: 14),
                            label: const Text(
                              'Réessayer',
                              style: TextStyle(fontSize: 12),
                            ),
                            onPressed: _isLoading ? null : _submit,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            Text(
              _isAccept ? 'Commentaire (facultatif)' : 'Motif / Commentaire (conseillé)',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              key: const Key('owner_decision_comment_input'),
              controller: _commentController,
              enabled: !_isLoading,
              maxLines: 3,
              maxLength: 1024,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          key: const Key('owner_decision_cancel_dialog_button'),
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: const Text('Retour'),
        ),
        ElevatedButton(
          key: Key(
            _isAccept
                ? 'owner_decision_confirm_accept_button'
                : 'owner_decision_confirm_reject_button',
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: actionColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(actionLabel),
        ),
      ],
    );
  }
}
