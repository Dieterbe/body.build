import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class DataManager extends StatelessWidget {
  final List<String> opts;
  // name is guaranteed to be one of the opts
  final Function(String name) onSelect;
  // name is guaranteed to be a unique new name
  final Function(String id, String name) onCreate;
  // nameOld is the currently selected, so you may ignore it
  // nameNew is guaranteed to be unique and different from nameOld
  final Function(String nameOld, String nameNew) onRename;
  // nameOld is the currently selected, so you may ignore it
  // nameNew is guaranteed to be unique
  final Function(String nameOld, String nameNew) onDuplicate;
  final Function(String name)? onDelete;

  const DataManager({
    super.key,
    required this.opts, // first one == currently selected. all strings must be unique
    required this.onSelect,
    required this.onCreate,
    required this.onRename,
    required this.onDuplicate,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Combined selector and name editor
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: DropdownButtonFormField<String>(
                    initialValue: opts.isEmpty ? null : opts.first,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.primary),
                    style: Theme.of(context).textTheme.bodyLarge,
                    items: opts
                        .map(
                          (name) => DropdownMenuItem(
                            value: name,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(child: Text(name, overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (id) {
                      if (id != null) {
                        onSelect(id);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Item management buttons
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      style: IconButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
                      tooltip: 'Rename',
                      onPressed: () {
                        if (opts.isEmpty) return;
                        _showRenameDialog(context, opts.first);
                      },
                    ),
                    IconButton(
                      style: IconButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: Icon(Icons.copy, color: Theme.of(context).colorScheme.primary),
                      tooltip: 'Duplicate',
                      onPressed: () {
                        if (opts.isEmpty) return;
                        _showDuplicateDialog(context, opts.first);
                      },
                    ),
                    IconButton(
                      style: IconButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
                      tooltip: 'New',
                      onPressed: () => _showAddDialog(context),
                    ),
                    IconButton(
                      style: IconButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: Opacity(
                        opacity: onDelete == null ? 0.38 : 1.0,
                        child: Icon(
                          Icons.delete,
                          color: onDelete == null
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.error,
                        ),
                      ),
                      tooltip: onDelete == null ? 'Builtin - cannot be deleted' : 'Delete',
                      onPressed: () {
                        if (opts.isEmpty || onDelete == null) return;
                        _showDeleteDialog(context, opts.first);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormFieldState>();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New'),
        content: TextFormField(
          controller: controller,
          key: formKey,
          decoration: const InputDecoration(
            labelText: 'Name',
            hintText: 'Enter a name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Name cannot be empty';
            }
            if (opts.contains(value)) {
              return 'This name already exists';
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.pop(context, controller.text);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      onCreate(const Uuid().v4(), result);
    }
  }

  Future<void> _showRenameDialog(BuildContext context, String item) async {
    final controller = TextEditingController(text: item);
    final formKey = GlobalKey<FormFieldState>();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename'),
        content: TextFormField(
          controller: controller,
          key: formKey,
          decoration: const InputDecoration(
            labelText: 'New Name',
            hintText: 'Enter a new name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Name cannot be empty';
            }
            if (value != item && opts.contains(value)) {
              return 'This name already exists';
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.pop(context, controller.text);
              }
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty && result != item) {
      onRename(item, result);
    }
  }

  Future<void> _showDuplicateDialog(BuildContext context, String item) async {
    final controller = TextEditingController(text: '$item (Copy)');
    final formKey = GlobalKey<FormFieldState>();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Duplicate'),
        content: TextFormField(
          controller: controller,
          key: formKey,
          decoration: const InputDecoration(
            labelText: 'New Name',
            hintText: 'Enter a new name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Name cannot be empty';
            }
            if (opts.contains(value)) {
              return 'This name already exists';
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.pop(context, controller.text);
              }
            },
            child: const Text('Duplicate'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      onDuplicate(item, result);
    }
  }

  Future<void> _showDeleteDialog(BuildContext context, String item) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete'),
        content: Text('Are you sure you want to delete "$item"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (result == true) {
      onDelete!(item);
    }
  }
}
