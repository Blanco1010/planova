import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/measure_input.dart';
import '../../../../l10n/app_l10n.dart';
import '../../domain/entities/material_settings.dart';
import '../providers/material_providers.dart';

/// Hoja con todos los rendimientos del proyecto en un solo sitio.
///
/// Las medidas se piden en centímetros, que es como vienen los bloques y las
/// baldosas; por dentro se guardan en metros.
class MaterialSettingsSheet extends ConsumerStatefulWidget {
  const MaterialSettingsSheet._({
    required this.projectId,
    required this.settings,
  });

  static Future<void> show(
    BuildContext context, {
    required int projectId,
    required MaterialSettings settings,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: MaterialSettingsSheet._(
          projectId: projectId,
          settings: settings,
        ),
      ),
    );
  }

  final int projectId;
  final MaterialSettings settings;

  @override
  ConsumerState<MaterialSettingsSheet> createState() =>
      _MaterialSettingsSheetState();
}

class _MaterialSettingsSheetState extends ConsumerState<MaterialSettingsSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _fields =
      <String, TextEditingController>{};
  late bool _includeCeiling;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final MaterialSettings settings = widget.settings;

    _fields['blockLength'] = _centimeters(settings.masonry.blockLengthMeters);
    _fields['blockHeight'] = _centimeters(settings.masonry.blockHeightMeters);
    _fields['joint'] = _centimeters(settings.masonry.jointMeters);
    _fields['wallThickness'] = _centimeters(
      settings.masonry.wallThicknessMeters,
    );
    _fields['masonryWaste'] = _number(settings.masonry.wastePercent);
    _fields['cementBags'] = _number(settings.masonry.cementBagsPerCubicMeter);
    _fields['sand'] = _number(settings.masonry.sandCubicMetersPerCubicMeter);

    _fields['coats'] = _number(settings.paint.coats.toDouble());
    _fields['coverage'] = _number(settings.paint.squareMetersPerLiter);
    _fields['paintWaste'] = _number(settings.paint.wastePercent);
    _includeCeiling = settings.paint.includeCeiling;

    _fields['tileLength'] = _centimeters(settings.floor.tileLengthMeters);
    _fields['tileWidth'] = _centimeters(settings.floor.tileWidthMeters);
    _fields['floorWaste'] = _number(settings.floor.wastePercent);
    _fields['adhesive'] = _number(
      settings.floor.adhesiveKilogramsPerSquareMeter,
    );
  }

  @override
  void dispose() {
    for (final TextEditingController controller in _fields.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppL10n t = AppL10n.of(context);
    final ThemeData theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  t.projectRates,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  t.projectRatesNote,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                _Section(title: t.masonry),
                _pair(
                  'blockLength',
                  t.pieceLengthCm,
                  'blockHeight',
                  t.pieceHeightCm,
                ),
                _pair(
                  'joint',
                  t.jointCm,
                  'wallThickness',
                  t.wallThicknessCm,
                ),
                _pair(
                  'masonryWaste',
                  t.wastePercent,
                  'cementBags',
                  t.cementPerCubicMetre,
                ),
                _spaced(_field('sand', t.sandPerCubicMetre)),
                const SizedBox(height: 20),
                _Section(title: t.paint),
                _pair('coats', t.coats, 'coverage', t.coverage),
                _spaced(_field('paintWaste', t.wastePercent)),
                const SizedBox(height: 4),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _includeCeiling,
                  onChanged: (bool value) =>
                      setState(() => _includeCeiling = value),
                  title: Text(t.paintCeilingToo),
                ),
                const SizedBox(height: 12),
                _Section(title: t.floor),
                _pair(
                  'tileLength',
                  t.tileLengthCm,
                  'tileWidth',
                  t.tileWidthCm,
                ),
                _pair(
                  'floorWaste',
                  t.wastePercent,
                  'adhesive',
                  t.adhesivePerSquareMetre,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: Text(t.saveRates),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// El mismo aire que hay entre dos campos emparejados.
  Widget _spaced(Widget field) =>
      Padding(padding: const EdgeInsets.only(top: 12), child: field);

  Widget _pair(
    String firstKey,
    String firstLabel,
    String secondKey,
    String secondLabel,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _field(firstKey, firstLabel)),
          const SizedBox(width: 12),
          Expanded(child: _field(secondKey, secondLabel)),
        ],
      ),
    );
  }

  /// Un desperdicio de cero es una respuesta válida; un bloque de cero, no.
  static const Set<String> _canBeZero = <String>{
    'masonryWaste',
    'paintWaste',
    'floorWaste',
  };

  Widget _field(String key, String label) {
    return TextFormField(
      controller: _fields[key],
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label),
      validator: (String? value) => MeasureInput.validate(
        value,
        min: _canBeZero.contains(key) ? 0 : 0.01,
      ),
    );
  }

  TextEditingController _centimeters(double meters) =>
      TextEditingController(text: Formatters.decimal(meters * 100));

  TextEditingController _number(double value) =>
      TextEditingController(text: Formatters.decimal(value));

  double _value(String key) => MeasureInput.parse(_fields[key]!.text)!;

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final NavigatorState navigator = Navigator.of(context);
    final MaterialSettings settings = MaterialSettings(
      masonry: MasonryParams(
        blockLengthMeters: _value('blockLength') / 100,
        blockHeightMeters: _value('blockHeight') / 100,
        jointMeters: _value('joint') / 100,
        wallThicknessMeters: _value('wallThickness') / 100,
        wastePercent: _value('masonryWaste'),
        cementBagsPerCubicMeter: _value('cementBags'),
        sandCubicMetersPerCubicMeter: _value('sand'),
      ),
      paint: PaintParams(
        coats: _value('coats').round(),
        squareMetersPerLiter: _value('coverage'),
        wastePercent: _value('paintWaste'),
        includeCeiling: _includeCeiling,
      ),
      floor: FloorParams(
        tileLengthMeters: _value('tileLength') / 100,
        tileWidthMeters: _value('tileWidth') / 100,
        wastePercent: _value('floorWaste'),
        adhesiveKilogramsPerSquareMeter: _value('adhesive'),
      ),
    );

    setState(() => _saving = true);
    await ref
        .read(materialSettingsRepositoryProvider)
        .save(widget.projectId, settings);
    navigator.pop();
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}
