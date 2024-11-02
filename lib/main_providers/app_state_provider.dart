import 'package:flutter/material.dart';

class AppStateProvider with ChangeNotifier {
  // General app state variable to store the main state of the app
  String _stateData = "Initial State";

  // Getter for the general app state variable
  String get stateData => _stateData;

  // Method to update the general app state variable
  void updateStateData(String newData) {
    _stateData = newData;
    notifyListeners(); // Notify listeners to update the UI
  }

  // Map to hold dynamically registered plugin states
  final Map<String, ChangeNotifier> _pluginStates = {};

  // Add or update a plugin state in the provider
  void updatePluginState(String pluginName, ChangeNotifier state) {
    _pluginStates[pluginName] = state;
    notifyListeners(); // Notify listeners to update the UI
  }

  // Retrieve a specific plugin's state by plugin name
  T? getPluginState<T>(String pluginName) {
    return _pluginStates[pluginName] as T?;
  }

  // Check if a plugin state is already added
  bool hasPluginState(String pluginName) {
    return _pluginStates.containsKey(pluginName);
  }

  // Remove a plugin state from the provider if needed
  void removePluginState(String pluginName) {
    _pluginStates.remove(pluginName);
    notifyListeners(); // Notify listeners to update the UI
  }
}
