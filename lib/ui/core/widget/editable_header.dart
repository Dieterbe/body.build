import 'package:flutter/material.dart';

class EditableHeader extends StatelessWidget {
  final String text;
  final String? hintText;
  final VoidCallback? onDelete;
  final ValueChanged<String>? onTextChanged;
  final ValueChanged<int>? onNumChanged; // shows a number before the name. optional
  final int? n; // shows a number before the name. optional

  const EditableHeader({
    super.key,
    required this.text,
    this.hintText,
    this.onDelete,
    this.onTextChanged,
    this.onNumChanged,
    this.n,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: text);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          if (onNumChanged != null)
            DropdownButton<int>(
              value: n,
              items: List.generate(10, (i) => i + 1).map((int value) {
                return DropdownMenuItem<int>(value: value, child: Text('$value'));
              }).toList(),
              onChanged: (int? value) {
                if (value != null) {
                  onNumChanged!(value);
                }
              },
            ),
          if (onNumChanged != null) Text(' x ', style: Theme.of(context).textTheme.titleLarge),
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                hintText: hintText,
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
              ),
              onSubmitted: onTextChanged,
            ),
          ),
          if (onDelete != null) ...[
            const SizedBox(width: 8),
            IconButton(icon: const Icon(Icons.delete_outline), onPressed: onDelete),
          ],
        ],
      ),
    );
  }
}
