// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_l10n.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppL10nEs extends AppL10n {
  AppL10nEs([String locale = 'es']) : super(locale);

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get delete => 'Eliminar';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsAppearance => 'Apariencia';

  @override
  String get optionSystem => 'Igual que el sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get settingsCurrency => 'Moneda';

  @override
  String get currencyNote =>
      'Cambia cómo se escriben los precios. No los convierte: lo que está escrito sigue valiendo lo mismo.';

  @override
  String get currencyCop => 'Peso colombiano';

  @override
  String get currencyUsd => 'Dólar';

  @override
  String get settingsTesting => 'Pruebas';

  @override
  String get demoTitle => 'Cargar un proyecto de ejemplo';

  @override
  String get demoBody =>
      'Crea una casa con tres habitaciones, precios y acabados para ver el presupuesto y el PDF sin medir nada.';

  @override
  String demoDone(String project) {
    return 'Listo: «$project» está en tus proyectos.';
  }

  @override
  String demoFailed(String error) {
    return 'No se pudo crear el ejemplo: $error';
  }

  @override
  String get projectsLoadError => 'No se pudieron leer los proyectos';

  @override
  String get projectsEmptyTitle => 'Todavía no hay proyectos';

  @override
  String get projectsEmptyBody =>
      'Crea el primero para empezar a guardar habitaciones, planos y presupuestos.';

  @override
  String get newProject => 'Nuevo proyecto';

  @override
  String get editProject => 'Editar proyecto';

  @override
  String get createProject => 'Crear proyecto';

  @override
  String get deleteProject => 'Eliminar proyecto';

  @override
  String deleteProjectMessage(String project) {
    return 'Se borrará «$project» y todo lo que guardes dentro. Esto no se puede deshacer.';
  }

  @override
  String updatedOn(String date) {
    return 'Actualizado el $date';
  }

  @override
  String get projectName => 'Nombre del proyecto';

  @override
  String get projectNameHint => 'Casa de dos pisos, remodelación cocina…';

  @override
  String get projectNameRequired => 'Ponle un nombre al proyecto';

  @override
  String get client => 'Cliente';

  @override
  String get address => 'Dirección';

  @override
  String get notes => 'Notas';

  @override
  String get projectCreated => 'Proyecto creado';

  @override
  String get projectUpdated => 'Proyecto actualizado';

  @override
  String saveFailed(String error) {
    return 'No se pudo guardar: $error';
  }

  @override
  String get projectGone => 'El proyecto ya no existe';

  @override
  String roomsLoadError(String error) {
    return 'No se pudieron leer las habitaciones: $error';
  }

  @override
  String get materials => 'Materiales';

  @override
  String get materialsCardBody =>
      'Bloques o ladrillos, mortero, pintura y piso con tus rendimientos';

  @override
  String get budget => 'Presupuesto';

  @override
  String get budgetCardBody => 'Precios, mano de obra y costo por m²';

  @override
  String get rooms => 'Habitaciones';

  @override
  String get roomsEmptyBody =>
      'Todavía no hay habitaciones. Crea la primera con su ancho y su largo, y luego ajusta el plano pared por pared.';

  @override
  String get newRoom => 'Nueva habitación';

  @override
  String get measureWithCamera => 'Medir con la cámara';

  @override
  String get measureWithCameraBody =>
      'Apunta al pie de cada esquina y sale el plano';

  @override
  String get typeMeasurements => 'Escribir las medidas';

  @override
  String get typeMeasurementsBody => 'Ancho y largo, y luego ajustas el plano';

  @override
  String get deleteRoom => 'Eliminar habitación';

  @override
  String deleteRoomMessage(String room) {
    return 'Se borrará «$room» con su plano, sus paredes y sus vanos.';
  }

  @override
  String roomCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'habitaciones',
      one: 'habitación',
    );
    return '$_temp0';
  }

  @override
  String get builtArea => 'área construida';

  @override
  String get netWallArea => 'muros sin vanos';

  @override
  String roomCardSummary(String area, String walls, String perimeter) {
    return '$area · $walls paredes · perímetro $perimeter';
  }

  @override
  String planDoesNotClose(String gap) {
    return 'El plano no cierra: faltan $gap';
  }

  @override
  String get name => 'Nombre';

  @override
  String get roomNameHint => 'Sala, cocina, alcoba 1…';

  @override
  String get roomNameRequired => 'Ponle un nombre a la habitación';

  @override
  String get widthMeters => 'Ancho (m)';

  @override
  String get lengthMeters => 'Largo (m)';

  @override
  String get wallHeightMeters => 'Altura de las paredes (m)';

  @override
  String get measureHeightWithCamera => 'Medir la altura con la cámara';

  @override
  String get createRoom => 'Crear habitación';

  @override
  String get editRoom => 'Editar habitación';

  @override
  String get saveScanned => 'Guardar lo escaneado';

  @override
  String get measureHeight => 'Medir la altura';

  @override
  String get roomGone => 'La habitación ya no existe';

  @override
  String get walls => 'Paredes';

  @override
  String get addWall => 'Añadir pared';

  @override
  String get wallsEmptyBody =>
      'Esta habitación no tiene paredes. Añade la primera para empezar el recorrido.';

  @override
  String get floorArea => 'Área del piso';

  @override
  String get perimeter => 'Perímetro';

  @override
  String get netWallAreaTitle => 'Muros sin vanos';

  @override
  String get height => 'Altura';

  @override
  String planOpenWarning(String gap) {
    return 'El recorrido no vuelve al punto de partida: faltan $gap. Revisa los largos y los giros; el área se calcula cerrando el plano por la última pared.';
  }

  @override
  String get wallStart => 'arranque';

  @override
  String wallTurn(String degrees) {
    return 'gira $degrees';
  }

  @override
  String wallName(int number) {
    return 'Pared $number';
  }

  @override
  String doorCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puertas',
      one: '1 puerta',
    );
    return '$_temp0';
  }

  @override
  String windowCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ventanas',
      one: '1 ventana',
    );
    return '$_temp0';
  }

  @override
  String listAnd(String first, String second) {
    return '$first y $second';
  }

  @override
  String get wallLengthMeters => 'Largo de la pared (m)';

  @override
  String get wallTurnDegrees => 'Giro respecto a la pared anterior (°)';

  @override
  String get wallTurnHelp => '90 gira a la derecha, -90 a la izquierda';

  @override
  String get measureAgainWithCamera => 'Volver a medir con la cámara';

  @override
  String get saveWall => 'Guardar pared';

  @override
  String get doorsAndWindows => 'Puertas y ventanas';

  @override
  String get add => 'Añadir';

  @override
  String get openingsEmptyBody =>
      'Esta pared no tiene vanos. Los que añadas se descuentan de la superficie a pintar.';

  @override
  String openingSummary(String kind, String width, String height) {
    return '$kind $width × $height';
  }

  @override
  String openingFromStart(String distance) {
    return 'A $distance del inicio';
  }

  @override
  String get deleteThisWall => 'Eliminar esta pared';

  @override
  String get degreesRequired => 'Escribe los grados';

  @override
  String get degreesRange => 'Entre -359 y 359';

  @override
  String measureThing(String thing) {
    return 'Medir $thing';
  }

  @override
  String deleteThing(String thing) {
    return 'Eliminar $thing';
  }

  @override
  String get deleteWallMessage =>
      'Se borra la pared con sus puertas y ventanas, y el plano se vuelve a trazar con las que queden.';

  @override
  String get newOpening => 'Nuevo vano';

  @override
  String get editOpening => 'Editar vano';

  @override
  String get widthMetersShort => 'Ancho (m)';

  @override
  String get heightMetersShort => 'Alto (m)';

  @override
  String get openingTooWide => 'No cabe en la pared';

  @override
  String get openingTooTall => 'Pasa de la altura del muro';

  @override
  String get openingDistance => 'Desde el inicio de la pared (m)';

  @override
  String wallMeasures(String length) {
    return 'La pared mide $length';
  }

  @override
  String get addOpening => 'Añadir vano';

  @override
  String get deleteOpening => 'Eliminar vano';

  @override
  String get measureRequired => 'Escribe una medida';

  @override
  String get openingOffWall => 'El vano se sale de la pared';

  @override
  String get door => 'Puerta';

  @override
  String get window => 'Ventana';

  @override
  String get planNeedsTwoWalls =>
      'Añade al menos dos paredes para ver el plano';

  @override
  String get exportPdf => 'Exportar en PDF';

  @override
  String get wholeProject => 'Todo el proyecto';

  @override
  String get oneRoom => 'Una habitación';

  @override
  String pdfFailed(String error) {
    return 'No se pudo crear el PDF: $error';
  }

  @override
  String get whichMaterial => '¿Qué material entra?';

  @override
  String materialNeeded(String surface, String quantity, String unit) {
    return '$surface · harían falta $quantity $unit';
  }

  @override
  String materialLine(
    String surface,
    String quantity,
    String unit,
    String price,
  ) {
    return '$surface · $quantity $unit × $price';
  }

  @override
  String priceOf(String material) {
    return 'Precio de $material';
  }

  @override
  String pricePer(String unit) {
    return 'Precio por $unit';
  }

  @override
  String get changePrice => 'Cambiar el precio';

  @override
  String get removeFromBudget => 'Quitar del presupuesto';

  @override
  String get materialsEmptyBody =>
      'Añade los materiales que quieras presupuestar. Las cantidades salen del plano; tú pones el precio y decides cuáles entran.';

  @override
  String get otherItems => 'Otras partidas';

  @override
  String get otherItemsEmptyBody =>
      'Aquí van el acero, la teja, la mano de obra y todo lo que no sale del plano.';

  @override
  String itemLine(String category, String quantity, String unit, String price) {
    return '$category · $quantity $unit × $price';
  }

  @override
  String get finishes => 'Acabados';

  @override
  String get finishesEmptyBody =>
      'Marca las paredes y los pisos que llevan pintura, estuco o enchape y ponles precio por m². Los metros salen del plano.';

  @override
  String finishLine(String where, String area, String price) {
    return '$where · $area × $price';
  }

  @override
  String wallCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paredes',
      one: '1 pared',
    );
    return '$_temp0';
  }

  @override
  String floorCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pisos',
      one: '1 piso',
    );
    return '$_temp0';
  }

  @override
  String get noSurfaces => 'Sin superficies';

  @override
  String get summary => 'Resumen';

  @override
  String get labour => 'Mano de obra';

  @override
  String get otherCategory => 'Otros';

  @override
  String get materialCategory => 'Material';

  @override
  String get total => 'Total';

  @override
  String perSquareMetre(String price) {
    return '$price por m² de piso';
  }

  @override
  String get newFinish => 'Nuevo acabado';

  @override
  String get editFinish => 'Editar acabado';

  @override
  String get whatIsDone => 'Qué se hace';

  @override
  String get whatIsDoneHint => 'Pintura vinilo, estuco, enchape…';

  @override
  String get whatIsDoneRequired => 'Escribe qué acabado es';

  @override
  String get pricePerSquareMetre => 'Precio por m²';

  @override
  String get whereItGoes => 'Dónde se aplica';

  @override
  String get noRoomsMeasured => 'Todavía no hay habitaciones medidas.';

  @override
  String get addFinish => 'Añadir acabado';

  @override
  String get deleteFinish => 'Eliminar acabado';

  @override
  String get floor => 'Piso';

  @override
  String surfaceTile(String surface, String area) {
    return '$surface · $area';
  }

  @override
  String get markOneSurface => 'Marca al menos una pared o un piso.';

  @override
  String deleteFinishMessage(String finish) {
    return 'Se quita «$finish» del presupuesto. Las paredes y el plano no se tocan.';
  }

  @override
  String markedArea(String area) {
    return 'Marcado: $area';
  }

  @override
  String get unitShort => 'unid';

  @override
  String get newItem => 'Nueva partida';

  @override
  String get editItem => 'Editar partida';

  @override
  String get description => 'Descripción';

  @override
  String get itemHint => 'Varilla de 1/2, teja, ayudante…';

  @override
  String get itemRequired => 'Escribe qué es';

  @override
  String get quantity => 'Cantidad';

  @override
  String get unit => 'Unidad';

  @override
  String get missing => 'Falta';

  @override
  String get pricePerUnit => 'Precio por unidad';

  @override
  String get addItem => 'Añadir partida';

  @override
  String get deleteItem => 'Eliminar partida';

  @override
  String get materialBlock => 'Bloques o ladrillos';

  @override
  String get materialCement => 'Cemento';

  @override
  String get materialSand => 'Arena';

  @override
  String get materialPaint => 'Pintura';

  @override
  String get materialAdhesive => 'Pegante';

  @override
  String get materialTile => 'Baldosas';

  @override
  String get unitBag => 'bulto';

  @override
  String get unitGallon => 'gal';

  @override
  String get unitKilogram => 'kg';

  @override
  String get surfaceWalls => 'Paredes';

  @override
  String get surfaceFloor => 'Piso';

  @override
  String pdfDocumentTitle(String project) {
    return 'Presupuesto $project';
  }

  @override
  String get pdfHeading => 'Presupuesto de obra';

  @override
  String pdfScope(String scope) {
    return 'Alcance: $scope';
  }

  @override
  String pdfFooter(String page, String pages) {
    return 'Hecho con Planova · página $page de $pages';
  }

  @override
  String pdfRunningTitle(String project) {
    return '$project · Presupuesto';
  }

  @override
  String get calculatedMaterials => 'Materiales calculados';

  @override
  String get noRoomsMeasuredYet => 'No hay habitaciones medidas todavía.';

  @override
  String get pdfFloorArea => 'Área de piso';

  @override
  String get wallsCountLabel => 'Paredes';

  @override
  String pdfPlanOpenBy(String gap) {
    return 'El plano no cierra por $gap.';
  }

  @override
  String get columnMaterial => 'Material';

  @override
  String get columnFrom => 'De';

  @override
  String get columnQuantity => 'Cantidad';

  @override
  String get columnUnit => 'Unidad';

  @override
  String get columnUnitPrice => 'Precio unitario';

  @override
  String get columnSubtotal => 'Subtotal';

  @override
  String get noPrice => 'sin precio';

  @override
  String get columnFinish => 'Acabado';

  @override
  String get columnWhere => 'Dónde';

  @override
  String get columnSurface => 'Superficie';

  @override
  String get columnPricePerSquareMetre => 'Precio por m²';

  @override
  String get columnDescription => 'Descripción';

  @override
  String get columnCategory => 'Capítulo';

  @override
  String get pdfEstimateNote =>
      'Las cantidades de material se calculan a partir de las medidas del plano e incluyen desperdicio. Son una estimación.';

  @override
  String get tuneRates => 'Ajustar rendimientos';

  @override
  String get materialsNote =>
      'Las cantidades ya traen el desperdicio. Son una estimación: compruébalas antes de comprar.';

  @override
  String surfacesLine(String walls, String floor) {
    return 'Muros sin vanos $walls · Piso $floor';
  }

  @override
  String get masonry => 'Mampostería';

  @override
  String piecesCount(String count) {
    return '$count piezas';
  }

  @override
  String fromWallsNotFloor(String area) {
    return 'De $area de muros (no del piso)';
  }

  @override
  String get bedMortar => 'Mortero de pega';

  @override
  String cementBags(String count) {
    return '$count bultos';
  }

  @override
  String masonryNote(
    String area,
    String perSquareMetre,
    String waste,
    String length,
    String height,
    String joint,
    String thickness,
  ) {
    return '$area × $perSquareMetre piezas/m² + $waste % de desperdicio. Pieza de $length × $height, junta de $joint, muro de $thickness.';
  }

  @override
  String fromWallsAndCeiling(String area) {
    return 'De $area de muros y cielo raso';
  }

  @override
  String get inGallons => 'En galones';

  @override
  String gallonsValue(String count) {
    return '$count gal';
  }

  @override
  String get surface => 'Superficie';

  @override
  String paintNote(String coats, String coverage, String ceiling) {
    return '$coats manos · $coverage m² por litro$ceiling';
  }

  @override
  String get includesCeiling => ' · incluye el cielo raso';

  @override
  String tilesCount(String count) {
    return '$count baldosas';
  }

  @override
  String fromFloorArea(String area) {
    return 'De $area de piso';
  }

  @override
  String floorNote(
    String area,
    String perSquareMetre,
    String waste,
    String length,
    String width,
  ) {
    return '$area × $perSquareMetre baldosas/m² + $waste % de desperdicio. Baldosa de $length × $width.';
  }

  @override
  String get nothingToCalculate => 'Aún no hay de dónde calcular';

  @override
  String get nothingToCalculateBody =>
      'Los materiales salen de lo que miden las habitaciones. Crea la primera y vuelve aquí.';

  @override
  String get projectRates => 'Rendimientos del proyecto';

  @override
  String get projectRatesNote =>
      'Estas cifras son las que usa la calculadora. Cámbialas por las de tu obra y los materiales se recalculan solos.';

  @override
  String get pieceLengthCm => 'Largo de la pieza (cm)';

  @override
  String get pieceHeightCm => 'Alto de la pieza (cm)';

  @override
  String get jointCm => 'Junta de pega (cm)';

  @override
  String get wallThicknessCm => 'Espesor del muro (cm)';

  @override
  String get wastePercent => 'Desperdicio (%)';

  @override
  String get cementPerCubicMetre => 'Cemento (bultos/m³)';

  @override
  String get sandPerCubicMetre => 'Arena por m³ de mortero (m³)';

  @override
  String get paint => 'Pintura';

  @override
  String get coats => 'Manos';

  @override
  String get coverage => 'Rendimiento (m² por L)';

  @override
  String get paintCeilingToo => 'Pintar también el cielo raso';

  @override
  String get tileLengthCm => 'Largo baldosa (cm)';

  @override
  String get tileWidthCm => 'Ancho baldosa (cm)';

  @override
  String get adhesivePerSquareMetre => 'Pegante (kg por m²)';

  @override
  String get saveRates => 'Guardar rendimientos';

  @override
  String get howItMeasures => 'Cómo se mide';

  @override
  String get gotIt => 'Entendido';

  @override
  String get spatialHelpBody =>
      '1. Mueve despacio el teléfono apuntando al suelo hasta que la app reconozca la superficie.\n2. Apunta con la mira al pie de una esquina y marca.\n3. Ve a la siguiente esquina y marca otra vez: la pared queda hecha con su medida. Puedes caminar, que el plano no se mueve.\n4. Al volver a la primera esquina, la línea se engancha a ella: ahí se cierra la habitación.\n\nAl cerrar le pones nombre y la habitación queda creada con sus paredes. La altura del techo se mide después, desde la habitación. Aquí la distancia la mide el aparato, no se estima. Aun así conviene revisar las paredes en el plano antes de comprar material.';

  @override
  String get atCornerOneClose => 'Estás en la esquina 1: cierra la habitación';

  @override
  String get moveToFindFloor =>
      'Mueve el teléfono despacio para reconocer el suelo';

  @override
  String wallChip(String number, String length) {
    return 'Pared $number · $length';
  }

  @override
  String cornerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count esquinas',
      one: '1 esquina',
    );
    return '$_temp0';
  }

  @override
  String get undoLast => 'Quitar la última';

  @override
  String get closeRoom => 'Cerrar habitación';

  @override
  String get markCorner => 'Marcar esquina';

  @override
  String get finishWithoutClosing => 'Terminar sin cerrar';

  @override
  String get moveToFindSurface =>
      'Mueve el teléfono despacio para reconocer la superficie';

  @override
  String get aimAtOneEnd => 'Apunta a un extremo y márcalo';

  @override
  String get markTheStart => 'Marcar el principio';

  @override
  String get aimAtOtherEnd => 'Apunta al otro extremo';

  @override
  String useMeasure(String measure) {
    return 'Usar $measure';
  }

  @override
  String get startAgain => 'Empezar de nuevo';

  @override
  String get noCamera =>
      'Este aparato no tiene cámara. Puedes medir igual apuntando con el teléfono.';

  @override
  String get cameraDenied =>
      'Planova no tiene permiso para la cámara. Puedes dárselo en los ajustes del teléfono, o medir igual apuntando sin ver la imagen.';

  @override
  String get cameraFailed =>
      'No se pudo abrir la cámara. Puedes medir igual apuntando con el teléfono.';

  @override
  String get ceilingHeight => 'Altura del techo';

  @override
  String get metresFloorToCeiling => 'Metros del suelo al techo';

  @override
  String get ceilingHeightHelp =>
      'Es lo único que hay que saber: con eso salen las demás';

  @override
  String get sightingsDoNotMatch =>
      'No cuadra: apunta al pie de una pared y luego al techo de esa misma pared.';

  @override
  String calibrationDone(String height, String distance) {
    return 'Listo: llevas el teléfono a $height del suelo y esa pared está a $distance.';
  }

  @override
  String get whichCorner => '¿A qué esquina apuntas?';

  @override
  String get whichCornerBody =>
      'Desde donde estás ahora, apunta al pie de una esquina que ya hayas marcado. Con eso la app vuelve a saber dónde estás y el plano no se mueve.';

  @override
  String get legacyHelpBody =>
      '1. Toca «Sin calibrar» y escribe la altura del techo. Apunta al pie de una pared, fija, y luego al techo de esa misma pared. Con eso la app sabe a qué altura llevas el teléfono y mide bien.\n2. Apunta con la mira al pie de una esquina, donde la pared toca el suelo, y marca.\n3. Gira sobre ti mismo: desde la esquina marcada sale una línea que sigue a la mira. Marca la siguiente y la pared queda hecha.\n4. Al volver a la primera esquina, la línea se engancha a ella: ahí se cierra la habitación.\n\nSi tienes que caminar, toca «Me moví», apunta a una esquina que ya hayas marcado y fija tu posición: el plano se queda donde está.\n\nTodo esto es una estimación: después puedes corregir cada pared con el flexómetro en el editor del plano.';

  @override
  String get waitingForSensors => 'Esperando a los sensores…';

  @override
  String get aimAtWallFootLockFloor =>
      'Apunta al pie de una pared y fija el suelo';

  @override
  String get nowAtTheCeiling => 'Ahora al techo de esa misma pared';

  @override
  String aimAtCornerFixPosition(String corner) {
    return 'Apunta al pie de la esquina $corner y fija tu posición';
  }

  @override
  String get aimLowerAtWallFoot => 'Apunta más abajo, al pie de la pared';

  @override
  String get turnOnTheSpot =>
      'Gira sobre ti mismo, sin caminar. Si te mueves, usa «Me moví».';

  @override
  String calibrated(String height) {
    return 'Calibrado · $height';
  }

  @override
  String get notCalibrated => 'Sin calibrar';

  @override
  String get iMoved => 'Me moví';

  @override
  String get lockFloor => 'Fijar el suelo';

  @override
  String get lockCeiling => 'Fijar el techo';

  @override
  String get iAmHere => 'Estoy aquí';

  @override
  String get noGyroscopeTitle => 'Este teléfono no puede medir el giro';

  @override
  String get noGyroscopeBody =>
      'Le falta el giroscopio, así que no hay forma de saber hacia dónde apuntas al girar sobre ti mismo y el plano saldría inventado.\n\nPuedes crear la habitación escribiendo el ancho y el largo, y ajustar cada pared en el plano.';

  @override
  String get goBack => 'Volver';
}
