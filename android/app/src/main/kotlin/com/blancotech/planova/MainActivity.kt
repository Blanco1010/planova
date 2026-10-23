package com.blancotech.planova

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorManager
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.os.SystemClock
import android.util.SizeF
import com.google.ar.core.ArCoreApk
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

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SENSORS_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "hasTurnSensor" -> result.success(hasTurnSensor())
                    "hasArCore" -> result.success(hasArCore())
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

    /**
     * Si el aparato puede saber hacia dónde se gira.
     *
     * Sin giroscopio ni brújula no hay manera: los teléfonos de gama de
     * entrada suelen traer solo acelerómetro, y entonces levantar un plano
     * girando sobre uno mismo es imposible. Más vale decirlo que dibujar
     * cualquier cosa.
     */
    private fun hasTurnSensor(): Boolean {
        val manager = getSystemService(Context.SENSOR_SERVICE) as? SensorManager
            ?: return false

        return manager.getDefaultSensor(Sensor.TYPE_GAME_ROTATION_VECTOR) != null ||
            manager.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR) != null ||
            manager.getDefaultSensor(Sensor.TYPE_GYROSCOPE) != null
    }

    /**
     * Si este teléfono puede usar ARCore, que es lo que mide de verdad con
     * la cámara y sigue los pasos de quien mide.
     *
     * La primera consulta puede tardar un momento en resolverse, así que se
     * espera un poco antes de darla por perdida.
     */
    private fun hasArCore(): Boolean {
        return try {
            val deadline = SystemClock.elapsedRealtime() + 1_500
            var availability = ArCoreApk.getInstance().checkAvailability(this)
            while (availability.isTransient && SystemClock.elapsedRealtime() < deadline) {
                Thread.sleep(100)
                availability = ArCoreApk.getInstance().checkAvailability(this)
            }
            availability.isSupported
        } catch (error: Exception) {
            false
        }
    }

    companion object {
        private const val ORIENTATION_CHANNEL = "planova/orientation"
        private const val CAMERA_CHANNEL = "planova/camera"
        private const val SENSORS_CHANNEL = "planova/sensors"
    }
}
