import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:polygonid_flutter_sdk/identity/domain/entities/tree_type.dart';
import 'package:polygonid_flutter_sdk/identity/domain/repositories/identity_repository.dart';
import 'package:polygonid_flutter_sdk/identity/domain/repositories/smt_repository.dart';
import 'package:polygonid_flutter_sdk/identity/domain/use_cases/get_identity_auth_claim_use_case.dart';
import 'package:polygonid_flutter_sdk/identity/domain/use_cases/get_latest_state_use_case.dart';
import 'package:polygonid_flutter_sdk/identity/domain/use_cases/smt/create_identity_state_use_case.dart';
import 'package:polygonid_flutter_sdk/identity/domain/use_cases/smt/remove_identity_state_use_case.dart';

import '../../../../common/common_mocks.dart';
import '../../../../common/identity_mocks.dart';
import 'remove_identity_state_use_case_test.mocks.dart';

MockSMTRepository smtRepository = MockSMTRepository();

RemoveIdentityStateUseCase useCase = RemoveIdentityStateUseCase(
  smtRepository,
);

// Data
RemoveIdentityStateParam param = RemoveIdentityStateParam(
  did: CommonMocks.did,
  privateKey: CommonMocks.privateKey,
);

@GenerateMocks([
  SMTRepository,
])
void main() {
  group(
    "Remove identity state",
    () {
      setUp(() {
        // Given
        reset(smtRepository);

        when(smtRepository.removeSMT(
                type: anyNamed('type'),
                did: anyNamed('did'),
                privateKey: anyNamed('privateKey')))
            .thenAnswer((realInvocation) => Future.value());
      });

      test(
        'Given a param, when I call execute, then I expect to complete executing',
        () async {
          // When
          await expectLater(useCase.execute(param: param), completes);

          // Then
          var verifyRemoveSMT = verify(smtRepository.removeSMT(
              type: captureAnyNamed('type'),
              did: captureAnyNamed('did'),
              privateKey: captureAnyNamed('privateKey')));
          expect(verifyRemoveSMT.callCount, 3);
          expect(verifyRemoveSMT.captured[0], TreeType.claims);
          expect(verifyRemoveSMT.captured[1], CommonMocks.did);
          expect(verifyRemoveSMT.captured[2], CommonMocks.privateKey);
          expect(verifyRemoveSMT.captured[3], TreeType.revocation);
          expect(verifyRemoveSMT.captured[4], CommonMocks.did);
          expect(verifyRemoveSMT.captured[5], CommonMocks.privateKey);
          expect(verifyRemoveSMT.captured[6], TreeType.roots);
          expect(verifyRemoveSMT.captured[7], CommonMocks.did);
          expect(verifyRemoveSMT.captured[8], CommonMocks.privateKey);
        },
      );

      test(
        'Given a param, when I call execute and an error occurred, then I expect an exception to be thrown',
        () async {
          // Given
          when(smtRepository.removeSMT(
                  type: anyNamed('type'),
                  did: anyNamed('did'),
                  privateKey: anyNamed('privateKey')))
              .thenAnswer(
                  (realInvocation) => Future.error(CommonMocks.exception));

          // When
          await expectLater(
              useCase.execute(param: param), throwsA(CommonMocks.exception));

          // Then
          var verifyRemoveSMT = verify(smtRepository.removeSMT(
              type: captureAnyNamed('type'),
              did: captureAnyNamed('did'),
              privateKey: captureAnyNamed('privateKey')));
          expect(verifyRemoveSMT.callCount, 3);
          expect(verifyRemoveSMT.captured[0], TreeType.claims);
          expect(verifyRemoveSMT.captured[1], CommonMocks.did);
          expect(verifyRemoveSMT.captured[2], CommonMocks.privateKey);
          expect(verifyRemoveSMT.captured[3], TreeType.revocation);
          expect(verifyRemoveSMT.captured[4], CommonMocks.did);
          expect(verifyRemoveSMT.captured[5], CommonMocks.privateKey);
          expect(verifyRemoveSMT.captured[6], TreeType.roots);
          expect(verifyRemoveSMT.captured[7], CommonMocks.did);
          expect(verifyRemoveSMT.captured[8], CommonMocks.privateKey);
        },
      );
    },
  );
}
