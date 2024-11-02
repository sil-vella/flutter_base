import '../base/plugin_manager.dart';

class ExamplePlugin implements AppPlugin {
  ExamplePlugin._internal();

  static void register() {
    PluginManager().registerPlugin(ExamplePlugin._internal());
  }

  @override
  void initialize() {
    print("ExamplePlugin initialized");
  }
}
