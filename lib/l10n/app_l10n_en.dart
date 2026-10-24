// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppL10nEn extends AppL10n {
  AppL10nEn([String locale = 'en']) : super(locale);

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get delete => 'Delete';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get optionSystem => 'Same as the system';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get languageEnglish => 'English';

  @override
  String get settingsCurrency => 'Currency';

  @override
  String get currencyNote =>
      'Changes how prices are written. It doesn\'t convert them — what you typed is still worth the same.';

  @override
  String get currencyCop => 'Colombian peso';

  @override
  String get currencyUsd => 'Dollar';

  @override
  String get projectsLoadError => 'Couldn\'t load your projects';

  @override
  String get projectsEmptyTitle => 'No projects yet';

  @override
  String get projectsEmptyBody =>
      'Create the first one to start saving rooms, plans and budgets.';

  @override
  String get newProject => 'New project';

  @override
  String get editProject => 'Edit project';

  @override
  String get createProject => 'Create project';

  @override
  String get deleteProject => 'Delete project';

  @override
  String deleteProjectMessage(String project) {
    return '“$project” will be deleted, along with everything in it. This can\'t be undone.';
  }

  @override
  String updatedOn(String date) {
    return 'Updated on $date';
  }

  @override
  String get projectName => 'Project name';

  @override
  String get projectNameHint => 'Two-story house, kitchen remodel…';

  @override
  String get projectNameRequired => 'Give the project a name';

  @override
  String get client => 'Client';

  @override
  String get address => 'Address';

  @override
  String get notes => 'Notes';

  @override
  String get projectCreated => 'Project created';

  @override
  String get projectUpdated => 'Project updated';

  @override
  String saveFailed(String error) {
    return 'Couldn\'t save: $error';
  }

  @override
  String get projectGone => 'That project no longer exists';

  @override
  String roomsLoadError(String error) {
    return 'Couldn\'t load the rooms: $error';
  }

  @override
  String get materials => 'Materials';

  @override
  String get materialsCardBody =>
      'Blocks or bricks, mortar, paint and flooring, using your own rates';

  @override
  String get budget => 'Budget';

  @override
  String get budgetCardBody => 'Prices, labor and cost per m²';

  @override
  String get rooms => 'Rooms';

  @override
  String get roomsEmptyBody =>
      'No rooms yet. Create the first one with its width and length, then adjust the plan wall by wall.';

  @override
  String get newRoom => 'New room';

  @override
  String get measureWithCamera => 'Measure with the camera';

  @override
  String get measureWithCameraBody =>
      'Aim at the foot of each corner and the plan draws itself';

  @override
  String get typeMeasurements => 'Type the measurements';

  @override
  String get typeMeasurementsBody => 'Width and length, then adjust the plan';

  @override
  String get deleteRoom => 'Delete room';

  @override
  String deleteRoomMessage(String room) {
    return '“$room” will be deleted, along with its plan, its walls and its openings.';
  }

  @override
  String roomCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'rooms',
      one: 'room',
    );
    return '$_temp0';
  }

  @override
  String get builtArea => 'built area';

  @override
  String get netWallArea => 'net wall area';

  @override
  String roomCardSummary(String area, String walls, String perimeter) {
    return '$area · $walls walls · perimeter $perimeter';
  }

  @override
  String planDoesNotClose(String gap) {
    return 'The plan doesn\'t close — $gap missing';
  }

  @override
  String get name => 'Name';

  @override
  String get roomNameHint => 'Living room, kitchen, bedroom 1…';

  @override
  String get roomNameRequired => 'Give the room a name';

  @override
  String get widthMeters => 'Width (m)';

  @override
  String get lengthMeters => 'Length (m)';

  @override
  String get wallHeightMeters => 'Wall height (m)';

  @override
  String get measureHeightWithCamera => 'Measure the height with the camera';

  @override
  String get createRoom => 'Create room';

  @override
  String get editRoom => 'Edit room';

  @override
  String get saveScanned => 'Save the scan';

  @override
  String get measureHeight => 'Measure the height';

  @override
  String get roomGone => 'That room no longer exists';

  @override
  String get walls => 'Walls';

  @override
  String get addWall => 'Add wall';

  @override
  String get wallsEmptyBody =>
      'This room has no walls yet. Add the first one to start the outline.';

  @override
  String get floorArea => 'Floor area';

  @override
  String get perimeter => 'Perimeter';

  @override
  String get netWallAreaTitle => 'Net wall area';

  @override
  String get height => 'Height';

  @override
  String planOpenWarning(String gap) {
    return 'The outline doesn\'t come back to where it started — $gap missing. Check the lengths and the turns; the area is figured by closing the plan along the last wall.';
  }

  @override
  String get wallStart => 'start';

  @override
  String wallTurn(String degrees) {
    return 'turns $degrees';
  }

  @override
  String wallName(int number) {
    return 'Wall $number';
  }

  @override
  String doorCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count doors',
      one: '1 door',
    );
    return '$_temp0';
  }

  @override
  String windowCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count windows',
      one: '1 window',
    );
    return '$_temp0';
  }

  @override
  String listAnd(String first, String second) {
    return '$first and $second';
  }

  @override
  String get wallLengthMeters => 'Wall length (m)';

  @override
  String get wallTurnDegrees => 'Turn from the previous wall (°)';

  @override
  String get wallTurnHelp => '90 turns right, -90 turns left';

  @override
  String get measureAgainWithCamera => 'Measure again with the camera';

  @override
  String get saveWall => 'Save wall';

  @override
  String get doorsAndWindows => 'Doors and windows';

  @override
  String get add => 'Add';

  @override
  String get openingsEmptyBody =>
      'This wall has no openings. Anything you add is subtracted from the surface to be painted.';

  @override
  String openingSummary(String kind, String width, String height) {
    return '$kind $width × $height';
  }

  @override
  String openingFromStart(String distance) {
    return '$distance from the start';
  }

  @override
  String get deleteThisWall => 'Delete this wall';

  @override
  String get degreesRequired => 'Enter the degrees';

  @override
  String get degreesRange => 'Between -359 and 359';

  @override
  String measureThing(String thing) {
    return 'Measure $thing';
  }

  @override
  String deleteThing(String thing) {
    return 'Delete $thing';
  }

  @override
  String get deleteWallMessage =>
      'The wall goes, along with its doors and windows, and the plan is redrawn with the ones left.';

  @override
  String get newOpening => 'New opening';

  @override
  String get editOpening => 'Edit opening';

  @override
  String get widthMetersShort => 'Width (m)';

  @override
  String get heightMetersShort => 'Height (m)';

  @override
  String get openingTooWide => 'It doesn\'t fit on the wall';

  @override
  String get openingTooTall => 'It\'s taller than the wall';

  @override
  String get openingDistance => 'From the start of the wall (m)';

  @override
  String wallMeasures(String length) {
    return 'The wall is $length long';
  }

  @override
  String get addOpening => 'Add opening';

  @override
  String get deleteOpening => 'Delete opening';

  @override
  String get measureRequired => 'Enter a measurement';

  @override
  String get openingOffWall => 'The opening runs past the end of the wall';

  @override
  String get door => 'Door';

  @override
  String get window => 'Window';

  @override
  String get planNeedsTwoWalls => 'Add at least two walls to see the plan';

  @override
  String get exportPdf => 'Export as PDF';

  @override
  String get wholeProject => 'The whole project';

  @override
  String get oneRoom => 'One room';

  @override
  String pdfFailed(String error) {
    return 'Couldn\'t create the PDF: $error';
  }

  @override
  String get whichMaterial => 'Which material goes in?';

  @override
  String materialNeeded(String surface, String quantity, String unit) {
    return '$surface · $quantity $unit needed';
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
    return 'Price of $material';
  }

  @override
  String pricePer(String unit) {
    return 'Price per $unit';
  }

  @override
  String get changePrice => 'Change the price';

  @override
  String get removeFromBudget => 'Remove from the budget';

  @override
  String get materialsEmptyBody =>
      'Add the materials you want to budget for. The quantities come from the plan; you set the price and decide which ones go in.';

  @override
  String get otherItems => 'Other items';

  @override
  String get otherItemsEmptyBody =>
      'Steel, roofing, labor and anything else that doesn\'t come from the plan goes here.';

  @override
  String itemLine(String category, String quantity, String unit, String price) {
    return '$category · $quantity $unit × $price';
  }

  @override
  String get finishes => 'Finishes';

  @override
  String get finishesEmptyBody =>
      'Check the walls and floors that get paint, stucco or tile and give them a price per m². The square meters come from the plan.';

  @override
  String finishLine(String where, String area, String price) {
    return '$where · $area × $price';
  }

  @override
  String wallCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count walls',
      one: '1 wall',
    );
    return '$_temp0';
  }

  @override
  String floorCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count floors',
      one: '1 floor',
    );
    return '$_temp0';
  }

  @override
  String get noSurfaces => 'No surfaces';

  @override
  String get summary => 'Summary';

  @override
  String get labour => 'Labor';

  @override
  String get otherCategory => 'Other';

  @override
  String get materialCategory => 'Material';

  @override
  String get total => 'Total';

  @override
  String perSquareMetre(String price) {
    return '$price per m² of floor';
  }

  @override
  String get newFinish => 'New finish';

  @override
  String get editFinish => 'Edit finish';

  @override
  String get whatIsDone => 'What gets done';

  @override
  String get whatIsDoneHint => 'Latex paint, stucco, tile…';

  @override
  String get whatIsDoneRequired => 'Name the finish';

  @override
  String get pricePerSquareMetre => 'Price per m²';

  @override
  String get whereItGoes => 'Where it goes';

  @override
  String get noRoomsMeasured => 'No rooms measured yet.';

  @override
  String get addFinish => 'Add finish';

  @override
  String get deleteFinish => 'Delete finish';

  @override
  String get floor => 'Floor';

  @override
  String surfaceTile(String surface, String area) {
    return '$surface · $area';
  }

  @override
  String get markOneSurface => 'Check at least one wall or floor.';

  @override
  String deleteFinishMessage(String finish) {
    return '“$finish” is removed from the budget. The walls and the plan aren\'t touched.';
  }

  @override
  String markedArea(String area) {
    return 'Selected: $area';
  }

  @override
  String get unitShort => 'unit';

  @override
  String get newItem => 'New item';

  @override
  String get editItem => 'Edit item';

  @override
  String get description => 'Description';

  @override
  String get itemHint => 'Rebar, roof sheet, helper…';

  @override
  String get itemRequired => 'Name the item';

  @override
  String get quantity => 'Quantity';

  @override
  String get unit => 'Unit';

  @override
  String get missing => 'Missing';

  @override
  String get pricePerUnit => 'Price per unit';

  @override
  String get addItem => 'Add item';

  @override
  String get deleteItem => 'Delete item';

  @override
  String get materialBlock => 'Blocks or bricks';

  @override
  String get materialCement => 'Cement';

  @override
  String get materialSand => 'Sand';

  @override
  String get materialPaint => 'Paint';

  @override
  String get materialAdhesive => 'Adhesive';

  @override
  String get materialTile => 'Tiles';

  @override
  String get unitBag => 'bag';

  @override
  String get unitGallon => 'gal';

  @override
  String get unitKilogram => 'kg';

  @override
  String get surfaceWalls => 'Walls';

  @override
  String get surfaceFloor => 'Floor';

  @override
  String pdfDocumentTitle(String project) {
    return '$project budget';
  }

  @override
  String get pdfHeading => 'Construction budget';

  @override
  String pdfScope(String scope) {
    return 'Scope: $scope';
  }

  @override
  String pdfFooter(String page, String pages) {
    return 'Made with Planova · page $page of $pages';
  }

  @override
  String pdfRunningTitle(String project) {
    return '$project · Budget';
  }

  @override
  String get calculatedMaterials => 'Calculated materials';

  @override
  String get noRoomsMeasuredYet => 'No rooms have been measured yet.';

  @override
  String get pdfFloorArea => 'Floor area';

  @override
  String get wallsCountLabel => 'Walls';

  @override
  String pdfPlanOpenBy(String gap) {
    return 'The plan is $gap short of closing.';
  }

  @override
  String get columnMaterial => 'Material';

  @override
  String get columnFrom => 'From';

  @override
  String get columnQuantity => 'Quantity';

  @override
  String get columnUnit => 'Unit';

  @override
  String get columnUnitPrice => 'Unit price';

  @override
  String get columnSubtotal => 'Subtotal';

  @override
  String get noPrice => 'no price';

  @override
  String get columnFinish => 'Finish';

  @override
  String get columnWhere => 'Where';

  @override
  String get columnSurface => 'Surface';

  @override
  String get columnPricePerSquareMetre => 'Price per m²';

  @override
  String get columnDescription => 'Description';

  @override
  String get columnCategory => 'Category';

  @override
  String get pdfEstimateNote =>
      'Material quantities come from the measurements on the plan and include waste. They are an estimate.';

  @override
  String get tuneRates => 'Adjust the rates';

  @override
  String get materialsNote =>
      'The quantities already include waste. They are an estimate: check them before you buy.';

  @override
  String surfacesLine(String walls, String floor) {
    return 'Net walls $walls · Floor $floor';
  }

  @override
  String get masonry => 'Masonry';

  @override
  String piecesCount(String count) {
    return '$count pieces';
  }

  @override
  String fromWallsNotFloor(String area) {
    return 'From $area of walls (not the floor)';
  }

  @override
  String get bedMortar => 'Mortar';

  @override
  String cementBags(String count) {
    return '$count bags';
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
    return '$area × $perSquareMetre pieces/m² + $waste% waste. Piece $length × $height, joint $joint, wall $thickness.';
  }

  @override
  String fromWallsAndCeiling(String area) {
    return 'From $area of walls and ceiling';
  }

  @override
  String get inGallons => 'In gallons';

  @override
  String gallonsValue(String count) {
    return '$count gal';
  }

  @override
  String get surface => 'Surface';

  @override
  String paintNote(String coats, String coverage, String ceiling) {
    return '$coats coats · $coverage m² per liter$ceiling';
  }

  @override
  String get includesCeiling => ' · ceiling included';

  @override
  String tilesCount(String count) {
    return '$count tiles';
  }

  @override
  String fromFloorArea(String area) {
    return 'From $area of floor';
  }

  @override
  String floorNote(
    String area,
    String perSquareMetre,
    String waste,
    String length,
    String width,
  ) {
    return '$area × $perSquareMetre tiles/m² + $waste% waste. Tile $length × $width.';
  }

  @override
  String get nothingToCalculate => 'Nothing to work from yet';

  @override
  String get nothingToCalculateBody =>
      'Materials come from what the rooms measure. Create the first one and come back here.';

  @override
  String get projectRates => 'Project rates';

  @override
  String get projectRatesNote =>
      'These are the figures the calculator uses. Put in the ones from your own job and the materials are worked out again.';

  @override
  String get pieceLengthCm => 'Piece length (cm)';

  @override
  String get pieceHeightCm => 'Piece height (cm)';

  @override
  String get jointCm => 'Bed joint (cm)';

  @override
  String get wallThicknessCm => 'Wall thickness (cm)';

  @override
  String get wastePercent => 'Waste (%)';

  @override
  String get cementPerCubicMetre => 'Cement (bags/m³)';

  @override
  String get sandPerCubicMetre => 'Sand per m³ of mortar (m³)';

  @override
  String get paint => 'Paint';

  @override
  String get coats => 'Coats';

  @override
  String get coverage => 'Coverage (m² per L)';

  @override
  String get paintCeilingToo => 'Paint the ceiling as well';

  @override
  String get tileLengthCm => 'Tile length (cm)';

  @override
  String get tileWidthCm => 'Tile width (cm)';

  @override
  String get adhesivePerSquareMetre => 'Adhesive (kg per m²)';

  @override
  String get saveRates => 'Save rates';

  @override
  String get howItMeasures => 'How it measures';

  @override
  String get gotIt => 'Got it';

  @override
  String get spatialHelpBody =>
      '1. Move the phone slowly, aiming at the floor, until the app picks up the surface.\n2. Put the crosshair at the foot of a corner and mark it.\n3. Walk to the next corner and mark again: the wall is made with its measurement. You can walk around, the plan stays put.\n4. When you come back to the first corner the line snaps to it: that closes the room.\n\nClosing it asks for a name and the room is created with its walls. The ceiling height is measured afterwards, from the room itself. Here the phone measures the distance, it is not estimated. Even so, check the walls on the plan before buying material.';

  @override
  String get atCornerOneClose => 'You are at corner 1: close the room';

  @override
  String get moveToFindFloor => 'Move the phone slowly to pick up the floor';

  @override
  String wallChip(String number, String length) {
    return 'Wall $number · $length';
  }

  @override
  String cornerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count corners',
      one: '1 corner',
    );
    return '$_temp0';
  }

  @override
  String get undoLast => 'Undo the last one';

  @override
  String get closeRoom => 'Close the room';

  @override
  String get markCorner => 'Mark corner';

  @override
  String get finishWithoutClosing => 'Finish without closing';

  @override
  String get moveToFindSurface =>
      'Move the phone slowly to pick up the surface';

  @override
  String get aimAtOneEnd => 'Aim at one end and mark it';

  @override
  String get markTheStart => 'Mark the start';

  @override
  String get aimAtOtherEnd => 'Aim at the other end';

  @override
  String useMeasure(String measure) {
    return 'Use $measure';
  }

  @override
  String get startAgain => 'Start again';

  @override
  String get noCamera =>
      'This device has no camera. You can still measure by aiming the phone.';

  @override
  String get cameraDenied =>
      'Planova doesn\'t have camera permission. You can grant it in the phone settings, or measure anyway by aiming without seeing the picture.';

  @override
  String get cameraFailed =>
      'The camera wouldn\'t open. You can still measure by aiming the phone.';

  @override
  String get ceilingHeight => 'Ceiling height';

  @override
  String get metresFloorToCeiling => 'Meters from floor to ceiling';

  @override
  String get ceilingHeightHelp =>
      'It\'s the only thing needed — the rest follows from it';

  @override
  String get sightingsDoNotMatch =>
      'That doesn\'t add up — aim at the foot of a wall, then at the ceiling of that same wall.';

  @override
  String calibrationDone(String height, String distance) {
    return 'Done — you\'re holding the phone $height off the floor and that wall is $distance away.';
  }

  @override
  String get whichCorner => 'Where are you measuring from now?';

  @override
  String get whichCornerBody =>
      'This phone doesn\'t know you moved: it only knows where you are aiming. Aim at the foot of a corner you already marked and say which one: that puts you back in place and the plan stays where it is.';

  @override
  String get legacyHelpBody =>
      '1. Tap “Not calibrated” and type the ceiling height. Aim at the foot of a wall, lock it, then at the ceiling of that same wall. That tells the app how high you are holding the phone so it measures properly.\n2. Put the crosshair at the foot of a corner, where the wall meets the floor, and mark it.\n3. Turn in place: a line runs from the marked corner and follows the crosshair. Mark the next one and the wall is made.\n4. When you come back to the first corner the line snaps to it: that closes the room.\n\nThis phone measures from where you are standing, so turn in place instead of walking. If you have to move somewhere else, tap “I moved”, aim at the foot of a corner you already marked and say which one: the app puts you back in place and the plan stays where it is.\n\nAll of this is an estimate: afterwards you can correct each wall with a tape measure in the plan editor.';

  @override
  String get waitingForSensors => 'Waiting for the sensors…';

  @override
  String get aimAtWallFootLockFloor =>
      'Aim at the foot of a wall and lock the floor';

  @override
  String get nowAtTheCeiling => 'Now at the ceiling of that same wall';

  @override
  String aimAtCornerFixPosition(String corner) {
    return 'Aim at the foot of corner $corner and tap “I’m here”';
  }

  @override
  String get aimLowerAtWallFoot => 'Aim lower, at the foot of the wall';

  @override
  String get turnOnTheSpot =>
      'Turn in place, without walking. If you move somewhere else, tap “I moved”.';

  @override
  String calibrated(String height) {
    return 'Calibrated · $height';
  }

  @override
  String get notCalibrated => 'Not calibrated';

  @override
  String get iMoved => 'I moved';

  @override
  String get lockFloor => 'Lock the floor';

  @override
  String get lockCeiling => 'Lock the ceiling';

  @override
  String get iAmHere => 'I\'m here';

  @override
  String get noGyroscopeTitle => 'This phone can\'t tell which way you turn';

  @override
  String get noGyroscopeBody =>
      'It has no gyroscope, so there\'s no way to know where you are aiming as you turn, and the plan would be made up.\n\nYou can still create the room by typing the width and the length, and adjust each wall on the plan.';

  @override
  String get goBack => 'Go back';

  @override
  String cornerNumber(int number) {
    return 'Corner $number';
  }
}
