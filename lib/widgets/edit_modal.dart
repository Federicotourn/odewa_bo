import 'package:flutter/material.dart';
import 'package:odewa_bo/constants/app_theme.dart';

class EditField {
  final String label;
  final TextEditingController controller;

  EditField({required this.label, required this.controller});
}

class EditModal extends StatelessWidget {
  final String title;
  final List<Widget> fields;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final bool isEdit;

  const EditModal({
    super.key,
    required this.title,
    required this.fields,
    required this.onSave,
    required this.onCancel,
    this.isEdit = true,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: fields),
      ),
      actions: [
        TextButton(onPressed: onCancel, child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: onSave,
          child: Text(isEdit ? 'Guardar' : 'Agregar'),
        ),
      ],
    );
  }
}
