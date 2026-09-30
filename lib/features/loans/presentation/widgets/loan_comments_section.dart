import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/loan.dart';
import '../../domain/entities/loan_comment.dart';
import 'loan_status_helper.dart';

class LoanCommentsSection extends StatelessWidget {
  final Loan loan;
  final bool isSubmitting;
  final Future<void> Function(String)? onAddComment;

  const LoanCommentsSection({
    super.key,
    required this.loan,
    this.isSubmitting = false,
    this.onAddComment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.chat_bubble_outline_rounded,
                    size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Messages et commentaires (${loan.comments.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (loan.comments.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Aucun message pour cette réservation.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: loan.comments.length,
                separatorBuilder: (_, _) => const Divider(height: 16),
                itemBuilder: (context, index) {
                  final comment = loan.comments[index];
                  return _CommentBubble(comment: comment);
                },
              ),
            if (onAddComment != null) ...[
              const SizedBox(height: 16),
              _NewCommentInput(
                isSubmitting: isSubmitting,
                onSubmit: onAddComment!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CommentBubble extends StatelessWidget {
  final LoanComment comment;

  const _CommentBubble({required this.comment});

  @override
  Widget build(BuildContext context) {
    final author = comment.authorName ?? 'Utilisateur';
    final dateStr = comment.createdAt != null
        ? LoanDateFormatter.formatInVehicleZone(comment.createdAt)
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              author,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
            if (dateStr.isNotEmpty)
              Text(
                dateStr,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          comment.text ?? '',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _NewCommentInput extends StatefulWidget {
  final bool isSubmitting;
  final Future<void> Function(String) onSubmit;

  const _NewCommentInput({
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  State<_NewCommentInput> createState() => _NewCommentInputState();
}

class _NewCommentInputState extends State<_NewCommentInput> {
  final _controller = TextEditingController();
  String? _clientValidationError;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() {
        _clientValidationError = 'Le commentaire ne peut pas être vide.';
      });
      return;
    }
    if (text.length > 1024) {
      setState(() {
        _clientValidationError =
            'Le commentaire ne doit pas dépasser 1024 caractères (actuellement ${text.length}).';
      });
      return;
    }

    setState(() {
      _clientValidationError = null;
    });

    try {
      await widget.onSubmit(text);
      if (mounted) {
        _controller.clear();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _clientValidationError = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: const Key('comment_input_field'),
          controller: _controller,
          enabled: !widget.isSubmitting,
          maxLength: 1024,
          maxLines: 3,
          minLines: 1,
          onChanged: (_) {
            if (_clientValidationError != null) {
              setState(() {
                _clientValidationError = null;
              });
            }
          },
          decoration: InputDecoration(
            hintText: 'Écrire un message ou un commentaire...',
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            errorText: _clientValidationError,
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            key: const Key('submit_comment_button'),
            onPressed: widget.isSubmitting ? null : _submit,
            icon: widget.isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.send_rounded, size: 16),
            label: const Text('Envoyer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
