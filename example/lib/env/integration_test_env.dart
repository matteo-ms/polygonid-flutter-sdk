import 'package:envied/envied.dart';

part 'integration_test_env.g.dart';

@Envied(name: 'IntegrationTestEnv', path: '.env.integrationtest')
class IntegrationTestEnv {
  IntegrationTestEnv();

  @EnviedField(varName: 'SELFHOSTED_PLATFORM_USERNAME', obfuscate: true)
  static String selfHostedPlatformUsername =
      _IntegrationTestEnv.selfHostedPlatformUsername;

  @EnviedField(varName: 'SELFHOSTED_PLATFORM_PASSWORD', obfuscate: true)
  static String selfHostedPlatformPassword =
      _IntegrationTestEnv.selfHostedPlatformPassword;

  @EnviedField(varName: 'SELFHOSTED_PLATFORM_ISSUER_DID', obfuscate: true)
  static String selfHostedPlatformIssuerDid =
      _IntegrationTestEnv.selfHostedPlatformIssuerDid;
}
