package com.blancotech.planova

import android.content.Context
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.util.SizeF
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlin.math.atan

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, ORIENTATION_CHANNEL)
            .setStreamHandler(OrientationStreamHandler(applicationContext))

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CAMERA_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "fieldOfView" -> result.success(backCameraFieldOfView())
                    else -> result.notImplemented()
                }
            }
    }

    /**
     * Cuánto abarca la cámara trasera, en radianes: [ancho, alto].
     *
     * Sale del tamaño del sensor y de la distancia focal, así que es el
     * ángulo de verdad del aparato y no hay que estimarlo. Devuelve null si
     * la cámara no lo publica.
     */
    private fun backCameraFieldOfView(): DoubleArray? {
        val manager = getSystemService(Context.CAMERA_SERVICE) as? CameraManager ?: return null

        return try {
            manager.cameraIdList.asSequence()
                .map { manager.getCameraCharacteristics(it) }
                .filter { it.get(CameraCharacteristics.LENS_FACING) == CameraCharacteristics.LENS_FACING_BACK }
                .mapNotNull { characteristics ->
                    val size: SizeF =
                        characteristics.get(CameraCharacteristics.SENSOR_INFO_PHYSICAL_SIZE)
                            ?: return@mapNotNull null
                    val focal =
                        characteristics.get(CameraCharacteristics.LENS_INFO_AVAILABLE_FOCAL_LENGTHS)
                            ?.firstOrNull()
                            ?: return@mapNotNull null
                    if (focal <= 0f) return@mapNotNull null

                    doubleArrayOf(
                        2.0 * atan((size.width / 2.0) / focal),
                        2.0 * atan((size.height / 2.0) / focal),
                    )
                }
                .firstOrNull()
        } catch (error: Exception) {
            null
        }
    }

    companion object {
        private const val ORIENTATION_CHANNEL = "planova/orientation"
        private const val CAMERA_CHANNEL = "planova/camera"
    }
}
