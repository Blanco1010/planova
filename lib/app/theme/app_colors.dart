import 'package:flutter/material.dart';

/// Paleta de marca de Planova.
///
/// Los cinco primeros colores son los de la identidad; el resto son tonos
/// derivados que se usan para bordes, texto secundario y superficies.
abstract final class AppColors {
  /// Azul principal: botones, herramienta activa y acciones destacadas.
  static const Color primaryBlue = Color(0xFF2563EB);

  /// Azul profundo: logotipo, títulos destacados y elementos de marca.
  static const Color deepBlue = Color(0xFF1E3A8A);

  /// Azul claro: guías de medición, selección secundaria y detalles gráficos.
  static const Color lightBlue = Color(0xFF60A5FA);

  /// Fondo claro de pantallas y paneles.
  static const Color lightBackground = Color(0xFFF1F5F9);

  /// Azul oscuro: texto principal y base del tema oscuro.
  static const Color darkNavy = Color(0xFF0F172A);

  /// Rojo de borrar: fondo del botón que no tiene vuelta atrás.
  ///
  /// Es el mismo en los dos temas, con texto blanco encima, para que ese
  /// botón se vea rojo también de noche.
  static const Color dangerRed = Color(0xFFDC2626);

  /// El mismo rojo aclarado, para avisos escritos sobre fondo oscuro.
  static const Color dangerRedDark = Color(0xFFF87171);

  // --- Tonos derivados ---

  /// Superficie de tarjetas y hojas en tema claro.
  static const Color lightSurface = Color(0xFFFFFFFF);

  /// Superficie de tarjetas y hojas en tema oscuro.
  static const Color darkSurface = Color(0xFF16233C);

  /// Fondo hundido (campos de texto) en tema oscuro.
  static const Color darkSunken = Color(0xFF0B1220);

  /// Texto secundario en tema claro.
  static const Color mutedLight = Color(0xFF64748B);

  /// Texto secundario en tema oscuro.
  static const Color mutedDark = Color(0xFF94A3B8);

  /// Línea divisoria en tema claro.
  static const Color borderLight = Color(0xFFE2E8F0);

  /// Línea divisoria en tema oscuro.
  static const Color borderDark = Color(0xFF26354F);

  /// Texto sobre fondo oscuro.
  static const Color onDark = Color(0xFFE8EDF5);
}
