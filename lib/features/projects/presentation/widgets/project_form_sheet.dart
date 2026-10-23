import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/project.dart';
import '../../domain/entities/project_draft.dart';
import '../providers/project_providers.dart';

/// Hoja para crear un proyecto o editar uno existente.
class ProjectFormSheet extends ConsumerStatefulWidget {
  const ProjectFormSheet._({this.project});

  /// Abre la hoja. Sin [project] crea uno nuevo; con él, lo edita.
  static Future<void> show(BuildContext context, {Project? project}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: ProjectFormSheet._(project: project),
      ),
    );
  }

  final Project? project;

  @override
  ConsumerState<ProjectFormSheet> createState() => _ProjectFormSheetState();
}

class _ProjectFormSheetState extends ConsumerState<ProjectFormSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _client;
  late final TextEditingController _address;
  late final TextEditingController _notes;
  bool _saving = false;

  bool get _isEditing => widget.project != null;

  @override
  void initState() {
    super.initState();
    final Project? project = widget.project;
    _name = TextEditingController(text: project?.name ?? '');
    _client = TextEditingController(text: project?.client ?? '');
    _address = TextEditingController(text: project?.address ?? '');
    _notes = TextEditingController(text: project?.notes ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _client.dispose();
    _address.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isEditing ? 'Editar proyecto' : 'Nuevo proyecto',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _name,
                autofocus: !_isEditing,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Nombre del proyecto',
                  hintText: 'Casa de dos pisos, remodelación cocina…',
                ),
                validator: (String? value) =>
                    (value == null || value.trim().isEmpty)
                        ? 'Ponle un nombre al proyecto'
                        : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _client,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Cliente'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _address,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(labelText: 'Dirección'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notes,
                textCapitalization: TextCapitalization.sentences,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Notas'),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: Text(_isEditing ? 'Guardar cambios' : 'Crear proyecto'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final NavigatorState navigator = Navigator.of(context);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final ProjectDraft draft = ProjectDraft(
      name: _name.text.trim(),
      client: _trimmedOrNull(_client),
      address: _trimmedOrNull(_address),
      notes: _trimmedOrNull(_notes),
    );

    setState(() => _saving = true);
    try {
      final repository = ref.read(projectRepositoryProvider);
      final Project? project = widget.project;
      if (project == null) {
        await repository.create(draft);
      } else {
        await repository.update(project.id, draft);
      }
      navigator.pop();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'Proyecto actualizado' : 'Proyecto creado',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(
        SnackBar(content: Text('No se pudo guardar: $error')),
      );
    }
  }

  String? _trimmedOrNull(TextEditingController controller) {
    final String value = controller.text.trim();
    return value.isEmpty ? null : value;
  }
}
