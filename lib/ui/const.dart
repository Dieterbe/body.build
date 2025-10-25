const minScreenWidth = 1000; // enforced. we need this to make render properly
// we don't enforce a minimum screen height, because the whole UI is vertically scrollable

// These values are set during building. see launch.json (local) or codemagic config (CI)
const appVersion = String.fromEnvironment('APP_VERSION');
const appBuildTime = String.fromEnvironment('APP_BUILD_TIME');
