import 'package:flutter_test/flutter_test.dart';
import 'package:planova/features/room_scan/data/services/fallback_orientation_tracker.dart';
import 'package:planova/features/room_scan/domain/entities/device_aim.dart';
import 'package:planova/features/room_scan/domain/services/orientation_tracker.dart';

/// Lector que funciona y entrega una orientación.
class _Working implements OrientationTracker {
  const _Working(this.pitch);

  final double pitch;

  @override
  Stream<DeviceAim> watch() async* {
    yield DeviceAim(pitchRadians: pitch, turnRadians: 0);
  }
}

/// Lector que no está disponible en este aparato.
class _Broken implements OrientationTracker {
  const _Broken();

  @override
  Stream<DeviceAim> watch() async* {
    throw StateError('sin sensor de rotación');
  }
}

void main() {
  test('manda el lector bueno cuando responde', () async {
    const FallbackOrientationTracker tracker = FallbackOrientationTracker(
      _Working(0.5),
      _Working(0.9),
    );

    final DeviceAim aim = await tracker.watch().first;

    expect(aim.pitchRadians, 0.5);
  });

  test('si el bueno falla, se pasa al de respaldo', () async {
    const FallbackOrientationTracker tracker = FallbackOrientationTracker(
      _Broken(),
      _Working(0.9),
    );

    final DeviceAim aim = await tracker.watch().first;

    expect(aim.pitchRadians, 0.9);
  });
}
