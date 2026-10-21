import 'package:cs_elective_2/models/pokemon.dart';
import 'package:cs_elective_2/state/pokemon_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Opens the nickname editor for [pokemon].
Future<void> showNicknameEditor(BuildContext context, Pokemon pokemon) {
  return showDialog<void>(
    context: context,
    builder: (context) => NicknameEditorDialog(pokemon: pokemon),
  );
}

class NicknameEditorDialog extends ConsumerStatefulWidget {
  const NicknameEditorDialog({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  ConsumerState<NicknameEditorDialog> createState() =>
      _NicknameEditorDialogState();
}

class _NicknameEditorDialogState extends ConsumerState<NicknameEditorDialog> {
  static const _maxLength = 20;

  late final TextEditingController _controller;
  late final String? _currentNickname;

  @override
  void initState() {
    super.initState();
    _currentNickname = ref.read(nicknamesProvider)[widget.pokemon.id];
    _controller = TextEditingController(text: _currentNickname);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    ref
        .read(nicknamesProvider.notifier)
        .setNickname(widget.pokemon.id, _controller.text);
    Navigator.of(context).pop();
  }

  void _remove() {
    ref.read(nicknamesProvider.notifier).removeNickname(widget.pokemon.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(),
      title: Text(
        _currentNickname == null ? 'Add nickname' : 'Edit nickname',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Original name: ${widget.pokemon.displayName}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            maxLength: _maxLength,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
            decoration: const InputDecoration(
              labelText: 'Nickname',
              hintText: 'Leave blank to remove',
              border: OutlineInputBorder(borderRadius: BorderRadius.zero),
            ),
          ),
        ],
      ),
      actions: [
        if (_currentNickname != null)
          TextButton.icon(
            onPressed: _remove,
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text('Remove'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
