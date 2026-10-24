import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../l10n/app_l10n.dart';
import '../providers/scan_providers.dart';

/// La imagen de la cámara, entera y sin recortar.
///
/// Se enseña completa a propósito: el dibujo del plano se coloca encima
/// usando el ángulo que abarca la cámara, y si la imagen viniera recortada
/// ese ángulo ya no cuadraría.
class CameraViewfinder extends ConsumerWidget {
  const CameraViewfinder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppL10n t = AppL10n.of(context);
    final AsyncValue<CameraController?> camera = ref.watch(
      cameraControllerProvider,
    );

    return ColoredBox(
      color: Colors.black,
      child: camera.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace _) =>
            _Unavailable(message: _messageFor(t, error)),
        data: (CameraController? controller) => controller == null
            ? _Unavailable(message: t.noCamera)
            : CameraPreview(controller),
      ),
    );
  }

  String _messageFor(AppL10n t, Object error) {
    if (error is CameraException &&
        (error.code == 'CameraAccessDenied' ||
            error.code == 'CameraAccessDeniedWithoutPrompt')) {
      return t.cameraDenied;
    }
    return t.cameraFailed;
  }
}

/// La cruz del centro: lo que se apunta al pie de la esquina.
class ScanReticle extends StatelessWidget {
  const ScanReticle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 56,
        height: 56,
        child: CustomPaint(painter: _ReticlePainter()),
      ),
    );
  }
}

class _ReticlePainter extends CustomPainter {
  const _ReticlePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final Paint paint = Paint()
      ..color = AppColors.lightBlue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, 14, paint);
    canvas.drawLine(
      Offset(center.dx - 24, center.dy),
      Offset(center.dx - 4, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + 4, center.dy),
      Offset(center.dx + 24, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - 24),
      Offset(center.dx, center.dy - 4),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + 4),
      Offset(center.dx, center.dy + 24),
      paint,
    );
  }

  @override
  bool shouldRepaint(_ReticlePainter oldDelegate) => false;
}

class _Unavailable extends StatelessWidget {
  const _Unavailable({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: AppColors.mutedDark),
        ),
      ),
    );
  }
}
