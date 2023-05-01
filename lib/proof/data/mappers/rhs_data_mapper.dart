import 'package:polygonid_flutter_sdk/common/mappers/to_mapper.dart';
import 'package:polygonid_flutter_sdk/proof/domain/entities/rhs_data_entity.dart';

class RhsDataMapper extends ToMapper<Map<String, dynamic>, RhsDataEntity> {
  @override
  Map<String, dynamic> mapTo(RhsDataEntity to) {
    Map<String, dynamic> result = {
      "ethereumUrl": to.ethereumUrl,
      "stateContractAddr": to.stateContractAddr,
      "reverseHashServiceUrl": to.reverseHashServiceUrl,
    };
    return result;
  }
}
