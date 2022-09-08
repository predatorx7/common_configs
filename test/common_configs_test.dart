import 'package:common_configs/common_configs.dart';
import 'package:test/test.dart';

class MyConfig extends Config {
  MyConfig(this.id);
  @override
  final Object id;
}

void main() {
  group('A group of tests', () {
    test('config should be initially null', () {
      expect(Config.isA('hello'), isFalse);
      Config.put(
        create: () {
          return MyConfig('hello');
        },
      );
      expect(Config.get(), isA<MyConfig>());
      expect(Config.isA('hello'), isTrue);
      expect(Config.isA('hellox'), isFalse);
    });
  });
}
