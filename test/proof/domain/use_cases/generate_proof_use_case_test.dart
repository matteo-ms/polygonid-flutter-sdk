import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:polygonid_flutter_sdk/credential/domain/use_cases/get_auth_claim_use_case.dart';
import 'package:polygonid_flutter_sdk/identity/domain/repositories/identity_repository.dart';
import 'package:polygonid_flutter_sdk/identity/domain/repositories/smt_repository.dart';
import 'package:polygonid_flutter_sdk/identity/domain/use_cases/get_did_use_case.dart';
import 'package:polygonid_flutter_sdk/identity/domain/use_cases/get_latest_state_use_case.dart';
import 'package:polygonid_flutter_sdk/identity/domain/use_cases/identity/get_identity_use_case.dart';
import 'package:polygonid_flutter_sdk/identity/domain/use_cases/sign_message_use_case.dart';
import 'package:polygonid_flutter_sdk/proof/domain/repositories/proof_repository.dart';
import 'package:polygonid_flutter_sdk/proof/domain/use_cases/generate_proof_use_case.dart';
import 'package:polygonid_flutter_sdk/proof/domain/use_cases/get_gist_proof_use_case.dart';
import 'package:polygonid_flutter_sdk/proof/domain/use_cases/get_jwz_use_case.dart';
import 'package:polygonid_flutter_sdk/proof/domain/use_cases/prove_use_case.dart';

import '../../../common/common_mocks.dart';
import '../../../common/credential_mocks.dart';
import '../../../common/iden3comm_mocks.dart';
import '../../../common/identity_mocks.dart';
import '../../../common/proof_mocks.dart';
import 'generate_proof_use_case_test.mocks.dart';

MockIdentityRepository identityRepository = MockIdentityRepository();
MockSMTRepository smtRepository = MockSMTRepository();
MockProofRepository proofRepository = MockProofRepository();
MockProveUseCase proveUseCase = MockProveUseCase();
MockGetIdentityUseCase getIdentityUseCase = MockGetIdentityUseCase();
MockGetAuthClaimUseCase getAuthClaimUseCase = MockGetAuthClaimUseCase();
MockGetGistProofUseCase getGistProofUseCase = MockGetGistProofUseCase();
MockGetDidUseCase getDidUseCase = MockGetDidUseCase();
MockSignMessageUseCase signMessageUseCase = MockSignMessageUseCase();
MockGetLatestStateUseCase getLatestStateUseCase = MockGetLatestStateUseCase();
GenerateProofUseCase useCase = GenerateProofUseCase(
  identityRepository,
  smtRepository,
  proofRepository,
  proveUseCase,
  getIdentityUseCase,
  getAuthClaimUseCase,
  getGistProofUseCase,
  getDidUseCase,
  signMessageUseCase,
  getLatestStateUseCase,
);

// Data
GenerateProofParam param =
GenerateProofParam(
    CommonMocks.did,
    CommonMocks.nonce,
    CommonMocks.nonce,
    CredentialMocks.claim,
    Iden3commMocks.proofScopeRequest,
    ProofMocks.circuitData,
    null,
    null);

GenerateProofParam onChainParam =
GenerateProofParam(
    CommonMocks.did,
    CommonMocks.nonce,
    CommonMocks.nonce,
    CredentialMocks.claim,
    Iden3commMocks.otherProofScopeRequest,
    ProofMocks.circuitOnChainSigData,
    CommonMocks.privateKey,
    CommonMocks.challenge);

var claims = [CommonMocks.authClaim, CommonMocks.authClaim];

@GenerateMocks([
  IdentityRepository,
  SMTRepository,
  ProofRepository,
  ProveUseCase,
  GetIdentityUseCase,
  GetAuthClaimUseCase,
  GetGistProofUseCase,
  GetDidUseCase,
  SignMessageUseCase,
  GetLatestStateUseCase,
])
void main() {
  setUp(() {
    reset(identityRepository);
    reset(smtRepository);
    reset(proofRepository);
    reset(proveUseCase);
    reset(getIdentityUseCase);
    reset(getAuthClaimUseCase);
    reset(getGistProofUseCase);
    reset(getDidUseCase);
    reset(signMessageUseCase);
    reset(getLatestStateUseCase);

    when(identityRepository.getAuthClaimNode(children: anyNamed('children')))
        .thenAnswer((realInvocation) => Future.value(IdentityMocks.node));
    when(proveUseCase.execute(param: anyNamed('param')))
        .thenAnswer((realInvocation) => Future.value(ProofMocks.jwzProof));
    when(getIdentityUseCase.execute(param: anyNamed('param'))).thenAnswer(
            (realInvocation) => Future.value(IdentityMocks.privateIdentity));
    when(getAuthClaimUseCase.execute(param: anyNamed("param")))
        .thenAnswer((realInvocation) => Future.value(claims));
    when(getGistProofUseCase.execute(param: anyNamed('param')))
        .thenAnswer((realInvocation) => Future.value(ProofMocks.gistProof));
    when(getDidUseCase.execute(param: anyNamed('param')))
        .thenAnswer((realInvocation) => Future.value(IdentityMocks.did));
    when(signMessageUseCase.execute(param: anyNamed("param")))
        .thenAnswer((realInvocation) => Future.value(CommonMocks.signature));
    when(getLatestStateUseCase.execute(param: anyNamed('param')))
        .thenAnswer((realInvocation) => Future.value(CommonMocks.aMap));
  });

  test(
    'Given a param, when I call execute, then I expect a String to be returned',
    () async {
      // When
      expect(await useCase.execute(param: param), ProofMocks.jwzProofEntity);

      // Then
      var capturedEncode =
          verify(proofRepository.encodeJWZ(jwz: captureAnyNamed("jwz")))
              .captured
              .first;
      expect(capturedEncode, ProofMocks.jwz);
    },
  );

  test(
    'Given an on chain param, when I call execute, then I expect a String to be returned',
        () async {
      // When
      expect(await useCase.execute(param: onChainParam), ProofMocks.jwzProofEntity);

      // Then
      var capturedGet =
          verify(proofRepository.encodeJWZ(jwz: captureAnyNamed("jwz")))
              .captured
              .first;
      expect(capturedEncode, ProofMocks.jwz);
    },
  );

  test(
    'Given a param, when I call execute and an error occurred, then I expect an exception to be thrown',
    () async {
      // Given
      when(proofRepository.encodeJWZ(jwz: anyNamed("jwz")))
          .thenAnswer((realInvocation) => Future.error(CommonMocks.exception));

      // When
      await useCase
          .execute(param: param)
          .then((value) => expect(true, false))
          .catchError((error) {
        expect(error, CommonMocks.exception);
      });

      // Then
      var capturedEncode =
          verify(proofRepository.encodeJWZ(jwz: captureAnyNamed("jwz")))
              .captured
              .first;
      expect(capturedEncode, ProofMocks.jwz);
    },
  );
}
