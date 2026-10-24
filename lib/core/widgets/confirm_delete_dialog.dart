import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../l10n/app_l10n.dart';

/// Pregunta antes de borrar algo que no se puede recuperar.
///
/// El botón que borra va en rojo: es lo que avisa de que ese toque no tiene
/// vuelta atrás, y así todos los borrados de la app se ven igual.
abstract final class ConfirmDeleteDialog {
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmLabel,
  }) async {
    final AppL10n t = AppL10n.of(context);
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(t.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.dangerRed,
              foregroundColor: Colors.white,
            ),
            child: Text(confirmLabel ?? t.delete),
          ),
        ],
      ),
    );

    return confirmed ?? false;
  }
}
