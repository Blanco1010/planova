# Copia parcheada de ar_measure_flutter 0.1.1

Esta carpeta es el paquete [`ar_measure_flutter`](https://pub.dev/packages/ar_measure_flutter)
tal como viene de pub.dev, con un cambio.

## Qué se cambió

`android/.../ArView.kt`, en `hitAtScreenPosition`: el sondeo acepta ahora los
puntos de profundidad (`DepthPoint`) de ARCore, y los prefiere antes que la
prolongación imaginaria de un plano.

## Por qué

El original solo aceptaba planos y puntos de textura. En una pared lisa y
pintada ARCore no encuentra ni una cosa ni la otra, así que la mira no
enganchaba nada y no se podía marcar. Los puntos de profundidad sí responden
ahí, y los teléfonos de los últimos años los dan.

## Al actualizar el paquete

Si algún día se vuelve a la versión de pub.dev, hay que comprobar que ese
sondeo siga aceptando `DepthPoint`, o la pared dejará de poder marcarse.
