# Common configs

A simple package which can be used as a global config in your app or you can share configs with your packages.

## Features

- Use as a global configs across your app.
- Share configs with packages.
- Access config from anywhere.
- Load configs from a Map with [Config.fromMap].

## Getting started

Add this package as a dependency

```bash
dart pub add common_configs
```

and import in your file by adding the below statement

```dart
import 'package:common_configs/common_configs.dart';
```

## Usage

A short example.

Use anything to use as an identifier for your config's type. In this example,
I'm using an enum ConfigType.

```dart
enum ConfigType {
  devel,
  staging,
  prod,
}
```

We'll use a pre-existing MapConfig which uses `Map<String, dynamic>` as a
Config with an identifier.

```dart
Config createDevelConfig() => MapConfig(ConfigType.devel, { 'hello': 'world' });
```

To create your own config, start by extending the [Config].

To use this config, set it by using [Config.put].

```dart
Config.put(create: createDevelConfig);
```

By default, configs are stored by the name `default`.

To use a another name, you can use the name parameter when getting or setting a
config.

```dart
Config.put(create: createDevelConfig, name: 'app.config');
```

## Additional information

You can write your own code to obtain configuration details from a source like a
json, or .env file.

For a longer example, check out the `/example` folder.
