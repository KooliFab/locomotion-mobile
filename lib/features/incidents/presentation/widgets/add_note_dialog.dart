import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AddNoteDialog extends StatefulWidget {
  final Future<bool> Function(String text) onAddNote;

  const AddNoteDialog({super.key, required this.onAddNote});

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  final _textController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      setState(() => _errorMessage = 'Veuillez saisir un texte.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final success = await widget.onAddNote(text);
    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _isSubmitting = false;
        _errorMessage = 'Erreur lors de l\'enregistrement de la note.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter une note'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Indiquez toute précision, devis, intervention ou suivi sur cet incident :',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('incident_note_input'),
              controller: _textController,
              maxLines: 4,
              enabled: !_isSubmitting,
              decoration: InputDecoration(
                hintText: 'Ex: Remplacement effectué, véhicule opérationnel...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                errorText: _errorMessage,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting
              ? null
              : () => Navigator.of(context).pop(false),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          key: const Key('submit_note_button'),
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Ajouter'),
        ),
      ],
    );
  }
}
