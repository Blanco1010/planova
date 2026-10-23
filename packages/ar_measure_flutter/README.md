# ar_measure_flutter

AR for Flutter with the two primitives you need to build a **measuring** experience —
the Apple-Measure style "aim a reticle, tap to place" flow — on ARCore and ARKit.

Most Flutter AR plugins surface only a *tap* hit test, and give you no way to draw
Flutter widgets that stay attached to the real world. This package adds:

| Capability | Why it matters |
|---|---|
| **Hit test at any screen point** | Drives a crosshair/reticle that continuously reports what it is aimed at, without waiting for a tap. |
| **Per-frame camera matrices** | Lets you project world positions back to screen pixels, so Flutter-drawn lines and labels stay glued to the object as the camera moves. |

Both arrive on one throttled native callback, so a live reticle costs a single
message per sample rather than a method-channel round-trip every frame.

> **Fork notice.** This is a fork of
> [`ar_flutter_plugin_2`](https://pub.dev/packages/ar_flutter_plugin_2) by Hugo Lefèvre,
> itself a fork of the original `ar_flutter_plugin`. All of the original AR session,
> anchor, object and cloud-anchor functionality is retained and unmodified — this fork
> exists to add the two capabilities above. Licensed MIT, with the upstream copyright
> preserved in [LICENSE](LICENSE).

## Install

```yaml
dependencies:
  ar_measure_flutter: ^0.1.0
```

## The additions

### Per-frame updates

Enable a throttled stream of AR state. `x` / `y` are the reticle position in
**device pixels** — screen centre is the usual choice.

```dart
sessionManager.onFrameUpdate = (ARFrameUpdate? update) {
  final hit = update?.reticleHit;               // null when not on a surface
  final world = hit?.worldTransform.getTranslation();
};

final media = MediaQuery.of(context);
final size = media.size * media.devicePixelRatio;
await sessionManager.setFrameUpdates(
  true,
  x: size.width / 2,
  y: size.height / 2,
  hz: 20,
);
```

Stop the stream when leaving the screen:

```dart
await sessionManager.setFrameUpdates(false);
```

### Projecting world → screen

`ARFrameUpdate.project()` converts a world position to a pixel coordinate inside
`viewport`, or null when the point is behind the camera.

```dart
final projected = update.project(worldPosition);
if (projected != null) {
  // viewport is device pixels; Flutter lays out in logical pixels
  final dpr = MediaQuery.devicePixelRatioOf(context);
  final onScreen = Offset(projected.dx / dpr, projected.dy / dpr);
}
```

This is what keeps a `CustomPainter` overlay attached to the real world: store
**world** positions only and re-project them every frame. Storing the pixel
coordinate captured at placement time looks correct until the camera moves.

### One-shot hit test

For a single probe without enabling the stream:

```dart
final hit = await sessionManager.hitTestAtScreenPosition(x, y);
```

## Platform support

| | Android | iOS |
|---|---|---|
| Screen-point hit test | ✅ ARCore | ⚠️ not yet wired |
| Camera matrices | ✅ ARCore | ⚠️ not yet wired |
| All original plugin features | ✅ | ✅ |

The new APIs are implemented on **Android (ARCore)** today. The ARKit equivalents
exist (`ARSCNView.hitTest`, `camera.projectionMatrix`) but are not yet bridged —
contributions welcome. Everything inherited from upstream works unchanged on both
platforms.

## Requirements

- Android: an ARCore-capable device
- A physical device — AR does not run in emulators or the iOS Simulator

## Credits

- Original plugin: [`ar_flutter_plugin`](https://github.com/CariusLars/ar_flutter_plugin)
- Direct upstream: [`ar_flutter_plugin_2`](https://github.com/hlefe/ar_flutter_plugin_2) by Hugo Lefèvre
