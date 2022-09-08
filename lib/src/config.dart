import 'manager.dart';
import 'typedefs.dart';
import 'store.dart';

/// A representation of a configuration that can be identified by an [id].
///
/// This configuration is stored in a [ConfigStore] and can be retrieved by a `name`.
abstract class Config<T extends Object> {
  const Config();

  /// Creates a configuration from a map that can be identified by an [id].
  const factory Config.fromMap(
    T id,
    Map<String, dynamic> data,
  ) = MapConfig<T>;

  /// The unique identifier of this [Config].
  T get id;

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Config && id == other.id;
  }

  /// All configs are managed by a [ConfigsManager]. It uses a [ConfigStore] to store and retrieve configs by a name.
  static ConfigsManager manager = InMemoryConfigsManager();

  /// {@macro ConfigStore.add}
  ///
  /// {@macro ConfigsManager.put}
  static Config putImmediately({
    String name = 'default',
    required Config config,
  }) {
    return manager.setImmediately(
      name: name,
      config: config,
    );
  }

  /// {@macro ConfigStore.addLazy}
  ///
  /// {@macro ConfigsManager.put}
  static void put({
    String name = 'default',
    required ConfigCreationCallback create,
  }) {
    return manager.set(
      name: name,
      create: create,
    );
  }

  /// {@macro ConfigStore.setIfAbsent}
  ///
  /// {@macro ConfigsManager.put}
  static void setIfAbsent({
    String name = 'default',
    required ConfigCreationCallback create,
  }) {
    return manager.setIfAbsent(
      name: name,
      create: create,
    );
  }

  /// {@macro ConfigStore.get}
  ///
  /// {@macro ConfigsManager.put}
  static Config get([String name = 'default']) {
    return manager.get(name);
  }

  /// {@macro ConfigsManager.isA}
  ///
  /// {@macro ConfigsManager.put}
  static bool isA(
    Object id, [
    String name = 'default',
  ]) {
    return manager.isA(id, name);
  }

  /// Returns a [ConfigProvider] which manages the [Config] only under one [name] and
  /// optionally by type of Config [T] & id of config [O].
  static ConfigProvider<O, T> by<O extends Object, T extends Config<O>>(
    String name, [
    ConfigsManager? manager,
  ]) {
    return ConfigProvider<O, T>(
      name,
      manager ?? Config.manager,
    );
  }

  void dispose() {}
}

/// A [ConfigProvider] which manages [Config] only under one [name] and
/// optionally by type of Config [T] & id of config [O].
///
/// This is a convenience class to make it easier to manage [Config]s and does not
/// enforce type on a stored config by the [name].
class ConfigProvider<O extends Object, T extends Config<O>> {
  /// The name for storing a [Config].
  final String name;

  /// All configs are managed by a [ConfigsManager]. It uses a [ConfigStore] to store and retrieve configs by a name.
  final ConfigsManager manager;

  const ConfigProvider(
    this.name,
    this.manager,
  );

  /// {@macro ConfigStore.get}
  T get() {
    final data = manager.get(name);
    assert(
      data is T,
      'Config with name "$name" is not of type $T but of type ${data.runtimeType}',
    );
    return data as T;
  }

  /// {@macro ConfigStore.addLazy}
  void set(ConfigCreationCallback<T> create) {
    return manager.set(
      name: name,
      create: create,
    );
  }

  /// {@macro ConfigStore.setIfAbsent}
  void setIfAbsent(ConfigCreationCallback<T> create) {
    return manager.setIfAbsent(
      name: name,
      create: create,
    );
  }

  /// {@macro ConfigStore.add}
  T setImmediately(T value) {
    return manager.setImmediately(
      name: name,
      config: value,
    ) as T;
  }

  /// {@macro ConfigsManager.isA}
  bool isA(O id) {
    return manager.isA(id, name);
  }
}

/// A configuration that that has data as a [Map].
class MapConfig<O extends Object> extends Config<O> {
  @override
  final O id;
  final Map<String, dynamic> data;

  const MapConfig(
    this.id,
    this.data,
  );

  /// Returns the value of the given [key] in the [data] map.
  ///
  /// This tries to cast or parse the value to the given [T] type. If it fails, then value from [defaultValue] is returned if [defaultValue] callback is provided.
  T? get<T>(
    String key, [
    ReturnDefaultValueCallback<T>? defaultValue,
  ]) {
    final val = data[key];
    if (val == null) return null;
    if (val is T) return val;

    if (T == String) {
      return val.toString() as T?;
    } else if (T == num) {
      if (val is num) return val as T?;
      return num.tryParse(val.toString()) as T?;
    } else if (T == int) {
      if (val is int) return val as T?;
      return int.tryParse(val.toString()) as T?;
    } else if (T == double) {
      if (val is double) return val as T?;
      return double.tryParse(val.toString()) as T?;
    }
    return defaultValue?.call();
  }
}
