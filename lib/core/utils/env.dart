import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(
    varName: 'BASE_URL',
    defaultValue: 'http://localhost:8080/v4/',
    obfuscate: true,
  )
  static final String apiBaseUrl = _Env.apiBaseUrl;
}
