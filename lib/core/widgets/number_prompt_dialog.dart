import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_l10n.dart';

/// Diálogo que pide un solo número y lo devuelve, o `null` si se cancela.
///
/// Tiene su propio estado a propósito: si el controlador del campo lo creara
/// quien abre el diálogo, se desecharía antes de que termine de cerrarse.
class NumberPromptDialog extends StatefulWidget {
  const NumberPromptDialog({
    required this.title,
    required this.label,
    required this.validator,
    required this.parse,
    this.helperText,
    this.prefixText,
    this.initialText,
    this.inputFormatters,
    super.key,
  });

  static Future<double?> show(
    BuildContext context, {
    required String title,
    required String label,
    required String? Function(String?) validator,
    required double? Function(String?) parse,
    String? helperText,
    String? prefixText,
    String? initialText,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return showDialog<double>(
      context: context,
      builder: (BuildContext dialogContext) => NumberPromptDialog(
        title: title,
        label: label,
        validator: validator,
        parse: parse,
        helperText: helperText,
        prefixText: prefixText,
        initialText: initialText,
        inputFormatters: inputFormatters,
      ),
    );
  }

  final String title;
  final String label;
  final String? Function(String?) validator;
  final double? Function(String?) parse;
  final String? helperText;
  final String? prefixText;
  final String? initialText;

  /// Lo que arregla el texto mientras se escribe, como separar los miles.
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<NumberPromptDialog> createState() => _NumberPromptDialogState();
}

class _NumberPromptDialogState extends State<NumberPromptDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialText ?? '',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppL10n t = AppL10n.of(context);

    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            labelText: widget.label,
            helperText: widget.helperText,
            prefixText: widget.prefixText,
          ),
          validator: widget.validator,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (!(_formKey.currentState?.validate() ?? false)) return;
            Navigator.of(context).pop(widget.parse(_controller.text));
          },
          child: Text(t.save),
        ),
      ],
    );
  }
}
