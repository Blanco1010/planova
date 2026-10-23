package com.blancotech.planova

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.plugin.common.EventChannel
import kotlin.math.asin
import kotlin.math.atan2

/**
 * Hacia dónde apunta la cámara, usando la fusión de sensores de Android.
 *
 * Integrar el giroscopio a mano se va de sitio en segundos; el vector de
 * rotación del sistema junta giroscopio y acelerómetro y no deriva, que es
 * lo que hace falta para que un punto marcado se quede donde está.
 *
 * Emite [inclinación hacia abajo, rumbo], los dos en radianes. El rumbo
 * crece al girar a la derecha.
 */
class OrientationStreamHandler(context: Context) :
    EventChannel.StreamHandler, SensorEventListener {

    private val sensorManager =
        context.getSystemService(Context.SENSOR_SERVICE) as? SensorManager

    /** El de juego no usa la brújula: dentro de una obra, con tanto hierro, es más estable. */
    private val sensor: Sensor? =
        sensorManager?.getDefaultSensor(Sensor.TYPE_GAME_ROTATION_VECTOR)
            ?: sensorManager?.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR)

    private val rotationMatrix = FloatArray(9)
    private var events: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink?) {
        events = eventSink
        if (sensorManager == null || sensor == null) {
            eventSink?.error(
                "sin_sensor",
                "Este aparato no tiene sensor de rotación",
                null,
            )
            return
        }
        sensorManager.registerListener(this, sensor, SensorManager.SENSOR_DELAY_GAME)
    }

    override fun onCancel(arguments: Any?) {
        sensorManager?.unregisterListener(this)
        events = null
    }

    override fun onSensorChanged(event: SensorEvent) {
        val sink = events ?: return
        SensorManager.getRotationMatrixFromVector(rotationMatrix, event.values)

        // La cámara mira por la espalda del teléfono: (0, 0, -1) en ejes del
        // aparato, pasado al mundo con la matriz de rotación.
        val x = -rotationMatrix[2]
        val y = -rotationMatrix[5]
        val z = -rotationMatrix[8]

        val pitchDown = -asin(z.coerceIn(-1f, 1f)).toDouble()
        val heading = atan2(x, y).toDouble()

        sink.success(doubleArrayOf(pitchDown, heading))
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) = Unit
}
