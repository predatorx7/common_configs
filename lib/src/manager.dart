import 'constants.dart';
import 'config.dart';
import 'store.dart';
import 'typedefs.dart';

abstract class ConfigsManager {
  const ConfigsManager();

  /// {@macro ConfigStore.add}
  Config setImmediately({
    String name = defaultConfigName,
    required Config config,
  });

  /// {@macro ConfigStore.addLazy}
  ///
  /// {@template ConfigsManager.put}
  /// By default, config is stored under the [name] `default`.
  /// {@endtemplate}
  void set({
    String name = defaultConfigName,
    required ConfigCreationCallback create,
  });

  /// {@macro ConfigStore.setIfAbsent}
  ///
  /// {@macro ConfigsManager.put}
  void setIfAbsent({
    String name = defaultConfigName,
    required ConfigCreationCallback create,
  });

  /// {@macro ConfigStore.get}
  ///
  /// {@macro ConfigsManager.put}
  Config get([String name = 'default']);

  /// {@template ConfigsManager.isA}
  /// Returns `true` if the [Config] stored in the [ConfigStore] under the given [name] has a matching [id] with its [Config.id].
  /// {@endtemplate}
  ///
  /// {@macro ConfigsManager.put}
  bool isA(
    Object id, [
    String name = defaultConfigName,
  ]);

  void dispose() {
    // Do nothing
  }
}

/// A manager of [Config]s which can be used to store and retrieve [Config] for a scope.
class InMemoryConfigsManager extends ConfigsManager {
  InMemoryConfigsManager();

  /// All [Config]s are stored by their name in this [ConfigStore].
  ConfigStore store = ConfigStore();

  @override
  Config setImmediately({
    String name = defaultConfigName,
    required Config config,
  }) {
    store.set(name, config);
    return config;
  }

  @override
  void set({
    String name = defaultConfigName,
    required ConfigCreationCallback create,
  }) {
    return store.setLazy(name, create);
  }

  @override
  void setIfAbsent({
    String name = defaultConfigName,
    required ConfigCreationCallback create,
  }) {
    return store.setIfAbsent(name, create);
  }

  @override
  Config get([String name = 'default']) {
    final config = store.get(name);
    assert(
      config != null,
      'Config for "$name" was never created. Provide a config before usage.',
    );
    return config!;
  }

  @override
  bool isA(
    Object id, [
    String name = defaultConfigName,
  ]) {
    return store.get(name)?.id == id;
  }

  /// Disposes the stored [Config]s and clears the [ConfigStore].
  @override
  void dispose() {
    store.dispose();
  }
}
