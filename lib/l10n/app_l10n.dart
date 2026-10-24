import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_l10n_en.dart';
import 'app_l10n_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppL10n
/// returned by `AppL10n.of(context)`.
///
/// Applications need to include `AppL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppL10n.localizationsDelegates,
///   supportedLocales: AppL10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppL10n.supportedLocales
/// property.
abstract class AppL10n {
  AppL10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n)!;
  }

  static const LocalizationsDelegate<AppL10n> delegate = _AppL10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @saveChanges.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get saveChanges;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @settingsTitle.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In es, this message translates to:
  /// **'Apariencia'**
  String get settingsAppearance;

  /// No description provided for @optionSystem.
  ///
  /// In es, this message translates to:
  /// **'Igual que el sistema'**
  String get optionSystem;

  /// No description provided for @themeLight.
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get themeDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get settingsLanguage;

  /// No description provided for @languageSpanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageEnglish.
  ///
  /// In es, this message translates to:
  /// **'Inglés'**
  String get languageEnglish;

  /// No description provided for @settingsCurrency.
  ///
  /// In es, this message translates to:
  /// **'Moneda'**
  String get settingsCurrency;

  /// No description provided for @currencyNote.
  ///
  /// In es, this message translates to:
  /// **'Cambia cómo se escriben los precios. No los convierte: lo que está escrito sigue valiendo lo mismo.'**
  String get currencyNote;

  /// No description provided for @currencyCop.
  ///
  /// In es, this message translates to:
  /// **'Peso colombiano'**
  String get currencyCop;

  /// No description provided for @currencyUsd.
  ///
  /// In es, this message translates to:
  /// **'Dólar'**
  String get currencyUsd;

  /// No description provided for @settingsTesting.
  ///
  /// In es, this message translates to:
  /// **'Pruebas'**
  String get settingsTesting;

  /// No description provided for @demoTitle.
  ///
  /// In es, this message translates to:
  /// **'Cargar un proyecto de ejemplo'**
  String get demoTitle;

  /// No description provided for @demoBody.
  ///
  /// In es, this message translates to:
  /// **'Crea una casa con tres habitaciones, precios y acabados para ver el presupuesto y el PDF sin medir nada.'**
  String get demoBody;

  /// No description provided for @demoDone.
  ///
  /// In es, this message translates to:
  /// **'Listo: «{project}» está en tus proyectos.'**
  String demoDone(String project);

  /// No description provided for @demoFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo crear el ejemplo: {error}'**
  String demoFailed(String error);

  /// No description provided for @projectsLoadError.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron leer los proyectos'**
  String get projectsLoadError;

  /// No description provided for @projectsEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay proyectos'**
  String get projectsEmptyTitle;

  /// No description provided for @projectsEmptyBody.
  ///
  /// In es, this message translates to:
  /// **'Crea el primero para empezar a guardar habitaciones, planos y presupuestos.'**
  String get projectsEmptyBody;

  /// No description provided for @newProject.
  ///
  /// In es, this message translates to:
  /// **'Nuevo proyecto'**
  String get newProject;

  /// No description provided for @editProject.
  ///
  /// In es, this message translates to:
  /// **'Editar proyecto'**
  String get editProject;

  /// No description provided for @createProject.
  ///
  /// In es, this message translates to:
  /// **'Crear proyecto'**
  String get createProject;

  /// No description provided for @deleteProject.
  ///
  /// In es, this message translates to:
  /// **'Eliminar proyecto'**
  String get deleteProject;

  /// No description provided for @deleteProjectMessage.
  ///
  /// In es, this message translates to:
  /// **'Se borrará «{project}» y todo lo que guardes dentro. Esto no se puede deshacer.'**
  String deleteProjectMessage(String project);

  /// No description provided for @updatedOn.
  ///
  /// In es, this message translates to:
  /// **'Actualizado el {date}'**
  String updatedOn(String date);

  /// No description provided for @projectName.
  ///
  /// In es, this message translates to:
  /// **'Nombre del proyecto'**
  String get projectName;

  /// No description provided for @projectNameHint.
  ///
  /// In es, this message translates to:
  /// **'Casa de dos pisos, remodelación cocina…'**
  String get projectNameHint;

  /// No description provided for @projectNameRequired.
  ///
  /// In es, this message translates to:
  /// **'Ponle un nombre al proyecto'**
  String get projectNameRequired;

  /// No description provided for @client.
  ///
  /// In es, this message translates to:
  /// **'Cliente'**
  String get client;

  /// No description provided for @address.
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get address;

  /// No description provided for @notes.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get notes;

  /// No description provided for @projectCreated.
  ///
  /// In es, this message translates to:
  /// **'Proyecto creado'**
  String get projectCreated;

  /// No description provided for @projectUpdated.
  ///
  /// In es, this message translates to:
  /// **'Proyecto actualizado'**
  String get projectUpdated;

  /// No description provided for @saveFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo guardar: {error}'**
  String saveFailed(String error);

  /// No description provided for @projectGone.
  ///
  /// In es, this message translates to:
  /// **'El proyecto ya no existe'**
  String get projectGone;

  /// No description provided for @roomsLoadError.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron leer las habitaciones: {error}'**
  String roomsLoadError(String error);

  /// No description provided for @materials.
  ///
  /// In es, this message translates to:
  /// **'Materiales'**
  String get materials;

  /// No description provided for @materialsCardBody.
  ///
  /// In es, this message translates to:
  /// **'Bloques o ladrillos, mortero, pintura y piso con tus rendimientos'**
  String get materialsCardBody;

  /// No description provided for @budget.
  ///
  /// In es, this message translates to:
  /// **'Presupuesto'**
  String get budget;

  /// No description provided for @budgetCardBody.
  ///
  /// In es, this message translates to:
  /// **'Precios, mano de obra y costo por m²'**
  String get budgetCardBody;

  /// No description provided for @rooms.
  ///
  /// In es, this message translates to:
  /// **'Habitaciones'**
  String get rooms;

  /// No description provided for @roomsEmptyBody.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay habitaciones. Crea la primera con su ancho y su largo, y luego ajusta el plano pared por pared.'**
  String get roomsEmptyBody;

  /// No description provided for @newRoom.
  ///
  /// In es, this message translates to:
  /// **'Nueva habitación'**
  String get newRoom;

  /// No description provided for @measureWithCamera.
  ///
  /// In es, this message translates to:
  /// **'Medir con la cámara'**
  String get measureWithCamera;

  /// No description provided for @measureWithCameraBody.
  ///
  /// In es, this message translates to:
  /// **'Apunta al pie de cada esquina y sale el plano'**
  String get measureWithCameraBody;

  /// No description provided for @typeMeasurements.
  ///
  /// In es, this message translates to:
  /// **'Escribir las medidas'**
  String get typeMeasurements;

  /// No description provided for @typeMeasurementsBody.
  ///
  /// In es, this message translates to:
  /// **'Ancho y largo, y luego ajustas el plano'**
  String get typeMeasurementsBody;

  /// No description provided for @deleteRoom.
  ///
  /// In es, this message translates to:
  /// **'Eliminar habitación'**
  String get deleteRoom;

  /// No description provided for @deleteRoomMessage.
  ///
  /// In es, this message translates to:
  /// **'Se borrará «{room}» con su plano, sus paredes y sus vanos.'**
  String deleteRoomMessage(String room);

  /// No description provided for @roomCount.
  ///
  /// In es, this message translates to:
  /// **'{count,plural, =1{habitación} other{habitaciones}}'**
  String roomCount(int count);

  /// No description provided for @builtArea.
  ///
  /// In es, this message translates to:
  /// **'área construida'**
  String get builtArea;

  /// No description provided for @netWallArea.
  ///
  /// In es, this message translates to:
  /// **'muros sin vanos'**
  String get netWallArea;

  /// No description provided for @roomCardSummary.
  ///
  /// In es, this message translates to:
  /// **'{area} · {walls} paredes · perímetro {perimeter}'**
  String roomCardSummary(String area, String walls, String perimeter);

  /// No description provided for @planDoesNotClose.
  ///
  /// In es, this message translates to:
  /// **'El plano no cierra: faltan {gap}'**
  String planDoesNotClose(String gap);

  /// No description provided for @name.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get name;

  /// No description provided for @roomNameHint.
  ///
  /// In es, this message translates to:
  /// **'Sala, cocina, alcoba 1…'**
  String get roomNameHint;

  /// No description provided for @roomNameRequired.
  ///
  /// In es, this message translates to:
  /// **'Ponle un nombre a la habitación'**
  String get roomNameRequired;

  /// No description provided for @widthMeters.
  ///
  /// In es, this message translates to:
  /// **'Ancho (m)'**
  String get widthMeters;

  /// No description provided for @lengthMeters.
  ///
  /// In es, this message translates to:
  /// **'Largo (m)'**
  String get lengthMeters;

  /// No description provided for @wallHeightMeters.
  ///
  /// In es, this message translates to:
  /// **'Altura de las paredes (m)'**
  String get wallHeightMeters;

  /// No description provided for @measureHeightWithCamera.
  ///
  /// In es, this message translates to:
  /// **'Medir la altura con la cámara'**
  String get measureHeightWithCamera;

  /// No description provided for @createRoom.
  ///
  /// In es, this message translates to:
  /// **'Crear habitación'**
  String get createRoom;

  /// No description provided for @editRoom.
  ///
  /// In es, this message translates to:
  /// **'Editar habitación'**
  String get editRoom;

  /// No description provided for @saveScanned.
  ///
  /// In es, this message translates to:
  /// **'Guardar lo escaneado'**
  String get saveScanned;

  /// No description provided for @measureHeight.
  ///
  /// In es, this message translates to:
  /// **'Medir la altura'**
  String get measureHeight;

  /// No description provided for @roomGone.
  ///
  /// In es, this message translates to:
  /// **'La habitación ya no existe'**
  String get roomGone;

  /// No description provided for @walls.
  ///
  /// In es, this message translates to:
  /// **'Paredes'**
  String get walls;

  /// No description provided for @addWall.
  ///
  /// In es, this message translates to:
  /// **'Añadir pared'**
  String get addWall;

  /// No description provided for @wallsEmptyBody.
  ///
  /// In es, this message translates to:
  /// **'Esta habitación no tiene paredes. Añade la primera para empezar el recorrido.'**
  String get wallsEmptyBody;

  /// No description provided for @floorArea.
  ///
  /// In es, this message translates to:
  /// **'Área del piso'**
  String get floorArea;

  /// No description provided for @perimeter.
  ///
  /// In es, this message translates to:
  /// **'Perímetro'**
  String get perimeter;

  /// No description provided for @netWallAreaTitle.
  ///
  /// In es, this message translates to:
  /// **'Muros sin vanos'**
  String get netWallAreaTitle;

  /// No description provided for @height.
  ///
  /// In es, this message translates to:
  /// **'Altura'**
  String get height;

  /// No description provided for @planOpenWarning.
  ///
  /// In es, this message translates to:
  /// **'El recorrido no vuelve al punto de partida: faltan {gap}. Revisa los largos y los giros; el área se calcula cerrando el plano por la última pared.'**
  String planOpenWarning(String gap);

  /// No description provided for @wallStart.
  ///
  /// In es, this message translates to:
  /// **'arranque'**
  String get wallStart;

  /// No description provided for @wallTurn.
  ///
  /// In es, this message translates to:
  /// **'gira {degrees}'**
  String wallTurn(String degrees);

  /// No description provided for @wallName.
  ///
  /// In es, this message translates to:
  /// **'Pared {number}'**
  String wallName(int number);

  /// No description provided for @doorCount.
  ///
  /// In es, this message translates to:
  /// **'{count,plural, =1{1 puerta} other{{count} puertas}}'**
  String doorCount(int count);

  /// No description provided for @windowCount.
  ///
  /// In es, this message translates to:
  /// **'{count,plural, =1{1 ventana} other{{count} ventanas}}'**
  String windowCount(int count);

  /// No description provided for @listAnd.
  ///
  /// In es, this message translates to:
  /// **'{first} y {second}'**
  String listAnd(String first, String second);

  /// No description provided for @wallLengthMeters.
  ///
  /// In es, this message translates to:
  /// **'Largo de la pared (m)'**
  String get wallLengthMeters;

  /// No description provided for @wallTurnDegrees.
  ///
  /// In es, this message translates to:
  /// **'Giro respecto a la pared anterior (°)'**
  String get wallTurnDegrees;

  /// No description provided for @wallTurnHelp.
  ///
  /// In es, this message translates to:
  /// **'90 gira a la derecha, -90 a la izquierda'**
  String get wallTurnHelp;

  /// No description provided for @measureAgainWithCamera.
  ///
  /// In es, this message translates to:
  /// **'Volver a medir con la cámara'**
  String get measureAgainWithCamera;

  /// No description provided for @saveWall.
  ///
  /// In es, this message translates to:
  /// **'Guardar pared'**
  String get saveWall;

  /// No description provided for @doorsAndWindows.
  ///
  /// In es, this message translates to:
  /// **'Puertas y ventanas'**
  String get doorsAndWindows;

  /// No description provided for @add.
  ///
  /// In es, this message translates to:
  /// **'Añadir'**
  String get add;

  /// No description provided for @openingsEmptyBody.
  ///
  /// In es, this message translates to:
  /// **'Esta pared no tiene vanos. Los que añadas se descuentan de la superficie a pintar.'**
  String get openingsEmptyBody;

  /// No description provided for @openingSummary.
  ///
  /// In es, this message translates to:
  /// **'{kind} {width} × {height}'**
  String openingSummary(String kind, String width, String height);

  /// No description provided for @openingFromStart.
  ///
  /// In es, this message translates to:
  /// **'A {distance} del inicio'**
  String openingFromStart(String distance);

  /// No description provided for @deleteThisWall.
  ///
  /// In es, this message translates to:
  /// **'Eliminar esta pared'**
  String get deleteThisWall;

  /// No description provided for @degreesRequired.
  ///
  /// In es, this message translates to:
  /// **'Escribe los grados'**
  String get degreesRequired;

  /// No description provided for @degreesRange.
  ///
  /// In es, this message translates to:
  /// **'Entre -359 y 359'**
  String get degreesRange;

  /// No description provided for @measureThing.
  ///
  /// In es, this message translates to:
  /// **'Medir {thing}'**
  String measureThing(String thing);

  /// No description provided for @deleteThing.
  ///
  /// In es, this message translates to:
  /// **'Eliminar {thing}'**
  String deleteThing(String thing);

  /// No description provided for @deleteWallMessage.
  ///
  /// In es, this message translates to:
  /// **'Se borra la pared con sus puertas y ventanas, y el plano se vuelve a trazar con las que queden.'**
  String get deleteWallMessage;

  /// No description provided for @newOpening.
  ///
  /// In es, this message translates to:
  /// **'Nuevo vano'**
  String get newOpening;

  /// No description provided for @editOpening.
  ///
  /// In es, this message translates to:
  /// **'Editar vano'**
  String get editOpening;

  /// No description provided for @widthMetersShort.
  ///
  /// In es, this message translates to:
  /// **'Ancho (m)'**
  String get widthMetersShort;

  /// No description provided for @heightMetersShort.
  ///
  /// In es, this message translates to:
  /// **'Alto (m)'**
  String get heightMetersShort;

  /// No description provided for @openingTooWide.
  ///
  /// In es, this message translates to:
  /// **'No cabe en la pared'**
  String get openingTooWide;

  /// No description provided for @openingTooTall.
  ///
  /// In es, this message translates to:
  /// **'Pasa de la altura del muro'**
  String get openingTooTall;

  /// No description provided for @openingDistance.
  ///
  /// In es, this message translates to:
  /// **'Desde el inicio de la pared (m)'**
  String get openingDistance;

  /// No description provided for @wallMeasures.
  ///
  /// In es, this message translates to:
  /// **'La pared mide {length}'**
  String wallMeasures(String length);

  /// No description provided for @addOpening.
  ///
  /// In es, this message translates to:
  /// **'Añadir vano'**
  String get addOpening;

  /// No description provided for @deleteOpening.
  ///
  /// In es, this message translates to:
  /// **'Eliminar vano'**
  String get deleteOpening;

  /// No description provided for @measureRequired.
  ///
  /// In es, this message translates to:
  /// **'Escribe una medida'**
  String get measureRequired;

  /// No description provided for @openingOffWall.
  ///
  /// In es, this message translates to:
  /// **'El vano se sale de la pared'**
  String get openingOffWall;

  /// No description provided for @door.
  ///
  /// In es, this message translates to:
  /// **'Puerta'**
  String get door;

  /// No description provided for @window.
  ///
  /// In es, this message translates to:
  /// **'Ventana'**
  String get window;

  /// No description provided for @planNeedsTwoWalls.
  ///
  /// In es, this message translates to:
  /// **'Añade al menos dos paredes para ver el plano'**
  String get planNeedsTwoWalls;

  /// No description provided for @exportPdf.
  ///
  /// In es, this message translates to:
  /// **'Exportar en PDF'**
  String get exportPdf;

  /// No description provided for @wholeProject.
  ///
  /// In es, this message translates to:
  /// **'Todo el proyecto'**
  String get wholeProject;

  /// No description provided for @oneRoom.
  ///
  /// In es, this message translates to:
  /// **'Una habitación'**
  String get oneRoom;

  /// No description provided for @pdfFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo crear el PDF: {error}'**
  String pdfFailed(String error);

  /// No description provided for @whichMaterial.
  ///
  /// In es, this message translates to:
  /// **'¿Qué material entra?'**
  String get whichMaterial;

  /// No description provided for @materialNeeded.
  ///
  /// In es, this message translates to:
  /// **'{surface} · harían falta {quantity} {unit}'**
  String materialNeeded(String surface, String quantity, String unit);

  /// No description provided for @materialLine.
  ///
  /// In es, this message translates to:
  /// **'{surface} · {quantity} {unit} × {price}'**
  String materialLine(
    String surface,
    String quantity,
    String unit,
    String price,
  );

  /// No description provided for @priceOf.
  ///
  /// In es, this message translates to:
  /// **'Precio de {material}'**
  String priceOf(String material);

  /// No description provided for @pricePer.
  ///
  /// In es, this message translates to:
  /// **'Precio por {unit}'**
  String pricePer(String unit);

  /// No description provided for @changePrice.
  ///
  /// In es, this message translates to:
  /// **'Cambiar el precio'**
  String get changePrice;

  /// No description provided for @removeFromBudget.
  ///
  /// In es, this message translates to:
  /// **'Quitar del presupuesto'**
  String get removeFromBudget;

  /// No description provided for @materialsEmptyBody.
  ///
  /// In es, this message translates to:
  /// **'Añade los materiales que quieras presupuestar. Las cantidades salen del plano; tú pones el precio y decides cuáles entran.'**
  String get materialsEmptyBody;

  /// No description provided for @otherItems.
  ///
  /// In es, this message translates to:
  /// **'Otras partidas'**
  String get otherItems;

  /// No description provided for @otherItemsEmptyBody.
  ///
  /// In es, this message translates to:
  /// **'Aquí van el acero, la teja, la mano de obra y todo lo que no sale del plano.'**
  String get otherItemsEmptyBody;

  /// No description provided for @itemLine.
  ///
  /// In es, this message translates to:
  /// **'{category} · {quantity} {unit} × {price}'**
  String itemLine(String category, String quantity, String unit, String price);

  /// No description provided for @finishes.
  ///
  /// In es, this message translates to:
  /// **'Acabados'**
  String get finishes;

  /// No description provided for @finishesEmptyBody.
  ///
  /// In es, this message translates to:
  /// **'Marca las paredes y los pisos que llevan pintura, estuco o enchape y ponles precio por m². Los metros salen del plano.'**
  String get finishesEmptyBody;

  /// No description provided for @finishLine.
  ///
  /// In es, this message translates to:
  /// **'{where} · {area} × {price}'**
  String finishLine(String where, String area, String price);

  /// No description provided for @wallCount.
  ///
  /// In es, this message translates to:
  /// **'{count,plural, =1{1 pared} other{{count} paredes}}'**
  String wallCount(int count);

  /// No description provided for @floorCount.
  ///
  /// In es, this message translates to:
  /// **'{count,plural, =1{1 piso} other{{count} pisos}}'**
  String floorCount(int count);

  /// No description provided for @noSurfaces.
  ///
  /// In es, this message translates to:
  /// **'Sin superficies'**
  String get noSurfaces;

  /// No description provided for @summary.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get summary;

  /// No description provided for @labour.
  ///
  /// In es, this message translates to:
  /// **'Mano de obra'**
  String get labour;

  /// No description provided for @otherCategory.
  ///
  /// In es, this message translates to:
  /// **'Otros'**
  String get otherCategory;

  /// No description provided for @materialCategory.
  ///
  /// In es, this message translates to:
  /// **'Material'**
  String get materialCategory;

  /// No description provided for @total.
  ///
  /// In es, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @perSquareMetre.
  ///
  /// In es, this message translates to:
  /// **'{price} por m² de piso'**
  String perSquareMetre(String price);

  /// No description provided for @newFinish.
  ///
  /// In es, this message translates to:
  /// **'Nuevo acabado'**
  String get newFinish;

  /// No description provided for @editFinish.
  ///
  /// In es, this message translates to:
  /// **'Editar acabado'**
  String get editFinish;

  /// No description provided for @whatIsDone.
  ///
  /// In es, this message translates to:
  /// **'Qué se hace'**
  String get whatIsDone;

  /// No description provided for @whatIsDoneHint.
  ///
  /// In es, this message translates to:
  /// **'Pintura vinilo, estuco, enchape…'**
  String get whatIsDoneHint;

  /// No description provided for @whatIsDoneRequired.
  ///
  /// In es, this message translates to:
  /// **'Escribe qué acabado es'**
  String get whatIsDoneRequired;

  /// No description provided for @pricePerSquareMetre.
  ///
  /// In es, this message translates to:
  /// **'Precio por m²'**
  String get pricePerSquareMetre;

  /// No description provided for @whereItGoes.
  ///
  /// In es, this message translates to:
  /// **'Dónde se aplica'**
  String get whereItGoes;

  /// No description provided for @noRoomsMeasured.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay habitaciones medidas.'**
  String get noRoomsMeasured;

  /// No description provided for @addFinish.
  ///
  /// In es, this message translates to:
  /// **'Añadir acabado'**
  String get addFinish;

  /// No description provided for @deleteFinish.
  ///
  /// In es, this message translates to:
  /// **'Eliminar acabado'**
  String get deleteFinish;

  /// No description provided for @floor.
  ///
  /// In es, this message translates to:
  /// **'Piso'**
  String get floor;

  /// No description provided for @surfaceTile.
  ///
  /// In es, this message translates to:
  /// **'{surface} · {area}'**
  String surfaceTile(String surface, String area);

  /// No description provided for @markOneSurface.
  ///
  /// In es, this message translates to:
  /// **'Marca al menos una pared o un piso.'**
  String get markOneSurface;

  /// No description provided for @deleteFinishMessage.
  ///
  /// In es, this message translates to:
  /// **'Se quita «{finish}» del presupuesto. Las paredes y el plano no se tocan.'**
  String deleteFinishMessage(String finish);

  /// No description provided for @markedArea.
  ///
  /// In es, this message translates to:
  /// **'Marcado: {area}'**
  String markedArea(String area);

  /// No description provided for @unitShort.
  ///
  /// In es, this message translates to:
  /// **'unid'**
  String get unitShort;

  /// No description provided for @newItem.
  ///
  /// In es, this message translates to:
  /// **'Nueva partida'**
  String get newItem;

  /// No description provided for @editItem.
  ///
  /// In es, this message translates to:
  /// **'Editar partida'**
  String get editItem;

  /// No description provided for @description.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get description;

  /// No description provided for @itemHint.
  ///
  /// In es, this message translates to:
  /// **'Varilla de 1/2, teja, ayudante…'**
  String get itemHint;

  /// No description provided for @itemRequired.
  ///
  /// In es, this message translates to:
  /// **'Escribe qué es'**
  String get itemRequired;

  /// No description provided for @quantity.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get quantity;

  /// No description provided for @unit.
  ///
  /// In es, this message translates to:
  /// **'Unidad'**
  String get unit;

  /// No description provided for @missing.
  ///
  /// In es, this message translates to:
  /// **'Falta'**
  String get missing;

  /// No description provided for @pricePerUnit.
  ///
  /// In es, this message translates to:
  /// **'Precio por unidad'**
  String get pricePerUnit;

  /// No description provided for @addItem.
  ///
  /// In es, this message translates to:
  /// **'Añadir partida'**
  String get addItem;

  /// No description provided for @deleteItem.
  ///
  /// In es, this message translates to:
  /// **'Eliminar partida'**
  String get deleteItem;

  /// No description provided for @materialBlock.
  ///
  /// In es, this message translates to:
  /// **'Bloques o ladrillos'**
  String get materialBlock;

  /// No description provided for @materialCement.
  ///
  /// In es, this message translates to:
  /// **'Cemento'**
  String get materialCement;

  /// No description provided for @materialSand.
  ///
  /// In es, this message translates to:
  /// **'Arena'**
  String get materialSand;

  /// No description provided for @materialPaint.
  ///
  /// In es, this message translates to:
  /// **'Pintura'**
  String get materialPaint;

  /// No description provided for @materialAdhesive.
  ///
  /// In es, this message translates to:
  /// **'Pegante'**
  String get materialAdhesive;

  /// No description provided for @materialTile.
  ///
  /// In es, this message translates to:
  /// **'Baldosas'**
  String get materialTile;

  /// No description provided for @unitBag.
  ///
  /// In es, this message translates to:
  /// **'bulto'**
  String get unitBag;

  /// No description provided for @unitGallon.
  ///
  /// In es, this message translates to:
  /// **'gal'**
  String get unitGallon;

  /// No description provided for @unitKilogram.
  ///
  /// In es, this message translates to:
  /// **'kg'**
  String get unitKilogram;

  /// No description provided for @surfaceWalls.
  ///
  /// In es, this message translates to:
  /// **'Paredes'**
  String get surfaceWalls;

  /// No description provided for @surfaceFloor.
  ///
  /// In es, this message translates to:
  /// **'Piso'**
  String get surfaceFloor;

  /// No description provided for @pdfDocumentTitle.
  ///
  /// In es, this message translates to:
  /// **'Presupuesto {project}'**
  String pdfDocumentTitle(String project);

  /// No description provided for @pdfHeading.
  ///
  /// In es, this message translates to:
  /// **'Presupuesto de obra'**
  String get pdfHeading;

  /// No description provided for @pdfScope.
  ///
  /// In es, this message translates to:
  /// **'Alcance: {scope}'**
  String pdfScope(String scope);

  /// No description provided for @pdfFooter.
  ///
  /// In es, this message translates to:
  /// **'Hecho con Planova · página {page} de {pages}'**
  String pdfFooter(String page, String pages);

  /// No description provided for @pdfRunningTitle.
  ///
  /// In es, this message translates to:
  /// **'{project} · Presupuesto'**
  String pdfRunningTitle(String project);

  /// No description provided for @calculatedMaterials.
  ///
  /// In es, this message translates to:
  /// **'Materiales calculados'**
  String get calculatedMaterials;

  /// No description provided for @noRoomsMeasuredYet.
  ///
  /// In es, this message translates to:
  /// **'No hay habitaciones medidas todavía.'**
  String get noRoomsMeasuredYet;

  /// No description provided for @pdfFloorArea.
  ///
  /// In es, this message translates to:
  /// **'Área de piso'**
  String get pdfFloorArea;

  /// No description provided for @wallsCountLabel.
  ///
  /// In es, this message translates to:
  /// **'Paredes'**
  String get wallsCountLabel;

  /// No description provided for @pdfPlanOpenBy.
  ///
  /// In es, this message translates to:
  /// **'El plano no cierra por {gap}.'**
  String pdfPlanOpenBy(String gap);

  /// No description provided for @columnMaterial.
  ///
  /// In es, this message translates to:
  /// **'Material'**
  String get columnMaterial;

  /// No description provided for @columnFrom.
  ///
  /// In es, this message translates to:
  /// **'De'**
  String get columnFrom;

  /// No description provided for @columnQuantity.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get columnQuantity;

  /// No description provided for @columnUnit.
  ///
  /// In es, this message translates to:
  /// **'Unidad'**
  String get columnUnit;

  /// No description provided for @columnUnitPrice.
  ///
  /// In es, this message translates to:
  /// **'Precio unitario'**
  String get columnUnitPrice;

  /// No description provided for @columnSubtotal.
  ///
  /// In es, this message translates to:
  /// **'Subtotal'**
  String get columnSubtotal;

  /// No description provided for @noPrice.
  ///
  /// In es, this message translates to:
  /// **'sin precio'**
  String get noPrice;

  /// No description provided for @columnFinish.
  ///
  /// In es, this message translates to:
  /// **'Acabado'**
  String get columnFinish;

  /// No description provided for @columnWhere.
  ///
  /// In es, this message translates to:
  /// **'Dónde'**
  String get columnWhere;

  /// No description provided for @columnSurface.
  ///
  /// In es, this message translates to:
  /// **'Superficie'**
  String get columnSurface;

  /// No description provided for @columnPricePerSquareMetre.
  ///
  /// In es, this message translates to:
  /// **'Precio por m²'**
  String get columnPricePerSquareMetre;

  /// No description provided for @columnDescription.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get columnDescription;

  /// No description provided for @columnCategory.
  ///
  /// In es, this message translates to:
  /// **'Capítulo'**
  String get columnCategory;

  /// No description provided for @pdfEstimateNote.
  ///
  /// In es, this message translates to:
  /// **'Las cantidades de material se calculan a partir de las medidas del plano e incluyen desperdicio. Son una estimación.'**
  String get pdfEstimateNote;

  /// No description provided for @tuneRates.
  ///
  /// In es, this message translates to:
  /// **'Ajustar rendimientos'**
  String get tuneRates;

  /// No description provided for @materialsNote.
  ///
  /// In es, this message translates to:
  /// **'Las cantidades ya traen el desperdicio. Son una estimación: compruébalas antes de comprar.'**
  String get materialsNote;

  /// No description provided for @surfacesLine.
  ///
  /// In es, this message translates to:
  /// **'Muros sin vanos {walls} · Piso {floor}'**
  String surfacesLine(String walls, String floor);

  /// No description provided for @masonry.
  ///
  /// In es, this message translates to:
  /// **'Mampostería'**
  String get masonry;

  /// No description provided for @piecesCount.
  ///
  /// In es, this message translates to:
  /// **'{count} piezas'**
  String piecesCount(String count);

  /// No description provided for @fromWallsNotFloor.
  ///
  /// In es, this message translates to:
  /// **'De {area} de muros (no del piso)'**
  String fromWallsNotFloor(String area);

  /// No description provided for @bedMortar.
  ///
  /// In es, this message translates to:
  /// **'Mortero de pega'**
  String get bedMortar;

  /// No description provided for @cementBags.
  ///
  /// In es, this message translates to:
  /// **'{count} bultos'**
  String cementBags(String count);

  /// No description provided for @masonryNote.
  ///
  /// In es, this message translates to:
  /// **'{area} × {perSquareMetre} piezas/m² + {waste} % de desperdicio. Pieza de {length} × {height}, junta de {joint}, muro de {thickness}.'**
  String masonryNote(
    String area,
    String perSquareMetre,
    String waste,
    String length,
    String height,
    String joint,
    String thickness,
  );

  /// No description provided for @fromWallsAndCeiling.
  ///
  /// In es, this message translates to:
  /// **'De {area} de muros y cielo raso'**
  String fromWallsAndCeiling(String area);

  /// No description provided for @inGallons.
  ///
  /// In es, this message translates to:
  /// **'En galones'**
  String get inGallons;

  /// No description provided for @gallonsValue.
  ///
  /// In es, this message translates to:
  /// **'{count} gal'**
  String gallonsValue(String count);

  /// No description provided for @surface.
  ///
  /// In es, this message translates to:
  /// **'Superficie'**
  String get surface;

  /// No description provided for @paintNote.
  ///
  /// In es, this message translates to:
  /// **'{coats} manos · {coverage} m² por litro{ceiling}'**
  String paintNote(String coats, String coverage, String ceiling);

  /// No description provided for @includesCeiling.
  ///
  /// In es, this message translates to:
  /// **' · incluye el cielo raso'**
  String get includesCeiling;

  /// No description provided for @tilesCount.
  ///
  /// In es, this message translates to:
  /// **'{count} baldosas'**
  String tilesCount(String count);

  /// No description provided for @fromFloorArea.
  ///
  /// In es, this message translates to:
  /// **'De {area} de piso'**
  String fromFloorArea(String area);

  /// No description provided for @floorNote.
  ///
  /// In es, this message translates to:
  /// **'{area} × {perSquareMetre} baldosas/m² + {waste} % de desperdicio. Baldosa de {length} × {width}.'**
  String floorNote(
    String area,
    String perSquareMetre,
    String waste,
    String length,
    String width,
  );

  /// No description provided for @nothingToCalculate.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay de dónde calcular'**
  String get nothingToCalculate;

  /// No description provided for @nothingToCalculateBody.
  ///
  /// In es, this message translates to:
  /// **'Los materiales salen de lo que miden las habitaciones. Crea la primera y vuelve aquí.'**
  String get nothingToCalculateBody;

  /// No description provided for @projectRates.
  ///
  /// In es, this message translates to:
  /// **'Rendimientos del proyecto'**
  String get projectRates;

  /// No description provided for @projectRatesNote.
  ///
  /// In es, this message translates to:
  /// **'Estas cifras son las que usa la calculadora. Cámbialas por las de tu obra y los materiales se recalculan solos.'**
  String get projectRatesNote;

  /// No description provided for @pieceLengthCm.
  ///
  /// In es, this message translates to:
  /// **'Largo de la pieza (cm)'**
  String get pieceLengthCm;

  /// No description provided for @pieceHeightCm.
  ///
  /// In es, this message translates to:
  /// **'Alto de la pieza (cm)'**
  String get pieceHeightCm;

  /// No description provided for @jointCm.
  ///
  /// In es, this message translates to:
  /// **'Junta de pega (cm)'**
  String get jointCm;

  /// No description provided for @wallThicknessCm.
  ///
  /// In es, this message translates to:
  /// **'Espesor del muro (cm)'**
  String get wallThicknessCm;

  /// No description provided for @wastePercent.
  ///
  /// In es, this message translates to:
  /// **'Desperdicio (%)'**
  String get wastePercent;

  /// No description provided for @cementPerCubicMetre.
  ///
  /// In es, this message translates to:
  /// **'Cemento (bultos/m³)'**
  String get cementPerCubicMetre;

  /// No description provided for @sandPerCubicMetre.
  ///
  /// In es, this message translates to:
  /// **'Arena por m³ de mortero (m³)'**
  String get sandPerCubicMetre;

  /// No description provided for @paint.
  ///
  /// In es, this message translates to:
  /// **'Pintura'**
  String get paint;

  /// No description provided for @coats.
  ///
  /// In es, this message translates to:
  /// **'Manos'**
  String get coats;

  /// No description provided for @coverage.
  ///
  /// In es, this message translates to:
  /// **'Rendimiento (m² por L)'**
  String get coverage;

  /// No description provided for @paintCeilingToo.
  ///
  /// In es, this message translates to:
  /// **'Pintar también el cielo raso'**
  String get paintCeilingToo;

  /// No description provided for @tileLengthCm.
  ///
  /// In es, this message translates to:
  /// **'Largo baldosa (cm)'**
  String get tileLengthCm;

  /// No description provided for @tileWidthCm.
  ///
  /// In es, this message translates to:
  /// **'Ancho baldosa (cm)'**
  String get tileWidthCm;

  /// No description provided for @adhesivePerSquareMetre.
  ///
  /// In es, this message translates to:
  /// **'Pegante (kg por m²)'**
  String get adhesivePerSquareMetre;

  /// No description provided for @saveRates.
  ///
  /// In es, this message translates to:
  /// **'Guardar rendimientos'**
  String get saveRates;

  /// No description provided for @howItMeasures.
  ///
  /// In es, this message translates to:
  /// **'Cómo se mide'**
  String get howItMeasures;

  /// No description provided for @gotIt.
  ///
  /// In es, this message translates to:
  /// **'Entendido'**
  String get gotIt;

  /// No description provided for @spatialHelpBody.
  ///
  /// In es, this message translates to:
  /// **'1. Mueve despacio el teléfono apuntando al suelo hasta que la app reconozca la superficie.\n2. Apunta con la mira al pie de una esquina y marca.\n3. Ve a la siguiente esquina y marca otra vez: la pared queda hecha con su medida. Puedes caminar, que el plano no se mueve.\n4. Al volver a la primera esquina, la línea se engancha a ella: ahí se cierra la habitación.\n\nAl cerrar le pones nombre y la habitación queda creada con sus paredes. La altura del techo se mide después, desde la habitación. Aquí la distancia la mide el aparato, no se estima. Aun así conviene revisar las paredes en el plano antes de comprar material.'**
  String get spatialHelpBody;

  /// No description provided for @atCornerOneClose.
  ///
  /// In es, this message translates to:
  /// **'Estás en la esquina 1: cierra la habitación'**
  String get atCornerOneClose;

  /// No description provided for @moveToFindFloor.
  ///
  /// In es, this message translates to:
  /// **'Mueve el teléfono despacio para reconocer el suelo'**
  String get moveToFindFloor;

  /// No description provided for @wallChip.
  ///
  /// In es, this message translates to:
  /// **'Pared {number} · {length}'**
  String wallChip(String number, String length);

  /// No description provided for @cornerCount.
  ///
  /// In es, this message translates to:
  /// **'{count,plural, =1{1 esquina} other{{count} esquinas}}'**
  String cornerCount(int count);

  /// No description provided for @undoLast.
  ///
  /// In es, this message translates to:
  /// **'Quitar la última'**
  String get undoLast;

  /// No description provided for @closeRoom.
  ///
  /// In es, this message translates to:
  /// **'Cerrar habitación'**
  String get closeRoom;

  /// No description provided for @markCorner.
  ///
  /// In es, this message translates to:
  /// **'Marcar esquina'**
  String get markCorner;

  /// No description provided for @finishWithoutClosing.
  ///
  /// In es, this message translates to:
  /// **'Terminar sin cerrar'**
  String get finishWithoutClosing;

  /// No description provided for @moveToFindSurface.
  ///
  /// In es, this message translates to:
  /// **'Mueve el teléfono despacio para reconocer la superficie'**
  String get moveToFindSurface;

  /// No description provided for @aimAtOneEnd.
  ///
  /// In es, this message translates to:
  /// **'Apunta a un extremo y márcalo'**
  String get aimAtOneEnd;

  /// No description provided for @markTheStart.
  ///
  /// In es, this message translates to:
  /// **'Marcar el principio'**
  String get markTheStart;

  /// No description provided for @aimAtOtherEnd.
  ///
  /// In es, this message translates to:
  /// **'Apunta al otro extremo'**
  String get aimAtOtherEnd;

  /// No description provided for @useMeasure.
  ///
  /// In es, this message translates to:
  /// **'Usar {measure}'**
  String useMeasure(String measure);

  /// No description provided for @startAgain.
  ///
  /// In es, this message translates to:
  /// **'Empezar de nuevo'**
  String get startAgain;

  /// No description provided for @noCamera.
  ///
  /// In es, this message translates to:
  /// **'Este aparato no tiene cámara. Puedes medir igual apuntando con el teléfono.'**
  String get noCamera;

  /// No description provided for @cameraDenied.
  ///
  /// In es, this message translates to:
  /// **'Planova no tiene permiso para la cámara. Puedes dárselo en los ajustes del teléfono, o medir igual apuntando sin ver la imagen.'**
  String get cameraDenied;

  /// No description provided for @cameraFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo abrir la cámara. Puedes medir igual apuntando con el teléfono.'**
  String get cameraFailed;

  /// No description provided for @ceilingHeight.
  ///
  /// In es, this message translates to:
  /// **'Altura del techo'**
  String get ceilingHeight;

  /// No description provided for @metresFloorToCeiling.
  ///
  /// In es, this message translates to:
  /// **'Metros del suelo al techo'**
  String get metresFloorToCeiling;

  /// No description provided for @ceilingHeightHelp.
  ///
  /// In es, this message translates to:
  /// **'Es lo único que hay que saber: con eso salen las demás'**
  String get ceilingHeightHelp;

  /// No description provided for @sightingsDoNotMatch.
  ///
  /// In es, this message translates to:
  /// **'No cuadra: apunta al pie de una pared y luego al techo de esa misma pared.'**
  String get sightingsDoNotMatch;

  /// No description provided for @calibrationDone.
  ///
  /// In es, this message translates to:
  /// **'Listo: llevas el teléfono a {height} del suelo y esa pared está a {distance}.'**
  String calibrationDone(String height, String distance);

  /// No description provided for @whichCorner.
  ///
  /// In es, this message translates to:
  /// **'¿A qué esquina apuntas?'**
  String get whichCorner;

  /// No description provided for @whichCornerBody.
  ///
  /// In es, this message translates to:
  /// **'Desde donde estás ahora, apunta al pie de una esquina que ya hayas marcado. Con eso la app vuelve a saber dónde estás y el plano no se mueve.'**
  String get whichCornerBody;

  /// No description provided for @legacyHelpBody.
  ///
  /// In es, this message translates to:
  /// **'1. Toca «Sin calibrar» y escribe la altura del techo. Apunta al pie de una pared, fija, y luego al techo de esa misma pared. Con eso la app sabe a qué altura llevas el teléfono y mide bien.\n2. Apunta con la mira al pie de una esquina, donde la pared toca el suelo, y marca.\n3. Gira sobre ti mismo: desde la esquina marcada sale una línea que sigue a la mira. Marca la siguiente y la pared queda hecha.\n4. Al volver a la primera esquina, la línea se engancha a ella: ahí se cierra la habitación.\n\nSi tienes que caminar, toca «Me moví», apunta a una esquina que ya hayas marcado y fija tu posición: el plano se queda donde está.\n\nTodo esto es una estimación: después puedes corregir cada pared con el flexómetro en el editor del plano.'**
  String get legacyHelpBody;

  /// No description provided for @waitingForSensors.
  ///
  /// In es, this message translates to:
  /// **'Esperando a los sensores…'**
  String get waitingForSensors;

  /// No description provided for @aimAtWallFootLockFloor.
  ///
  /// In es, this message translates to:
  /// **'Apunta al pie de una pared y fija el suelo'**
  String get aimAtWallFootLockFloor;

  /// No description provided for @nowAtTheCeiling.
  ///
  /// In es, this message translates to:
  /// **'Ahora al techo de esa misma pared'**
  String get nowAtTheCeiling;

  /// No description provided for @aimAtCornerFixPosition.
  ///
  /// In es, this message translates to:
  /// **'Apunta al pie de la esquina {corner} y fija tu posición'**
  String aimAtCornerFixPosition(String corner);

  /// No description provided for @aimLowerAtWallFoot.
  ///
  /// In es, this message translates to:
  /// **'Apunta más abajo, al pie de la pared'**
  String get aimLowerAtWallFoot;

  /// No description provided for @turnOnTheSpot.
  ///
  /// In es, this message translates to:
  /// **'Gira sobre ti mismo, sin caminar. Si te mueves, usa «Me moví».'**
  String get turnOnTheSpot;

  /// No description provided for @calibrated.
  ///
  /// In es, this message translates to:
  /// **'Calibrado · {height}'**
  String calibrated(String height);

  /// No description provided for @notCalibrated.
  ///
  /// In es, this message translates to:
  /// **'Sin calibrar'**
  String get notCalibrated;

  /// No description provided for @iMoved.
  ///
  /// In es, this message translates to:
  /// **'Me moví'**
  String get iMoved;

  /// No description provided for @lockFloor.
  ///
  /// In es, this message translates to:
  /// **'Fijar el suelo'**
  String get lockFloor;

  /// No description provided for @lockCeiling.
  ///
  /// In es, this message translates to:
  /// **'Fijar el techo'**
  String get lockCeiling;

  /// No description provided for @iAmHere.
  ///
  /// In es, this message translates to:
  /// **'Estoy aquí'**
  String get iAmHere;

  /// No description provided for @noGyroscopeTitle.
  ///
  /// In es, this message translates to:
  /// **'Este teléfono no puede medir el giro'**
  String get noGyroscopeTitle;

  /// No description provided for @noGyroscopeBody.
  ///
  /// In es, this message translates to:
  /// **'Le falta el giroscopio, así que no hay forma de saber hacia dónde apuntas al girar sobre ti mismo y el plano saldría inventado.\n\nPuedes crear la habitación escribiendo el ancho y el largo, y ajustar cada pared en el plano.'**
  String get noGyroscopeBody;

  /// No description provided for @goBack.
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get goBack;
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

AppL10n lookupAppL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppL10nEn();
    case 'es':
      return AppL10nEs();
  }

  throw FlutterError(
    'AppL10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
