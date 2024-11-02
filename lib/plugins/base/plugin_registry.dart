// plugins/plugin_registry.dart
import '../shared_plugin/shared_plugin_main.dart';

import 'plugin_manager.dart';


void registerPlugins() {
  PluginManager().registerPlugin(PluginExample());

}
