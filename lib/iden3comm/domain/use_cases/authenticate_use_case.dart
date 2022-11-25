import 'package:polygonid_flutter_sdk/common/domain/domain_logger.dart';
import 'package:polygonid_flutter_sdk/common/domain/use_case.dart';
import 'package:polygonid_flutter_sdk/common/domain/use_cases/get_package_name_use_case.dart';

import '../../../common/domain/use_cases/get_config_use_case.dart';
import '../../../identity/domain/use_cases/get_did_identifier_use_case.dart';
import '../entities/proof_entity.dart';
import '../entities/request/auth/auth_iden3_message_entity.dart';
import '../repositories/iden3comm_repository.dart';
import 'get_auth_token_use_case.dart';
import 'get_proofs_use_case.dart';

class AuthenticateParam {
  final AuthIden3MessageEntity message;
  final String identifier;
  final String privateKey;
  final String? pushToken;

  AuthenticateParam(
      {required this.message,
      required this.identifier,
      required this.privateKey,
      this.pushToken});
}

class AuthenticateUseCase extends FutureUseCase<AuthenticateParam, void> {
  final Iden3commRepository _iden3commRepository;
  final GetAuthTokenUseCase _getAuthTokenUseCase;
  final GetProofsUseCase _getProofsUseCase;
  final GetEnvConfigUseCase _getEnvConfigUseCase;
  final GetPackageNameUseCase _getPackageNameUseCase;
  final GetDidIdentifierUseCase _getDidIdentifierUseCase;

  AuthenticateUseCase(
    this._iden3commRepository,
    this._getProofsUseCase,
    this._getAuthTokenUseCase,
    this._getEnvConfigUseCase,
    this._getPackageNameUseCase,
    this._getDidIdentifierUseCase,
  );

  @override
  Future<void> execute({required AuthenticateParam param}) async {
    try {
      List<ProofEntity> proofs = await _getProofsUseCase.execute(
          param: GetProofsParam(
        message: param.message,
        identifier: param.identifier,
        privateKey: param.privateKey,
      ));

      String pushUrl =
          await _getEnvConfigUseCase.execute(param: PolygonIdConfig.pushUrl);
      String networkName = await _getEnvConfigUseCase.execute(
          param: PolygonIdConfig.networkName);
      String networkEnv =
          await _getEnvConfigUseCase.execute(param: PolygonIdConfig.networkEnv);

      String didIdentifier = await _getDidIdentifierUseCase.execute(
        param: GetDidIdentifierParam(
          identifier: param.identifier,
          networkName: networkName,
          networkEnv: networkEnv,
        ),
      );

      String packageName = await _getPackageNameUseCase.execute();

      String authResponse = await _iden3commRepository.getAuthResponse(
          identifier: param.identifier,
          request: param.message,
          scope: proofs,
          pushUrl: pushUrl,
          pushToken: param.pushToken,
          didIdentifier: didIdentifier,
          packageName: packageName);

      String authToken = await _getAuthTokenUseCase.execute(
          param: GetAuthTokenParam(
              param.identifier, param.privateKey, authResponse));

      return _iden3commRepository.authenticate(
        request: param.message,
        authToken: authToken,
      );
    } catch (error) {
      logger().e("[AuthenticateUseCase] Error: $error");

      rethrow;
    }
  }
}
