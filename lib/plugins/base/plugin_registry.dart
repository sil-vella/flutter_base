// plugin_registry.dart
import '../example_plugin/example_plugin_main.dart';

/// List of all plugin registration functions
final List<Function> pluginRegistrations = [
  ExamplePlugin.register,
  // Add other plugins here in the future
];
