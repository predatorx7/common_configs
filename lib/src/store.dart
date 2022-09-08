import 'config.dart';
import 'typedefs.dart';

/// An in-memory store of [Config]s. Every config is stored by a name.
class ConfigStore {
  /// Map of config names to configs.
  final Map<String, Config> configs = {};

  /// Map of config names to config creation callbacks.
  /// This will be used to create a config later as part of the lazy creation process.
  final Map<String, ConfigCreationCallback> _configCreationCallbacks = {};

  /// {@template ConfigStore.get}
  /// Returns a config by its [name].
  /// {@endtemplate}
  Config? get(String name) {
    final o = configs[name];
    if (o != null) return o;
    final f = _configCreationCallbacks[name];
    if (f == null) return null;
    final d = set(name, f());
    _configCreationCallbacks.remove(name);
    return d;
  }

  /// {@template ConfigStore.add}
  /// Immediately adds a [config] to the store by its [name].
  ///
  /// This will override any existing config with the same name. To only put if absent, use `setIfAbsent`.
  /// {@endtemplate}
  Config set(String name, Config config) {
    return configs[name] = config;
  }

  /// {@template ConfigStore.addLazy}
  /// Lazily adds a [Config] to the store by its [name]. The config will be created when it is first requested by the [get] method.
  ///
  /// This will override any existing config with the same name. To only put if absent, use `setIfAbsent`.
  /// {@endtemplate}
  void setLazy(String name, ConfigCreationCallback create) {
    _configCreationCallbacks[name] = create;
  }

  /// {@template ConfigStore.setIfAbsent}
  /// Adds a [Config] to the store by its [name] if it does not already exist.
  /// {@endtemplate}
  void setIfAbsent(
    String name,
    ConfigCreationCallback create,
  ) {
    if (configs.containsKey(name) ||
        _configCreationCallbacks.containsKey(name)) {
      return;
    }
    setLazy(name, create);
  }

  /// Remove a [Config] by its name from this store.
  void remove(String name) {
    configs.remove(name)?.dispose();
  }

  /// Dispose and remove all [Config]s from this store.
  void dispose() {
    for (final config in configs.values) {
      config.dispose();
    }
    configs.clear();
    _configCreationCallbacks.clear();
  }
}
