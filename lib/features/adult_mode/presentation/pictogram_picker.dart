import 'package:flutter/material.dart';

import '../../../core/db/app_database.dart';
import '../../boards/presentation/pictogram_image.dart';

/// Diálogo con buscador para elegir un pictograma de una lista.
class PictogramPickerDialog extends StatefulWidget {
  const PictogramPickerDialog({
    super.key,
    required this.loader,
    this.title = 'Agregar pictograma',
  });

  final Future<List<Pictogram>> Function() loader;
  final String title;

  @override
  State<PictogramPickerDialog> createState() => _PictogramPickerDialogState();
}

class _PictogramPickerDialogState extends State<PictogramPickerDialog> {
  List<Pictogram> _all = const [];
  String _query = '';

  @override
  void initState() {
    super.initState();
    widget.loader().then((v) {
      if (mounted) setState(() => _all = v);
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = _query.toLowerCase();
    final shown = _all
        .where((p) => p.labelEs.toLowerCase().contains(q))
        .toList();
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: double.maxFinite,
        height: 420,
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar',
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: shown.length,
                itemBuilder: (_, i) => ListTile(
                  leading: SizedBox(
                    width: 44,
                    height: 44,
                    child: PictogramImage(shown[i]),
                  ),
                  title: Text(shown[i].labelEs),
                  onTap: () => Navigator.pop(context, shown[i]),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
