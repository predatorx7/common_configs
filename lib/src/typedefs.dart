import 'config.dart';

typedef ConfigCreationCallback<T extends Config> = T Function();
typedef ReturnDefaultValueCallback<T> = T? Function();
