// plugins/plugin_registry.dart
import 'package:banner_example/plugins/main_plugin/main_plugin_main.dart';

import '../admobs/admobs_main.dart';
import '../example_plugin/example_plugin_main.dart';
import '../api/api.dart';
import 'plugin_manager.dart';

void registerPlugins() {

  PluginManager().registerPlugin(Api());
  PluginManager().registerPlugin(AdmobsPlugin());

}