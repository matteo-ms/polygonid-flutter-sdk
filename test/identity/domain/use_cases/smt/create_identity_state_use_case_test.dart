import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:polygonid_flutter_sdk/identity/domain/entities/tree_type.dart';
import 'package:polygonid_flutter_sdk/identity/domain/repositories/identity_repository.dart';
import 'package:polygonid_flutter_sdk/identity/domain/repositories/smt_repository.dart';
import 'package:polygonid_flutter_sdk/identity/domain/use_cases/get_identity_auth_claim_use_case.dart';
import 'package:polygonid_flutter_sdk/identity/domain/use_cases/get_latest_state_use_case.dart';
import 'package:polygonid_flutter_sdk/identity/domain/use_cases/smt/create_identity_state_use_case.dart';

import '../../../../common/common_mocks.dart';
import '../../../../common/identity_mocks.dart';
import 'create_identity_state_use_case_test.mocks.dart';

MockIdentityRepository identityRepository = MockIdentityRepository();
MockSMTRepository smtRepository = MockSMTRepository();
MockGetIdentityAuthClaimUseCase getIdentityAuthClaimUseCase =
    MockGetIdentityAuthClaimUseCase();

CreateIdentityStateUseCase useCase = CreateIdentityStateUseCase(
    identityRepository, smtRepository, getIdentityAuthClaimUseCase);

// Data
CreateIdentityStateParam param = CreateIdentityStateParam(
  did: CommonMocks.did,
  privateKey: CommonMocks.privateKey,
);

@GenerateMocks([
  IdentityRepository,
  SMTRepository,
  GetIdentityAuthClaimUseCase,
])
void main() {
  group(
    "Create identity state",
    () {
      setUp(() {
        // Given
        reset(identityRepository);
        reset(smtRepository);
        reset(getIdentityAuthClaimUseCase);

        when(identityRepository.getAuthClaimNode(
                children: anyNamed('children')))
            .thenAnswer((realInvocation) => Future.value(IdentityMocks.node));

        when(smtRepository.createSMT(
                maxLevels: anyNamed('maxLevels'),
                type: anyNamed('type'),
                did: anyNamed('did'),
                privateKey: anyNamed('privateKey')))
            .thenAnswer((realInvocation) => Future.value());

        when(smtRepository.addLeaf(
                leaf: anyNamed('leaf'),
                type: anyNamed('type'),
                did: anyNamed('did'),
                privateKey: anyNamed('privateKey')))
            .thenAnswer((realInvocation) => Future.value());

        when(getIdentityAuthClaimUseCase.execute(param: anyNamed('param')))
            .thenAnswer((realInvocation) =>
                Future.value(IdentityMocks.identityAuthClaim));
      });

      test(
        'Given a param, when I call execute, then I expect to complete successfully',
        () async {
          // When
          await expectLater(useCase.execute(param: param), completes);

          // Then
          var verifyCreateSMT = verify(smtRepository.createSMT(
              maxLevels: captureAnyNamed('maxLevels'),
              type: captureAnyNamed('type'),
              did: captureAnyNamed('did'),
              privateKey: captureAnyNamed('privateKey')));
          expect(verifyCreateSMT.callCount, 3);
          expect(verifyCreateSMT.captured[0], CommonMocks.maxLevels);
          expect(verifyCreateSMT.captured[1], TreeType.claims);
          expect(verifyCreateSMT.captured[2], CommonMocks.did);
          expect(verifyCreateSMT.captured[3], CommonMocks.privateKey);
          expect(verifyCreateSMT.captured[4], CommonMocks.maxLevels);
          expect(verifyCreateSMT.captured[5], TreeType.revocation);
          expect(verifyCreateSMT.captured[6], CommonMocks.did);
          expect(verifyCreateSMT.captured[7], CommonMocks.privateKey);
          expect(verifyCreateSMT.captured[8], CommonMocks.maxLevels);
          expect(verifyCreateSMT.captured[9], TreeType.roots);
          expect(verifyCreateSMT.captured[10], CommonMocks.did);
          expect(verifyCreateSMT.captured[11], CommonMocks.privateKey);

          var verifyIdentityAuthClaim = verify(getIdentityAuthClaimUseCase
              .execute(param: captureAnyNamed('param')));
          expect(verifyIdentityAuthClaim.callCount, 1);
          expect(verifyIdentityAuthClaim.captured[0], CommonMocks.privateKey);

          var verifyAuthClaimNode = verify(identityRepository.getAuthClaimNode(
              children: captureAnyNamed('children')));
          expect(verifyAuthClaimNode.callCount, 1);
          expect(
              verifyAuthClaimNode.captured[0], IdentityMocks.identityAuthClaim);

          var verifyAddLeaf = verify(smtRepository.addLeaf(
              leaf: captureAnyNamed('leaf'),
              type: captureAnyNamed('type'),
              did: captureAnyNamed('did'),
              privateKey: captureAnyNamed('privateKey')));
          expect(verifyAddLeaf.callCount, 1);
          expect(verifyAddLeaf.captured[0], IdentityMocks.node);
          expect(verifyAddLeaf.captured[1], TreeType.claims);
          expect(verifyAddLeaf.captured[2], CommonMocks.did);
          expect(verifyAddLeaf.captured[3], CommonMocks.privateKey);
        },
      );

      test(
        'Given a param, when I call execute and an error occurred, then I expect an exception to be thrown',
        () async {
          // Given
          when(smtRepository.createSMT(
                  maxLevels: anyNamed('maxLevels'),
                  type: anyNamed('type'),
                  did: anyNamed('did'),
                  privateKey: anyNamed('privateKey')))
              .thenAnswer(
                  (realInvocation) => Future.error(CommonMocks.exception));

          // When
          await expectLater(
              useCase.execute(param: param), throwsA(CommonMocks.exception));

          // Then
          var verifyCreateSMT = verify(smtRepository.createSMT(
              maxLevels: captureAnyNamed('maxLevels'),
              type: captureAnyNamed('type'),
              did: captureAnyNamed('did'),
              privateKey: captureAnyNamed('privateKey')));
          expect(verifyCreateSMT.callCount, 3);
          expect(verifyCreateSMT.captured[0], CommonMocks.maxLevels);
          expect(verifyCreateSMT.captured[1], TreeType.claims);
          expect(verifyCreateSMT.captured[2], CommonMocks.did);
          expect(verifyCreateSMT.captured[3], CommonMocks.privateKey);
          expect(verifyCreateSMT.captured[4], CommonMocks.maxLevels);
          expect(verifyCreateSMT.captured[5], TreeType.revocation);
          expect(verifyCreateSMT.captured[6], CommonMocks.did);
          expect(verifyCreateSMT.captured[7], CommonMocks.privateKey);
          expect(verifyCreateSMT.captured[8], CommonMocks.maxLevels);
          expect(verifyCreateSMT.captured[9], TreeType.roots);
          expect(verifyCreateSMT.captured[10], CommonMocks.did);
          expect(verifyCreateSMT.captured[11], CommonMocks.privateKey);

          verifyNever(getIdentityAuthClaimUseCase.execute(
              param: captureAnyNamed('param')));

          verifyNever(identityRepository.getAuthClaimNode(
              children: captureAnyNamed('children')));

          verifyNever(smtRepository.addLeaf(
              leaf: captureAnyNamed('leaf'),
              type: captureAnyNamed('type'),
              did: captureAnyNamed('did'),
              privateKey: captureAnyNamed('privateKey')));
        },
      );
    },
  );
}
