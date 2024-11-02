// plugins/plugin_registry.dart
import '../example_plugin/example_plugin_main.dart';
import '../connect_to_db/connect_to_db_main.dart';

import 'plugin_manager.dart';


void registerPlugins() {
  PluginManager().registerPlugin(PluginExample());
  PluginManager().registerPlugin(ConnectToDb());

}