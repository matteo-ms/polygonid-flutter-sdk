import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:polygonid_flutter_sdk/proof/domain/repositories/proof_repository.dart';
import 'package:polygonid_flutter_sdk/proof/domain/use_cases/get_jwz_use_case.dart';
import 'package:polygonid_flutter_sdk/proof/domain/use_cases/load_circuit_use_case.dart';

import '../../../common/common_mocks.dart';
import '../../../common/proof_mocks.dart';
import 'load_circuit_use_case_test.mocks.dart';

MockProofRepository proofRepository = MockProofRepository();
LoadCircuitUseCase useCase = LoadCircuitUseCase(proofRepository);

// Data
var param = CommonMocks.circuitId;

@GenerateMocks([ProofRepository])
void main() {
  setUp(() {
    when(proofRepository.loadCircuitFiles(any))
        .thenAnswer((realInvocation) => Future.value(ProofMocks.circuitData));
  });

  test(
    'Given a param, when I call execute, then I expect a CircuitDataEntity to be returned',
    () async {
      // When
      expect(await useCase.execute(param: param), ProofMocks.circuitData);

      // Then
      var capturedLoad =
          verify(proofRepository.loadCircuitFiles(captureAny)).captured.first;
      expect(capturedLoad, CommonMocks.circuitId);
    },
  );

  test(
    'Given a param, when I call execute and an error occurred, then I expect an exception to be thrown',
    () async {
      // Given
      when(proofRepository.loadCircuitFiles(any))
          .thenAnswer((realInvocation) => Future.error(CommonMocks.exception));

      // When
      await useCase
          .execute(param: param)
          .then((value) => expect(true, false))
          .catchError((error) {
        expect(error, CommonMocks.exception);
      });

      // Then
      var capturedLoad =
          verify(proofRepository.loadCircuitFiles(captureAny)).captured.first;
      expect(capturedLoad, CommonMocks.circuitId);
    },
  );
}
