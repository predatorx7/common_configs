// ignore_for_file: unused_local_variable

import 'package:common_configs/common_configs.dart';

/// Create your own config by extending [Config].
class Awesome extends Config {
  Awesome(this.id);
  @override
  final AwesomeType id;
}

/// Optionally use an enum as an identifier to differentiate between different [Config]s.
enum AwesomeType {
  good,
  better,
  best,
}

Awesome createGoodConfig() => Awesome(AwesomeType.good);
Awesome createBetterConfig() => Awesome(AwesomeType.better);
Awesome createBestConfig() => Awesome(AwesomeType.best);

class AwesomeMapConfig extends MapConfig<AwesomeType> {
  AwesomeMapConfig(super.id, super.data);
}

AwesomeMapConfig createMapConfig() => AwesomeMapConfig(
      AwesomeType.better,
      {'Hello': 'World'},
    );

void main() {
  print('== `default` config ==');

  /// Set your config with [Config.put].
  ///
  /// Example use case: Your different entrypoints can use different configs.
  Config.put(create: createGoodConfig);

  /// With [isA] method, you can check the current config.
  print('is good: ${Config.isA(AwesomeType.good)}');
  print('is better: ${Config.isA(AwesomeType.better)}');
  print('is best: ${Config.isA(AwesomeType.best)}');

  /// You can also use different names for getting or storing a config.
  const someOtherScopeName = 'awesome.map';

  print('== `$someOtherScopeName` config ==');

  Config.put(create: createMapConfig, name: someOtherScopeName);

  print('is good: ${Config.isA(AwesomeType.good, someOtherScopeName)}');
  print('is better: ${Config.isA(AwesomeType.better, someOtherScopeName)}');
  print('is best: ${Config.isA(AwesomeType.best, someOtherScopeName)}');

  /// If you want a more convenient way to manage config only by a name try using [Config.by].
  final useItLikeConfig = Config.by(someOtherScopeName);

  useItLikeConfig.get();
  useItLikeConfig.set(createMapConfig);
  useItLikeConfig.setIfAbsent(createMapConfig);
  useItLikeConfig.isA(AwesomeType.best);
  useItLikeConfig.setImmediately(createMapConfig());

  /// You can optionally provide types to it.
  Config.by<AwesomeType, AwesomeMapConfig>(someOtherScopeName);
}
