---
trigger: always_on
---
- Follow the guidelines in ./docs-dev/README.md
- Never write 'withOpacity(num)', prefer 'withValues(alpha: num)'
- After writing a dart file run `dart format --line-length=100 <file>`
- Avoid using helper functions to generate subtrees of the UI. Instead, use StatelessWidget, StatefulWidget, ConsumerWidget, or ConsumerStatefulWidget to create new widgets in new files, and import them where needed. Only use helpers for trivial pieces of UI code.
