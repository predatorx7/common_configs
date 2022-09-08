import 'manager.dart';
import 'typedefs.dart';
import 'store.dart';

/// A representation of a configuration that can be identified by an [id].
///
/// This configuration is stored in a [ConfigStore] and can be retrieved by a `name`.
abstract class Config {
  const Config();

  /// Creates a configuration from a map that can be identified by an [id].
  const factory Config.fromMap(
    Object id,
    Map<String, dynamic> data,
  ) = MapConfig;

  /// The unique identifier of this [Config].
  Object get id;

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
    return manager.putImmediately(
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
    return manager.put(
      name: name,
      create: create,
    );
  }

  /// {@macro ConfigStore.putIfAbsent}
  ///
  /// {@macro ConfigsManager.put}
  static void putIfAbsent({
    String name = 'default',
    required ConfigCreationCallback create,
  }) {
    return manager.putIfAbsent(
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

  void dispose() {}
}

/// A configuration that that has data as a [Map].
class MapConfig<O extends Object> extends Config {
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
