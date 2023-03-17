import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:polygonid_flutter_sdk/proof/domain/repositories/proof_repository.dart';
import 'package:polygonid_flutter_sdk/proof/domain/use_cases/get_jwz_use_case.dart';
import 'package:polygonid_flutter_sdk/proof/domain/use_cases/is_proof_circuit_supported_use_case.dart';
import 'package:polygonid_flutter_sdk/proof/domain/use_cases/load_circuit_use_case.dart';

import '../../../common/common_mocks.dart';
import '../../../common/proof_mocks.dart';
import 'is_proof_circuit_supported_use_case_test.mocks.dart';

MockProofRepository proofRepository = MockProofRepository();
IsProofCircuitSupportedUseCase useCase =
    IsProofCircuitSupportedUseCase(proofRepository);

// Data
var param = CommonMocks.circuitId;
var invalidParam = "";

@GenerateMocks([ProofRepository])
void main() {
  setUp(() {
    reset(proofRepository);

    when(proofRepository.isCircuitSupported(circuitId: anyNamed("circuitId")))
        .thenAnswer((realInvocation) => Future.value(true));
  });

  test(
    'Given a valid param, when I call execute, then I expect true to be returned',
    () async {
      // When
      expect(await useCase.execute(param: param), true);

      // Then
      var capturedSupported = verify(proofRepository.isCircuitSupported(
              circuitId: captureAnyNamed("circuitId")))
          .captured
          .first;
      expect(capturedSupported, param);
    },
  );

  test(
    'Given an invalid param, when I call execute, then I expect false to be returned',
    () async {
      // When
      when(proofRepository.isCircuitSupported(circuitId: anyNamed("circuitId")))
          .thenAnswer((realInvocation) => Future.value(false));

      expect(await useCase.execute(param: invalidParam), false);

      // Then
      var capturedSupported = verify(proofRepository.isCircuitSupported(
              circuitId: captureAnyNamed("circuitId")))
          .captured
          .first;
      expect(capturedSupported, invalidParam);
    },
  );

  test(
    'Given a param, when I call execute and an error occurred, then I expect an exception to be thrown',
    () async {
      // Given
      when(proofRepository.isCircuitSupported(
              circuitId: captureAnyNamed("circuitId")))
          .thenAnswer((realInvocation) => Future.error(CommonMocks.exception));

      // When
      await useCase
          .execute(param: param)
          .then((value) => expect(true, false))
          .catchError((error) {
        expect(error, CommonMocks.exception);
      });

      // Then
      var capturedSupported = verify(proofRepository.isCircuitSupported(
              circuitId: captureAnyNamed("circuitId")))
          .captured
          .first;
      expect(capturedSupported, param);
    },
  );
}
