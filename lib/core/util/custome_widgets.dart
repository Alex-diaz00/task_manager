import 'package:flutter/material.dart';

class EditIconButton extends StatelessWidget {
  const EditIconButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit, size: 20),
      onPressed: onTap,
      color: Colors.green,
    );
  }
}

class DeleteIconButton extends StatelessWidget {
  const DeleteIconButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete, size: 20),
      onPressed: onTap,
      color: Colors.red,
    );
  }
}

class ArchiveIcon extends StatelessWidget {
  const ArchiveIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.archive, size: 20, color: Colors.grey);
  }
}
