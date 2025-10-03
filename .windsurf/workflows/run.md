1) Use 'flutter run' to run the app
2) Connect to the running app (Dart MCP: tooling daemon).  
3) Fetch current runtime errors + stack traces (get_runtime_errors ).  
4) Expand the widget tree at the top frame (get_widget_tree ).  
5) Suggest the minimal code edits to fix the issue.  
6) Run a hot_reload and re-fetch errors to confirm resolution.
