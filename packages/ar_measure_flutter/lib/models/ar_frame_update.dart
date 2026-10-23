import 'dart:ui' show Offset, Size;

import 'package:vector_math/vector_math_64.dart';

import 'ar_hittest_result.dart';

/// One sampled AR frame, delivered while per-frame updates are enabled.
///
/// Carries what a Flutter overlay needs to draw annotations that stay glued to
/// the world: the hit under the reticle, plus the camera matrices required to
/// project world positions back to screen pixels.
class ARFrameUpdate {
  const ARFrameUpdate({
    required this.reticleHit,
    required this.viewMatrix,
    required this.projectionMatrix,
    required this.viewport,
  });

  /// What the reticle is currently aimed at, or null when nothing trackable
  /// is under it.
  final ARHitTestResult? reticleHit;

  /// World → camera space.
  final Matrix4 viewMatrix;

  /// Camera → clip space.
  final Matrix4 projectionMatrix;

  /// Size of the AR surface in device pixels.
  final Size viewport;

  /// Projects a world position to a pixel coordinate within [viewport].
  ///
  /// Returns null when the point sits behind the camera or outside the
  /// projection, so callers can skip drawing it.
  Offset? project(Vector3 world) {
    final clip = projectionMatrix *
        viewMatrix *
        Vector4(world.x, world.y, world.z, 1.0);
    final w = clip.w;
    if (w <= 0) return null; // behind the camera

    // Normalised device coords (-1..1) → pixels. Y is flipped because NDC
    // is bottom-up while screen coordinates are top-down.
    final ndcX = clip.x / w;
    final ndcY = clip.y / w;
    return Offset(
      (ndcX + 1) / 2 * viewport.width,
      (1 - ndcY) / 2 * viewport.height,
    );
  }

  static ARFrameUpdate? fromJson(Map<String, dynamic> json) {
    final view = _matrix(json['view']);
    final projection = _matrix(json['projection']);
    if (view == null || projection == null) return null;

    final rawHit = json['hit'];
    return ARFrameUpdate(
      reticleHit: rawHit == null
          ? null
          : ARHitTestResult.fromJson(Map<String, dynamic>.from(rawHit as Map)),
      viewMatrix: view,
      projectionMatrix: projection,
      viewport: Size(
        (json['viewportWidth'] as num?)?.toDouble() ?? 0,
        (json['viewportHeight'] as num?)?.toDouble() ?? 0,
      ),
    );
  }

  /// ARCore hands back column-major 16-element matrices, matching Matrix4's
  /// own storage order.
  static Matrix4? _matrix(Object? raw) {
    if (raw is! List || raw.length != 16) return null;
    return Matrix4.fromList(
      raw.map((e) => (e as num).toDouble()).toList(growable: false),
    );
  }
}
