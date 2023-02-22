import '../../../common/domain/domain_logger.dart';
import '../../../common/domain/entities/filter_entity.dart';
import '../../../common/domain/use_case.dart';
import '../entities/claim_entity.dart';
import '../repositories/credential_repository.dart';

class FetchVocabParam {
  final Map<String, dynamic> schema;
  final String type;

  FetchVocabParam({
    required this.schema,
    required this.type,
  });
}

class FetchVocabUseCase
    extends FutureUseCase<FetchVocabParam, Map<String, dynamic>> {
  final CredentialRepository _credentialRepository;

  FetchVocabUseCase(this._credentialRepository);

  @override
  Future<Map<String, dynamic>> execute({required FetchVocabParam param}) async {
    return _credentialRepository
        .fetchVocab(schema: param.schema, type: param.type)
        .then((vocab) {
      logger().i("[FetchVocabUseCase] vocab: $vocab");
      return vocab;
    }).catchError((error) {
      logger().e("[FetchVocabUseCase] Error: $error");
      throw error;
    });
  }
}