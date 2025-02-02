import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:polygonid_flutter_sdk/credential/domain/repositories/credential_repository.dart';
import 'package:polygonid_flutter_sdk/credential/domain/use_cases/remove_all_claims_use_case.dart';
import 'package:polygonid_flutter_sdk/credential/domain/use_cases/remove_claims_use_case.dart';

import 'remove_all_claims_use_case_test.mocks.dart';

// Data
const identifier = "theIdentifier";
const privateKey = "thePrivateKey";
const ids = ["theId", "theId1", "theId2"];
final param = RemoveAllClaimsParam(did: identifier, privateKey: privateKey);
final exception = Exception();

// Dependencies
MockCredentialRepository credentialRepository = MockCredentialRepository();

// Tested instance
RemoveAllClaimsUseCase useCase = RemoveAllClaimsUseCase(credentialRepository);

@GenerateMocks([CredentialRepository])
void main() {
  group("Remove all claims", () {
    setUp(() {
      reset(credentialRepository);

      // Given
      when(credentialRepository.removeAllClaims(
              genesisDid: identifier, privateKey: privateKey))
          .thenAnswer((realInvocation) => Future.value());
    });

    test("When I call execute, then I expect the process to complete",
        () async {
      // When
      await expectLater(useCase.execute(param: param), completes);

      // Then
      var capturedRemove = verify(credentialRepository.removeAllClaims(
              genesisDid: captureAnyNamed('genesisDid'),
              privateKey: captureAnyNamed('privateKey')))
          .captured;
      expect(capturedRemove[0], identifier);
      expect(capturedRemove[1], privateKey);
    });

    test(
        "When I call execute and an error occurred, then I expect an exception to be thrown",
        () async {
      // Given
      when(credentialRepository.removeAllClaims(
              genesisDid: identifier, privateKey: privateKey))
          .thenAnswer((realInvocation) => Future.error(exception));

      // When
      await expectLater(useCase.execute(param: param), throwsA(exception));

      // Then
      var capturedRemove = verify(credentialRepository.removeAllClaims(
              genesisDid: captureAnyNamed('genesisDid'),
              privateKey: captureAnyNamed('privateKey')))
          .captured;
      expect(capturedRemove[0], identifier);
      expect(capturedRemove[1], privateKey);
    });
  });
}
