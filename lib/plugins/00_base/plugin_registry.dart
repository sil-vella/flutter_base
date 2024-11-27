// plugins/plugin_registry.dart

import '../admobs/admobs_main.dart';
import '../api/api.dart';
import '../plugin_example/plugin_example_main.dart';
import 'plugin_manager.dart';

void registerPlugins() {

  PluginManager().registerPlugin(Api());
  PluginManager().registerPlugin(AdmobsPlugin());
  PluginManager().registerPlugin(PluginExample());
}