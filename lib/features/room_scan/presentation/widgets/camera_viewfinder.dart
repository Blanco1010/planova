import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../providers/scan_providers.dart';

/// Visor de la cámara con la mira en el centro.
///
/// Si no hay cámara o el permiso está denegado, lo dice y deja la mira: la
/// medición es por sensores, la imagen solo sirve para apuntar.
class CameraViewfinder extends ConsumerWidget {
  const CameraViewfinder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<CameraController?> camera = ref.watch(
      cameraControllerProvider,
    );

    return ColoredBox(
      color: AppColors.darkNavy,
      child: Stack(
        fit: StackFit.expand,
        children: [
          camera.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (Object error, StackTrace _) =>
                _Unavailable(message: _messageFor(error)),
            data: (CameraController? controller) => controller == null
                ? const _Unavailable(
                    message:
                        'Este aparato no tiene cámara. Puedes medir igual '
                        'apuntando con el teléfono.',
                  )
                : FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: controller.value.previewSize?.height ?? 1,
                      height: controller.value.previewSize?.width ?? 1,
                      child: CameraPreview(controller),
                    ),
                  ),
          ),
          const Center(child: _Reticle()),
        ],
      ),
    );
  }

  String _messageFor(Object error) {
    if (error is CameraException &&
        (error.code == 'CameraAccessDenied' ||
            error.code == 'CameraAccessDeniedWithoutPrompt')) {
      return 'Planova no tiene permiso para la cámara. Puedes dárselo en los '
          'ajustes del teléfono, o medir igual apuntando sin ver la imagen.';
    }
    return 'No se pudo abrir la cámara. Puedes medir igual apuntando con el '
        'teléfono.';
  }
}

/// La cruz del centro: lo que se apunta al pie de la esquina.
class _Reticle extends StatelessWidget {
  const _Reticle();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: CustomPaint(painter: _ReticlePainter()),
    );
  }
}

class _ReticlePainter extends CustomPainter {
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
