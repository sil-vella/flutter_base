# State and Plugin Management in Flutter Application

## Overview

This document explains how `AppState` and `PluginState` are managed in a Flutter application using a
centralized `AppStateProvider` and dynamic `PluginManager`.

## AppStateProvider

The `AppStateProvider` serves as the main provider that manages both the general application state
and the states of individual plugins. It uses the `ChangeNotifier` class to notify listeners
whenever state changes occur.

### General App State:

- **State Variable**: `_stateData` (a simple string representing the app’s overall state).
- **Getter and Setter**: `get stateData` and `updateStateData()` to access and update this state
  respectively.
- **Purpose**: Provides a central place to manage global states that can affect the entire app (
  e.g., whether the app is loading, in a logged-in state, etc.).

### Plugin States:

- **State Map**: `_pluginStates` is a map that holds different plugin states, with each state being
  a `ChangeNotifier`. Each plugin’s state is stored by its name (e.g., `'MainPlugin'`).
- **Add/Update State**: `updatePluginState()` method is used to either add or update a plugin's
  state.
- **Retrieve State**: `getPluginState<T>()` retrieves a specific plugin’s state by the plugin’s
  name. The state type is dynamically cast to the specified type `<T>`, providing type safety.

### Summary:

The `AppStateProvider` acts as a central state management solution for both general app state and
individual plugin states, notifying listeners of any changes via `ChangeNotifier`.

## PluginManager

The `PluginManager` handles the creation and lifecycle management of plugins in the application. It
interacts with `AppStateProvider` and `PluginRegistry` to manage the state and configuration of
individual plugins.

### Key Responsibilities:

- **Plugin Constructors**: `registerPluginConstructor` registers a constructor function for each
  plugin, which can be dynamically invoked to create plugins.
- **Initialization**:
    - `initializePlugins()` reads the configuration (`PluginConfig`) and only initializes plugins
      that are enabled and marked to initialize at startup.
    - During initialization, `createPlugin()` is called to instantiate the plugin using the
      registered constructor.
    - The plugin is then registered with `PluginRegistry` and initialized.
- **Collect Routes**: `collectAllRoutes()` collects all routes from registered plugins and provides
  them to be used in the `MaterialApp`.
- **Disposal**: `disposeAllPlugins()` ensures that all plugins are properly disposed of when they
  are no longer needed.

## PluginRegistry

The `PluginRegistry` keeps track of all registered plugins and their associated navigation hooks. It
provides methods for:

- **Plugin Registration**: Adds plugins to the internal `_registeredPlugins` map.
- **Hook Registration**: Registers navigation hooks that allow plugins to contribute their own
  navigation items.
- **Navigation Management**: Executes all registered navigation hooks and collects the navigation
  items from each plugin.
- **Retrieve Plugins**: Provides access to all registered plugins.

## PluginConfig and PluginInfo

- **PluginConfig** is responsible for loading the configuration JSON file and parsing it into a list
  of `PluginInfo` objects.
- **PluginInfo** represents the configuration of each individual plugin (including its `slug`,
  whether it is `enabled`, and whether it should be `initAtStartup`).

## How it All Ties Together:

1. **App Initialization**:
    - The app starts by loading the `PluginConfig` JSON file using `PluginConfig.loadConfig()`.
    - `PluginManager` is initialized with the central `AppStateProvider`.
    - Each plugin’s constructor is registered with `PluginManager`.

2. **Plugin Initialization**:
    - `PluginManager.initializePlugins()` uses the configuration file to determine which plugins
      should be created and initialized.
    - The appropriate plugin is created using `createPlugin()` and registered in `PluginRegistry`.

3. **Plugin State Management**:
    - Each plugin can define and manage its own state. When a plugin is created, it registers its
      state with `AppStateProvider` using `updatePluginState()`.
    - Any component can use `getPluginState()` from `AppStateProvider` to access a plugin’s state by
      name.
    - Changes to the state trigger `notifyListeners()`, ensuring that the UI updates accordingly.

4. **Navigation and Routes**:
    - Each plugin can define its routes and navigation items. During plugin initialization, these
      routes are registered via `PluginRegistry`.
    - When the app runs, all routes are collected using `collectAllRoutes()` and provided to
      the `MaterialApp`.

## Benefits of this Approach

- **Centralized State Management**: `AppStateProvider` acts as a single source of truth for both the
  app's general state and plugin-specific states, ensuring consistency and ease of access across the
  entire app.
- **Modular Architecture**: Each plugin self-registers and manages its own state, making the
  architecture scalable and easier to maintain.
- **Dynamic Plugin Loading**: Plugins are created and initialized dynamically based on
  configuration, enabling or disabling plugins without hardcoding.

This setup efficiently manages state and plugin initialization while maintaining flexibility through
dynamic configuration.
