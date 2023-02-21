// Mocks generated by Mockito 5.3.2 from annotations
// in polygonid_flutter_sdk/test/iden3comm/domain/use_cases/get_auth_inputs_use_case_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i10;
import 'dart:typed_data' as _i17;

import 'package:mockito/mockito.dart' as _i1;
import 'package:polygonid_flutter_sdk/common/domain/entities/filter_entity.dart'
    as _i19;
import 'package:polygonid_flutter_sdk/credential/domain/entities/claim_entity.dart'
    as _i4;
import 'package:polygonid_flutter_sdk/credential/domain/use_cases/get_auth_claim_use_case.dart'
    as _i11;
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/jwz_proof_entity.dart'
    as _i18;
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/proof_request_entity.dart'
    as _i20;
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/request/auth/auth_iden3_message_entity.dart'
    as _i16;
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/request/offer/offer_iden3_message_entity.dart'
    as _i21;
import 'package:polygonid_flutter_sdk/iden3comm/domain/repositories/iden3comm_repository.dart'
    as _i15;
import 'package:polygonid_flutter_sdk/identity/domain/entities/hash_entity.dart'
    as _i7;
import 'package:polygonid_flutter_sdk/identity/domain/entities/identity_entity.dart'
    as _i2;
import 'package:polygonid_flutter_sdk/identity/domain/entities/node_entity.dart'
    as _i6;
import 'package:polygonid_flutter_sdk/identity/domain/entities/rhs_node_entity.dart'
    as _i5;
import 'package:polygonid_flutter_sdk/identity/domain/entities/tree_state_entity.dart'
    as _i25;
import 'package:polygonid_flutter_sdk/identity/domain/entities/tree_type.dart'
    as _i24;
import 'package:polygonid_flutter_sdk/identity/domain/repositories/identity_repository.dart'
    as _i22;
import 'package:polygonid_flutter_sdk/identity/domain/repositories/smt_repository.dart'
    as _i23;
import 'package:polygonid_flutter_sdk/identity/domain/use_cases/get_identity_use_case.dart'
    as _i9;
import 'package:polygonid_flutter_sdk/identity/domain/use_cases/get_latest_state_use_case.dart'
    as _i14;
import 'package:polygonid_flutter_sdk/identity/domain/use_cases/sign_message_use_case.dart'
    as _i12;
import 'package:polygonid_flutter_sdk/proof/domain/entities/gist_proof_entity.dart'
    as _i3;
import 'package:polygonid_flutter_sdk/proof/domain/entities/proof_entity.dart'
    as _i8;
import 'package:polygonid_flutter_sdk/proof/domain/use_cases/get_gist_proof_use_case.dart'
    as _i13;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeIdentityEntity_0 extends _i1.SmartFake
    implements _i2.IdentityEntity {
  _FakeIdentityEntity_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGistProofEntity_1 extends _i1.SmartFake
    implements _i3.GistProofEntity {
  _FakeGistProofEntity_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeClaimEntity_2 extends _i1.SmartFake implements _i4.ClaimEntity {
  _FakeClaimEntity_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeRhsNodeEntity_3 extends _i1.SmartFake implements _i5.RhsNodeEntity {
  _FakeRhsNodeEntity_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeNodeEntity_4 extends _i1.SmartFake implements _i6.NodeEntity {
  _FakeNodeEntity_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeHashEntity_5 extends _i1.SmartFake implements _i7.HashEntity {
  _FakeHashEntity_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeProofEntity_6 extends _i1.SmartFake implements _i8.ProofEntity {
  _FakeProofEntity_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GetIdentityUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetIdentityUseCase extends _i1.Mock
    implements _i9.GetIdentityUseCase {
  MockGetIdentityUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i10.Future<_i2.IdentityEntity> execute(
          {required _i9.GetIdentityParam? param}) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [],
          {#param: param},
        ),
        returnValue:
            _i10.Future<_i2.IdentityEntity>.value(_FakeIdentityEntity_0(
          this,
          Invocation.method(
            #execute,
            [],
            {#param: param},
          ),
        )),
      ) as _i10.Future<_i2.IdentityEntity>);
}

/// A class which mocks [GetAuthClaimUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetAuthClaimUseCase extends _i1.Mock
    implements _i11.GetAuthClaimUseCase {
  MockGetAuthClaimUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i10.Future<List<String>> execute({required List<String>? param}) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [],
          {#param: param},
        ),
        returnValue: _i10.Future<List<String>>.value(<String>[]),
      ) as _i10.Future<List<String>>);
}

/// A class which mocks [SignMessageUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockSignMessageUseCase extends _i1.Mock
    implements _i12.SignMessageUseCase {
  MockSignMessageUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i10.Future<String> execute({required _i12.SignMessageParam? param}) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [],
          {#param: param},
        ),
        returnValue: _i10.Future<String>.value(''),
      ) as _i10.Future<String>);
}

/// A class which mocks [GetGistProofUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetGistProofUseCase extends _i1.Mock
    implements _i13.GetGistProofUseCase {
  MockGetGistProofUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i10.Future<_i3.GistProofEntity> execute({required String? param}) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [],
          {#param: param},
        ),
        returnValue:
            _i10.Future<_i3.GistProofEntity>.value(_FakeGistProofEntity_1(
          this,
          Invocation.method(
            #execute,
            [],
            {#param: param},
          ),
        )),
      ) as _i10.Future<_i3.GistProofEntity>);
}

/// A class which mocks [GetLatestStateUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetLatestStateUseCase extends _i1.Mock
    implements _i14.GetLatestStateUseCase {
  MockGetLatestStateUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i10.Future<Map<String, dynamic>> execute(
          {required _i14.GetLatestStateParam? param}) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [],
          {#param: param},
        ),
        returnValue:
            _i10.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i10.Future<Map<String, dynamic>>);
}

/// A class which mocks [Iden3commRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockIden3commRepository extends _i1.Mock
    implements _i15.Iden3commRepository {
  MockIden3commRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i10.Future<void> authenticate({
    required _i16.AuthIden3MessageEntity? request,
    required String? authToken,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #authenticate,
          [],
          {
            #request: request,
            #authToken: authToken,
          },
        ),
        returnValue: _i10.Future<void>.value(),
        returnValueForMissingStub: _i10.Future<void>.value(),
      ) as _i10.Future<void>);
  @override
  _i10.Future<_i17.Uint8List> getAuthInputs({
    required String? did,
    required int? profileNonce,
    required String? challenge,
    required List<String>? authClaim,
    required _i2.IdentityEntity? identity,
    required String? signature,
    required _i8.ProofEntity? incProof,
    required _i8.ProofEntity? nonRevProof,
    required _i3.GistProofEntity? gistProof,
    required Map<String, dynamic>? treeState,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAuthInputs,
          [],
          {
            #did: did,
            #profileNonce: profileNonce,
            #challenge: challenge,
            #authClaim: authClaim,
            #identity: identity,
            #signature: signature,
            #incProof: incProof,
            #nonRevProof: nonRevProof,
            #gistProof: gistProof,
            #treeState: treeState,
          },
        ),
        returnValue: _i10.Future<_i17.Uint8List>.value(_i17.Uint8List(0)),
      ) as _i10.Future<_i17.Uint8List>);
  @override
  _i10.Future<String> getAuthResponse({
    required String? did,
    required _i16.AuthIden3MessageEntity? request,
    required List<_i18.JWZProofEntity>? scope,
    String? pushUrl,
    String? pushToken,
    String? didIdentifier,
    String? packageName,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAuthResponse,
          [],
          {
            #did: did,
            #request: request,
            #scope: scope,
            #pushUrl: pushUrl,
            #pushToken: pushToken,
            #didIdentifier: didIdentifier,
            #packageName: packageName,
          },
        ),
        returnValue: _i10.Future<String>.value(''),
      ) as _i10.Future<String>);
  @override
  _i10.Future<String> getChallenge({required String? message}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getChallenge,
          [],
          {#message: message},
        ),
        returnValue: _i10.Future<String>.value(''),
      ) as _i10.Future<String>);
  @override
  _i10.Future<List<_i19.FilterEntity>> getFilters(
          {required _i20.ProofRequestEntity? request}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getFilters,
          [],
          {#request: request},
        ),
        returnValue:
            _i10.Future<List<_i19.FilterEntity>>.value(<_i19.FilterEntity>[]),
      ) as _i10.Future<List<_i19.FilterEntity>>);
  @override
  _i10.Future<_i4.ClaimEntity> fetchClaim({
    required _i21.OfferIden3MessageEntity? message,
    required String? did,
    required String? authToken,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchClaim,
          [],
          {
            #message: message,
            #did: did,
            #authToken: authToken,
          },
        ),
        returnValue: _i10.Future<_i4.ClaimEntity>.value(_FakeClaimEntity_2(
          this,
          Invocation.method(
            #fetchClaim,
            [],
            {
              #message: message,
              #did: did,
              #authToken: authToken,
            },
          ),
        )),
      ) as _i10.Future<_i4.ClaimEntity>);
}

/// A class which mocks [IdentityRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockIdentityRepository extends _i1.Mock
    implements _i22.IdentityRepository {
  MockIdentityRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i10.Future<String> getPrivateKey({
    required String? accessMessage,
    required String? secret,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getPrivateKey,
          [],
          {
            #accessMessage: accessMessage,
            #secret: secret,
          },
        ),
        returnValue: _i10.Future<String>.value(''),
      ) as _i10.Future<String>);
  @override
  _i10.Future<List<String>> getPublicKeys({required dynamic privateKey}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getPublicKeys,
          [],
          {#privateKey: privateKey},
        ),
        returnValue: _i10.Future<List<String>>.value(<String>[]),
      ) as _i10.Future<List<String>>);
  @override
  _i10.Future<void> storeIdentity({required _i2.IdentityEntity? identity}) =>
      (super.noSuchMethod(
        Invocation.method(
          #storeIdentity,
          [],
          {#identity: identity},
        ),
        returnValue: _i10.Future<void>.value(),
        returnValueForMissingStub: _i10.Future<void>.value(),
      ) as _i10.Future<void>);
  @override
  _i10.Future<void> removeIdentity({required String? genesisDid}) =>
      (super.noSuchMethod(
        Invocation.method(
          #removeIdentity,
          [],
          {#genesisDid: genesisDid},
        ),
        returnValue: _i10.Future<void>.value(),
        returnValueForMissingStub: _i10.Future<void>.value(),
      ) as _i10.Future<void>);
  @override
  _i10.Future<_i2.IdentityEntity> getIdentity({required String? genesisDid}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getIdentity,
          [],
          {#genesisDid: genesisDid},
        ),
        returnValue:
            _i10.Future<_i2.IdentityEntity>.value(_FakeIdentityEntity_0(
          this,
          Invocation.method(
            #getIdentity,
            [],
            {#genesisDid: genesisDid},
          ),
        )),
      ) as _i10.Future<_i2.IdentityEntity>);
  @override
  _i10.Future<List<_i2.IdentityEntity>> getIdentities() => (super.noSuchMethod(
        Invocation.method(
          #getIdentities,
          [],
        ),
        returnValue:
            _i10.Future<List<_i2.IdentityEntity>>.value(<_i2.IdentityEntity>[]),
      ) as _i10.Future<List<_i2.IdentityEntity>>);
  @override
  _i10.Future<String> signMessage({
    required String? privateKey,
    required String? message,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #signMessage,
          [],
          {
            #privateKey: privateKey,
            #message: message,
          },
        ),
        returnValue: _i10.Future<String>.value(''),
      ) as _i10.Future<String>);
  @override
  _i10.Future<String> getDidIdentifier({
    required String? blockchain,
    required String? network,
    required String? claimsRoot,
    int? profileNonce = 0,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getDidIdentifier,
          [],
          {
            #blockchain: blockchain,
            #network: network,
            #claimsRoot: claimsRoot,
            #profileNonce: profileNonce,
          },
        ),
        returnValue: _i10.Future<String>.value(''),
      ) as _i10.Future<String>);
  @override
  _i10.Future<Map<String, dynamic>> getNonRevProof({
    required String? identityState,
    required int? nonce,
    required String? baseUrl,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getNonRevProof,
          [],
          {
            #identityState: identityState,
            #nonce: nonce,
            #baseUrl: baseUrl,
          },
        ),
        returnValue:
            _i10.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i10.Future<Map<String, dynamic>>);
  @override
  _i10.Future<String> getState({
    required String? identifier,
    required String? contractAddress,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getState,
          [],
          {
            #identifier: identifier,
            #contractAddress: contractAddress,
          },
        ),
        returnValue: _i10.Future<String>.value(''),
      ) as _i10.Future<String>);
  @override
  _i10.Future<String> convertIdToBigInt({required String? id}) =>
      (super.noSuchMethod(
        Invocation.method(
          #convertIdToBigInt,
          [],
          {#id: id},
        ),
        returnValue: _i10.Future<String>.value(''),
      ) as _i10.Future<String>);
  @override
  _i10.Future<_i5.RhsNodeEntity> getStateRoots({required String? url}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getStateRoots,
          [],
          {#url: url},
        ),
        returnValue: _i10.Future<_i5.RhsNodeEntity>.value(_FakeRhsNodeEntity_3(
          this,
          Invocation.method(
            #getStateRoots,
            [],
            {#url: url},
          ),
        )),
      ) as _i10.Future<_i5.RhsNodeEntity>);
  @override
  _i10.Future<_i6.NodeEntity> getAuthClaimNode(
          {required List<String>? children}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAuthClaimNode,
          [],
          {#children: children},
        ),
        returnValue: _i10.Future<_i6.NodeEntity>.value(_FakeNodeEntity_4(
          this,
          Invocation.method(
            #getAuthClaimNode,
            [],
            {#children: children},
          ),
        )),
      ) as _i10.Future<_i6.NodeEntity>);
  @override
  _i10.Future<String> exportIdentity({
    required String? did,
    required String? privateKey,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #exportIdentity,
          [],
          {
            #did: did,
            #privateKey: privateKey,
          },
        ),
        returnValue: _i10.Future<String>.value(''),
      ) as _i10.Future<String>);
  @override
  _i10.Future<void> importIdentity({
    required String? did,
    required String? privateKey,
    required String? encryptedDb,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #importIdentity,
          [],
          {
            #did: did,
            #privateKey: privateKey,
            #encryptedDb: encryptedDb,
          },
        ),
        returnValue: _i10.Future<void>.value(),
        returnValueForMissingStub: _i10.Future<void>.value(),
      ) as _i10.Future<void>);
}

/// A class which mocks [SMTRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockSMTRepository extends _i1.Mock implements _i23.SMTRepository {
  MockSMTRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i10.Future<void> addLeaf({
    required _i6.NodeEntity? leaf,
    required _i24.TreeType? type,
    required String? did,
    required String? privateKey,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addLeaf,
          [],
          {
            #leaf: leaf,
            #type: type,
            #did: did,
            #privateKey: privateKey,
          },
        ),
        returnValue: _i10.Future<void>.value(),
        returnValueForMissingStub: _i10.Future<void>.value(),
      ) as _i10.Future<void>);
  @override
  _i10.Future<_i6.NodeEntity> getNode({
    required _i7.HashEntity? hash,
    required _i24.TreeType? type,
    required String? did,
    required String? privateKey,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getNode,
          [],
          {
            #hash: hash,
            #type: type,
            #did: did,
            #privateKey: privateKey,
          },
        ),
        returnValue: _i10.Future<_i6.NodeEntity>.value(_FakeNodeEntity_4(
          this,
          Invocation.method(
            #getNode,
            [],
            {
              #hash: hash,
              #type: type,
              #did: did,
              #privateKey: privateKey,
            },
          ),
        )),
      ) as _i10.Future<_i6.NodeEntity>);
  @override
  _i10.Future<void> addNode({
    required _i7.HashEntity? hash,
    required _i6.NodeEntity? node,
    required _i24.TreeType? type,
    required String? did,
    required String? privateKey,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addNode,
          [],
          {
            #hash: hash,
            #node: node,
            #type: type,
            #did: did,
            #privateKey: privateKey,
          },
        ),
        returnValue: _i10.Future<void>.value(),
        returnValueForMissingStub: _i10.Future<void>.value(),
      ) as _i10.Future<void>);
  @override
  _i10.Future<_i7.HashEntity> getRoot({
    required _i24.TreeType? type,
    required String? did,
    required String? privateKey,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getRoot,
          [],
          {
            #type: type,
            #did: did,
            #privateKey: privateKey,
          },
        ),
        returnValue: _i10.Future<_i7.HashEntity>.value(_FakeHashEntity_5(
          this,
          Invocation.method(
            #getRoot,
            [],
            {
              #type: type,
              #did: did,
              #privateKey: privateKey,
            },
          ),
        )),
      ) as _i10.Future<_i7.HashEntity>);
  @override
  _i10.Future<void> setRoot({
    required _i7.HashEntity? root,
    required _i24.TreeType? type,
    required String? did,
    required String? privateKey,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #setRoot,
          [],
          {
            #root: root,
            #type: type,
            #did: did,
            #privateKey: privateKey,
          },
        ),
        returnValue: _i10.Future<void>.value(),
        returnValueForMissingStub: _i10.Future<void>.value(),
      ) as _i10.Future<void>);
  @override
  _i10.Future<_i8.ProofEntity> generateProof({
    required _i7.HashEntity? key,
    required _i24.TreeType? type,
    required String? did,
    required String? privateKey,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #generateProof,
          [],
          {
            #key: key,
            #type: type,
            #did: did,
            #privateKey: privateKey,
          },
        ),
        returnValue: _i10.Future<_i8.ProofEntity>.value(_FakeProofEntity_6(
          this,
          Invocation.method(
            #generateProof,
            [],
            {
              #key: key,
              #type: type,
              #did: did,
              #privateKey: privateKey,
            },
          ),
        )),
      ) as _i10.Future<_i8.ProofEntity>);
  @override
  _i10.Future<void> createSMT({
    required int? maxLevels,
    required _i24.TreeType? type,
    required String? did,
    required String? privateKey,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #createSMT,
          [],
          {
            #maxLevels: maxLevels,
            #type: type,
            #did: did,
            #privateKey: privateKey,
          },
        ),
        returnValue: _i10.Future<void>.value(),
        returnValueForMissingStub: _i10.Future<void>.value(),
      ) as _i10.Future<void>);
  @override
  _i10.Future<void> removeSMT({
    required _i24.TreeType? type,
    required String? did,
    required String? privateKey,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #removeSMT,
          [],
          {
            #type: type,
            #did: did,
            #privateKey: privateKey,
          },
        ),
        returnValue: _i10.Future<void>.value(),
        returnValueForMissingStub: _i10.Future<void>.value(),
      ) as _i10.Future<void>);
  @override
  _i10.Future<String> hashState({
    required String? claims,
    required String? revocation,
    required String? roots,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #hashState,
          [],
          {
            #claims: claims,
            #revocation: revocation,
            #roots: roots,
          },
        ),
        returnValue: _i10.Future<String>.value(''),
      ) as _i10.Future<String>);
  @override
  _i10.Future<Map<String, dynamic>> convertState(
          {required _i25.TreeStateEntity? state}) =>
      (super.noSuchMethod(
        Invocation.method(
          #convertState,
          [],
          {#state: state},
        ),
        returnValue:
            _i10.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i10.Future<Map<String, dynamic>>);
}
