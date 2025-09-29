## General

- For routing, use go_router (see main.dart)
- For state management, use Riverpod 3.0; don't use deprecated syntax like AutoDispose, Family or "<Name>Ref" (just use Ref)
- Use freezed only for models that can really benefit from it (e.g. immutable and needing json persistence)
- Refer to routes in dart by <widget>.routeName, this is the only place where we hardcode route strings (with the exception of the initial home route)

## File organization

- directories:
  - **lib/data/{feature}**: ephemeral state (riverpod), persisted state (riverpod), drift database&tables, and hardcoded data (and supporting enums)
  - **lib/model/{feature}**: domain models
  - **lib/service**: services which interface with sharedPrefs or drift, and are accessed via providers
  - **lib/util**: various utilities
  - **lib/ui/{feature}/page** for main screens and huge widgets that make up large parts of a page
  - **lib/ui/{feature}/widget** for smaller widgets

Some projects subdivide by feature first, and then by ui, model, service, etc.  But we expect commonalities between different data files, ui files, etc (across features), so putting them closer together makes diffing and copying easier.

Apply DRY at filename level. E.g. if it's in the `<feature>/page` directory, the file doesn't need to have "feature" or "page" in its name (but should have Page or Screen in its dart class)
