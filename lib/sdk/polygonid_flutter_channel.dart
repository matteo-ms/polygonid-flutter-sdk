import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:polygonid_flutter_sdk/common/domain/domain_logger.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/env_entity.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/filter_entity.dart';
import 'package:polygonid_flutter_sdk/credential/domain/entities/claim_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/interaction/interaction_base_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/interaction/interaction_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/jwz_proof_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/request/auth/auth_iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/request/auth/proof_scope_request.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/request/offer/offer_iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/identity/domain/entities/did_entity.dart';
import 'package:polygonid_flutter_sdk/identity/domain/entities/identity_entity.dart';
import 'package:polygonid_flutter_sdk/identity/domain/entities/private_identity_entity.dart';
import 'package:polygonid_flutter_sdk/proof/domain/entities/circuit_data_entity.dart';
import 'package:polygonid_flutter_sdk/proof/domain/entities/download_info_entity.dart';
import 'package:polygonid_flutter_sdk/sdk/credential.dart';
import 'package:polygonid_flutter_sdk/sdk/iden3comm.dart';
import 'package:polygonid_flutter_sdk/sdk/identity.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';
import 'package:polygonid_flutter_sdk/sdk/proof.dart';

const downloadCircuitsName = 'downloadCircuits';
const proofGenerationStepsName = 'proofGenerationSteps';

/// PolygonIdSdh channel, to be able to use the SDK in native code
/// We are implementing the interfaces of the SDK just to be sure nothing is missing
@injectable
class PolygonIdFlutterChannel
    implements
        PolygonIdSdkIden3comm,
        PolygonIdSdkIdentity,
        PolygonIdSdkCredential,
        PolygonIdSdkProof {
  final PolygonIdSdk _polygonIdSdk;
  final MethodChannel _methodChannel;
  final Map<String, StreamSubscription> _streamSubscriptions = {};

  Future<void> _listen(
      {required String name,
      required Stream stream,
      Function? onError,
      void Function()? onDone,
      bool? cancelOnError}) {
    return _addSubscription(
        name,
        stream.listen(
            (event) => _methodChannel.invokeMethod('onStreamData', {
                  'key': name,
                  'data': jsonEncode(event),
                }),
            onError: onError,
            onDone: onDone,
            cancelOnError: cancelOnError));
  }

  Future<void> _addSubscription(
      String name, StreamSubscription subscription) async {
    await _closeSubscription(name);
    _streamSubscriptions[name] = subscription;
  }

  Future<void> _closeSubscription(String name) async {
    await _streamSubscriptions[name]?.cancel();
    _streamSubscriptions.remove(name);
  }

  PolygonIdFlutterChannel(this._polygonIdSdk, this._methodChannel) {
    _methodChannel.setMethodCallHandler((call) {
      logger().d(call.method);

      switch (call.method) {
        /// Internal
        case 'closeStream':
          return call.arguments['key'] != null
              ? _closeSubscription(call.arguments['key'] as String)
              : Future.value();

        /// SDK
        case 'init':
          return PolygonIdSdk.init(
              env: call.arguments['env'] != null
                  ? EnvEntity.fromJson(jsonDecode(call.arguments['env']))
                  : null);

        case 'setEnv':
          return _polygonIdSdk.setEnv(
              env: EnvEntity.fromJson(jsonDecode(call.arguments['env'])));

        case 'getEnv':
          return _polygonIdSdk.getEnv().then((env) => jsonEncode(env));

        /// Iden3comm
        case 'addInteraction':
          Map<String, dynamic> json = jsonDecode(call.arguments['interaction']);
          InteractionBaseEntity interaction;

          try {
            interaction = InteractionEntity.fromJson(json);
          } catch (e) {
            interaction = InteractionBaseEntity.fromJson(json);
          }

          return addInteraction(
                  interaction: interaction,
                  genesisDid: call.arguments['genesisDid'] as String?,
                  privateKey: call.arguments['privateKey'] as String?)
              .then((interaction) => jsonEncode(interaction));

        case 'authenticate':
          return authenticate(
              message: AuthIden3MessageEntity.fromJson(
                  jsonDecode(call.arguments['message'])),
              genesisDid: call.arguments['genesisDid'] as String,
              profileNonce: BigInt.tryParse(
                  call.arguments['profileNonce'] as String? ?? ''),
              privateKey: call.arguments['privateKey'] as String,
              pushToken: call.arguments['pushToken'] as String?);

        case 'fetchAndSaveClaims':
          return fetchAndSaveClaims(
                  message: OfferIden3MessageEntity.fromJson(
                      jsonDecode(call.arguments['message'])),
                  genesisDid: call.arguments['genesisDid'] as String,
                  profileNonce: BigInt.tryParse(
                      call.arguments['profileNonce'] as String? ?? ''),
                  privateKey: call.arguments['privateKey'] as String)
              .then((claims) =>
                  claims.map((claim) => jsonEncode(claim)).toList());

        case 'getClaimsFromIden3Message':
          return getClaimsFromIden3Message(
                  message: OfferIden3MessageEntity.fromJson(
                      jsonDecode(call.arguments['message'])),
                  genesisDid: call.arguments['genesisDid'] as String,
                  profileNonce: BigInt.tryParse(
                      call.arguments['profileNonce'] as String? ?? ''),
                  privateKey: call.arguments['privateKey'] as String)
              .then((claims) =>
                  claims.map((claim) => jsonEncode(claim)).toList());

        case 'getFilters':
          return getIden3Message(message: call.arguments['message'])
              .then((message) => getFilters(message: message))
              .then((filters) =>
                  filters.map((filter) => jsonEncode(filter)).toList());

        case 'getIden3Message':
          return getIden3Message(message: call.arguments['message'])
              .then((message) => jsonEncode(message));

        case 'getSchemas':
          return getIden3Message(message: call.arguments['message'])
              .then((message) => getSchemas(message: message));

        case 'getVocabs':
          return getIden3Message(message: call.arguments['message'])
              .then((message) => getVocabs(message: message));

        case 'getInteractions':
          return getInteractions(
            genesisDid: call.arguments['genesisDid'] as String?,
            profileNonce: BigInt.tryParse(
                call.arguments['profileNonce'] as String? ?? ''),
            privateKey: call.arguments['privateKey'] as String?,
            types: (call.arguments['types'] as List?)
                ?.map((type) => InteractionType.values
                    .firstWhere((interactionType) => interactionType == type))
                .toList(),
            states: (call.arguments['states'] as List?)
                ?.map((state) => InteractionState.values.firstWhere(
                    (interactionState) => interactionState == state))
                .toList(),
            filters: (call.arguments['filters'] as List?)
                ?.map((filter) => FilterEntity.fromJson(jsonDecode(filter)))
                .toList(),
          ).then((interactions) => interactions
              .map((interaction) => jsonEncode(interaction))
              .toList());

        case 'getProofs':
          return getIden3Message(message: call.arguments['message'])
              .then((message) => getProofs(
                  message: message,
                  genesisDid: call.arguments['genesisDid'] as String,
                  profileNonce: BigInt.tryParse(
                      call.arguments['profileNonce'] as String? ?? ''),
                  privateKey: call.arguments['privateKey'] as String,
                  challenge: call.arguments['challenge'] as String?))
              .then((message) => jsonEncode(message));

        case 'removeInteractions':
          return removeInteractions(
              genesisDid: call.arguments['genesisDid'] as String?,
              privateKey: call.arguments['privateKey'] as String?,
              ids: call.arguments['ids'] as List<String>);

        case 'updateInteraction':
          return updateInteraction(
                  id: call.arguments['id'] as String,
                  genesisDid: call.arguments['genesisDid'] as String?,
                  privateKey: call.arguments['privateKey'] as String?,
                  state: call.arguments['state'] != null
                      ? InteractionState.values.firstWhere((interactionState) =>
                          interactionState == call.arguments['state'])
                      : null)
              .then((interaction) => jsonEncode(interaction));

        /// Identity
        case 'addIdentity':
          return addIdentity(secret: call.arguments['secret'] as String?)
              .then((identity) => jsonEncode(identity));

        case 'addProfile':
          return addProfile(
            genesisDid: call.arguments['genesisDid'] as String,
            privateKey: call.arguments['privateKey'] as String,
            profileNonce:
                BigInt.parse(call.arguments['profileNonce'] as String),
          );

        case 'backupIdentity':
          return backupIdentity(
              genesisDid: call.arguments['genesisDid'] as String,
              privateKey: call.arguments['privateKey'] as String);

        case 'checkIdentityValidity':
          return checkIdentityValidity(
              secret: call.arguments['secret'] as String);

        case 'getDidEntity':
          return getDidEntity(did: call.arguments['did'] as String)
              .then((did) => jsonEncode(did));

        case 'getDidIdentifier':
          return getDidIdentifier(
              privateKey: call.arguments['privateKey'] as String,
              blockchain: call.arguments['blockchain'] as String,
              network: call.arguments['network'] as String,
              profileNonce: BigInt.tryParse(
                  call.arguments['profileNonce'] as String? ?? ''));

        case 'getIdentities':
          return getIdentities().then((identities) =>
              identities.map((identity) => jsonEncode(identity)).toList());

        case 'getIdentity':
          return getIdentity(
                  genesisDid: call.arguments['genesisDid'] as String,
                  privateKey: call.arguments['privateKey'] as String?)
              .then((identity) => jsonEncode(identity));

        case 'getPrivateKey':
          return getPrivateKey(secret: call.arguments['secret'] as String);

        case 'getProfiles':
          return getProfiles(
                  genesisDid: call.arguments['genesisDid'] as String,
                  privateKey: call.arguments['privateKey'] as String)
              .then((profiles) => profiles
                  .map((key, value) => MapEntry(key.toString(), value)));

        case 'getState':
          return getState(did: call.arguments['did'] as String);

        case 'removeIdentity':
          return removeIdentity(
              genesisDid: call.arguments['genesisDid'] as String,
              privateKey: call.arguments['privateKey'] as String);

        case 'removeProfile':
          return removeProfile(
              genesisDid: call.arguments['genesisDid'] as String,
              privateKey: call.arguments['privateKey'] as String,
              profileNonce:
                  BigInt.parse(call.arguments['profileNonce'] as String));

        case 'restoreIdentity':
          return restoreIdentity(
                  genesisDid: call.arguments['genesisDid'] as String,
                  privateKey: call.arguments['privateKey'] as String,
                  encryptedDb: call.arguments['encryptedDb'] as String?)
              .then((identity) => jsonEncode(identity));

        case 'sign':
          return sign(
              message: call.arguments['message'] as String,
              privateKey: call.arguments['privateKey'] as String);

        /// Credential
        case 'getClaims':
          return getClaims(
                  filters: (call.arguments['filters'] as List?)
                      ?.map((filter) =>
                          FilterEntity.fromJson(jsonDecode(filter as String)))
                      .toList(),
                  genesisDid: call.arguments['genesisDid'] as String,
                  privateKey: call.arguments['privateKey'] as String)
              .then((claims) =>
                  claims.map((claim) => jsonEncode(claim)).toList());

        case 'getClaimsByIds':
          return getClaimsByIds(
                  claimIds: (call.arguments['claimIds'] as List)
                      .map((e) => e as String)
                      .toList(),
                  genesisDid: call.arguments['genesisDid'] as String,
                  privateKey: call.arguments['privateKey'] as String)
              .then((claims) =>
                  claims.map((claim) => jsonEncode(claim)).toList());

        case 'removeClaim':
          return removeClaim(
              claimId: call.arguments['claimId'] as String,
              genesisDid: call.arguments['genesisDid'] as String,
              privateKey: call.arguments['privateKey'] as String);

        case 'removeClaims':
          return removeClaims(
              claimIds: (call.arguments['claimIds'] as List)
                  .map((e) => e as String)
                  .toList(),
              genesisDid: call.arguments['genesisDid'] as String,
              privateKey: call.arguments['privateKey'] as String);

        case 'saveClaims':
          return saveClaims(
                  claims: (call.arguments['claims'] as List)
                      .map((claim) => ClaimEntity.fromJson(jsonDecode(claim)))
                      .toList(),
                  genesisDid: call.arguments['genesisDid'] as String,
                  privateKey: call.arguments['privateKey'] as String)
              .then((claims) =>
                  claims.map((claim) => jsonEncode(claim)).toList());

        case 'updateClaim':
          return updateClaim(
                  claimId: call.arguments['claimId'] as String,
                  issuer: call.arguments['issuer'] as String?,
                  genesisDid: call.arguments['genesisDid'] as String,
                  state: call.arguments['state'] != null
                      ? ClaimState.values.firstWhere(
                          (claimState) => claimState == call.arguments['state'])
                      : null,
                  expiration: call.arguments['expiration'] as String?,
                  type: call.arguments['type'] as String?,
                  data: call.arguments['data'] as Map<String, dynamic>?,
                  privateKey: call.arguments['privateKey'] as String)
              .then((claim) => jsonEncode(claim));

        case 'startDownloadCircuits':
          return _listen(
              name: downloadCircuitsName,
              stream: initCircuitsDownloadAndGetInfoStream,
              onDone: () {
                _closeSubscription('downloadCircuits')
                    .then((_) => downloadCircuitsName);
              });

        case 'isAlreadyDownloadedCircuitsFromServer':
          return isAlreadyDownloadedCircuitsFromServer();

        case 'cancelDownloadCircuits':
          return cancelDownloadCircuits()
              .then((_) => _closeSubscription('downloadCircuits'));

        case 'proofGenerationStepsStream':
          return _listen(
              name: proofGenerationStepsName,
              stream: proofGenerationStepsStream(),
              onDone: () {
                _closeSubscription('proofGenerationSteps')
                    .then((_) => proofGenerationStepsName);
              });

        case 'prove':
          return prove(
                  genesisDid: call.arguments['genesisDid'] as String,
                  profileNonce:
                      BigInt.parse(call.arguments['profileNonce'] as String),
                  claimSubjectProfileNonce: BigInt.parse(
                      call.arguments['claimSubjectProfileNonce'] as String),
                  claim: ClaimEntity.fromJson(
                      jsonDecode(call.arguments['claim'] as String)),
                  circuitData: CircuitDataEntity.fromJson(
                      jsonDecode(call.arguments['circuitData'] as String)),
                  request: ProofScopeRequest.fromJson(
                      jsonDecode(call.arguments['request'] as String)),
                  privateKey: call.arguments['privateKey'] as String?,
                  challenge: call.arguments['challenge'] as String?)
              .then((proof) => jsonEncode(proof));

        default:
          throw PlatformException(
              code: 'not_implemented',
              message: 'Method ${call.method} not implemented');
      }
    });
  }

  /// Iden3comm
  @override
  Future<InteractionBaseEntity> addInteraction(
      {required InteractionBaseEntity interaction,
      String? genesisDid,
      String? privateKey}) {
    return _polygonIdSdk.iden3comm.addInteraction(
        interaction: interaction,
        genesisDid: genesisDid,
        privateKey: privateKey);
  }

  @override
  Future<void> authenticate(
      {required Iden3MessageEntity message,
      required String genesisDid,
      BigInt? profileNonce,
      required String privateKey,
      String? pushToken}) {
    return _polygonIdSdk.iden3comm.authenticate(
        message: message,
        genesisDid: genesisDid,
        profileNonce: profileNonce,
        privateKey: privateKey,
        pushToken: pushToken);
  }

  @override
  Future<List<ClaimEntity>> fetchAndSaveClaims(
      {required Iden3MessageEntity message,
      required String genesisDid,
      BigInt? profileNonce,
      required String privateKey}) {
    return _polygonIdSdk.iden3comm.fetchAndSaveClaims(
        message: message,
        genesisDid: genesisDid,
        profileNonce: profileNonce,
        privateKey: privateKey);
  }

  @override
  Future<List<ClaimEntity?>> getClaimsFromIden3Message(
      {required Iden3MessageEntity message,
      required String genesisDid,
      BigInt? profileNonce,
      required String privateKey}) {
    return _polygonIdSdk.iden3comm.getClaimsFromIden3Message(
        message: message,
        genesisDid: genesisDid,
        profileNonce: profileNonce,
        privateKey: privateKey);
  }

  @override
  Future<List<FilterEntity>> getFilters({required Iden3MessageEntity message}) {
    return _polygonIdSdk.iden3comm.getFilters(message: message);
  }

  @override
  Future<Iden3MessageEntity> getIden3Message({required String message}) {
    return _polygonIdSdk.iden3comm.getIden3Message(message: message);
  }

  @override
  Future<List<Map<String, dynamic>>> getSchemas(
      {required Iden3MessageEntity message}) {
    return _polygonIdSdk.iden3comm.getSchemas(message: message);
  }

  @override
  Future<List<Map<String, dynamic>>> getVocabs(
      {required Iden3MessageEntity message}) {
    return _polygonIdSdk.iden3comm.getVocabs(message: message);
  }

  @override
  Future<List<InteractionBaseEntity>> getInteractions(
      {String? genesisDid,
      BigInt? profileNonce,
      String? privateKey,
      List<InteractionType>? types,
      List<InteractionState>? states,
      List<FilterEntity>? filters}) {
    return _polygonIdSdk.iden3comm.getInteractions(
        genesisDid: genesisDid,
        profileNonce: profileNonce,
        privateKey: privateKey,
        types: types,
        states: states,
        filters: filters);
  }

  @override
  Future<List<JWZProofEntity>> getProofs(
      {required Iden3MessageEntity message,
      required String genesisDid,
      BigInt? profileNonce,
      required String privateKey,
      String? challenge}) {
    return _polygonIdSdk.iden3comm.getProofs(
        message: message,
        genesisDid: genesisDid,
        profileNonce: profileNonce,
        privateKey: privateKey,
        challenge: challenge);
  }

  @override
  Future<void> removeInteractions(
      {String? genesisDid, String? privateKey, required List<String> ids}) {
    return _polygonIdSdk.iden3comm.removeInteractions(
        genesisDid: genesisDid, privateKey: privateKey, ids: ids);
  }

  @override
  Future<InteractionBaseEntity> updateInteraction(
      {required String id,
      String? genesisDid,
      String? privateKey,
      InteractionState? state}) {
    return _polygonIdSdk.iden3comm.updateInteraction(
        id: id, genesisDid: genesisDid, privateKey: privateKey, state: state);
  }

  /// Identity
  @override
  Future<PrivateIdentityEntity> addIdentity({String? secret}) {
    return _polygonIdSdk.identity.addIdentity(secret: secret);
  }

  @override
  Future<void> addProfile(
      {required String genesisDid,
      required String privateKey,
      required BigInt profileNonce}) {
    return _polygonIdSdk.identity.addProfile(
        genesisDid: genesisDid,
        privateKey: privateKey,
        profileNonce: profileNonce);
  }

  @override
  Future<String> backupIdentity(
      {required String genesisDid, required String privateKey}) {
    return _polygonIdSdk.identity
        .backupIdentity(genesisDid: genesisDid, privateKey: privateKey);
  }

  @override
  Future<void> checkIdentityValidity({required String secret}) {
    return _polygonIdSdk.identity.checkIdentityValidity(secret: secret);
  }

  @override
  Future<DidEntity> getDidEntity({required String did}) {
    return _polygonIdSdk.identity.getDidEntity(did: did);
  }

  @override
  Future<String> getDidIdentifier(
      {required String privateKey,
      required String blockchain,
      required String network,
      BigInt? profileNonce}) {
    return _polygonIdSdk.identity.getDidIdentifier(
        privateKey: privateKey,
        blockchain: blockchain,
        network: network,
        profileNonce: profileNonce);
  }

  @override
  Future<List<IdentityEntity>> getIdentities() {
    return _polygonIdSdk.identity.getIdentities();
  }

  @override
  Future<IdentityEntity> getIdentity(
      {required String genesisDid, String? privateKey}) {
    return _polygonIdSdk.identity
        .getIdentity(genesisDid: genesisDid, privateKey: privateKey);
  }

  @override
  Future<String> getPrivateKey({required String secret}) {
    return _polygonIdSdk.identity.getPrivateKey(secret: secret);
  }

  @override
  Future<Map<BigInt, String>> getProfiles(
      {required String genesisDid, required String privateKey}) {
    return _polygonIdSdk.identity
        .getProfiles(genesisDid: genesisDid, privateKey: privateKey);
  }

  @override
  Future<String> getState({required String did}) {
    return _polygonIdSdk.identity.getState(did: did);
  }

  @override
  Future<void> removeIdentity(
      {required String genesisDid, required String privateKey}) {
    return _polygonIdSdk.identity
        .removeIdentity(genesisDid: genesisDid, privateKey: privateKey);
  }

  @override
  Future<void> removeProfile(
      {required String genesisDid,
      required String privateKey,
      required BigInt profileNonce}) {
    return _polygonIdSdk.identity.removeProfile(
        genesisDid: genesisDid,
        privateKey: privateKey,
        profileNonce: profileNonce);
  }

  @override
  Future<PrivateIdentityEntity> restoreIdentity(
      {required String genesisDid,
      required String privateKey,
      String? encryptedDb}) {
    return _polygonIdSdk.identity.restoreIdentity(
        genesisDid: genesisDid,
        privateKey: privateKey,
        encryptedDb: encryptedDb);
  }

  @override
  Future<String> sign({required String privateKey, required String message}) {
    return _polygonIdSdk.identity
        .sign(privateKey: privateKey, message: message);
  }

  /// Credential
  @override
  Future<List<ClaimEntity>> getClaims(
      {List<FilterEntity>? filters,
      required String genesisDid,
      required String privateKey}) {
    return _polygonIdSdk.credential.getClaims(
        filters: filters, genesisDid: genesisDid, privateKey: privateKey);
  }

  @override
  Future<List<ClaimEntity>> getClaimsByIds(
      {required List<String> claimIds,
      required String genesisDid,
      required String privateKey}) {
    return _polygonIdSdk.credential.getClaimsByIds(
        claimIds: claimIds, genesisDid: genesisDid, privateKey: privateKey);
  }

  @override
  Future<void> removeClaim(
      {required String claimId,
      required String genesisDid,
      required String privateKey}) {
    return _polygonIdSdk.credential.removeClaim(
        claimId: claimId, genesisDid: genesisDid, privateKey: privateKey);
  }

  @override
  Future<void> removeClaims(
      {required List<String> claimIds,
      required String genesisDid,
      required String privateKey}) {
    return _polygonIdSdk.credential.removeClaims(
        claimIds: claimIds, genesisDid: genesisDid, privateKey: privateKey);
  }

  @override
  Future<List<ClaimEntity>> saveClaims(
      {required List<ClaimEntity> claims,
      required String genesisDid,
      required String privateKey}) {
    return _polygonIdSdk.credential.saveClaims(
        claims: claims, genesisDid: genesisDid, privateKey: privateKey);
  }

  @override
  Future<ClaimEntity> updateClaim(
      {required String claimId,
      String? issuer,
      required String genesisDid,
      ClaimState? state,
      String? expiration,
      String? type,
      Map<String, dynamic>? data,
      required String privateKey}) {
    return _polygonIdSdk.credential.updateClaim(
        claimId: claimId,
        issuer: issuer,
        genesisDid: genesisDid,
        state: state,
        expiration: expiration,
        type: type,
        data: data,
        privateKey: privateKey);
  }

  /// Proof
  @override
  Stream<DownloadInfo> get initCircuitsDownloadAndGetInfoStream =>
      _polygonIdSdk.proof.initCircuitsDownloadAndGetInfoStream;

  @override
  Future<bool> isAlreadyDownloadedCircuitsFromServer() {
    return _polygonIdSdk.proof.isAlreadyDownloadedCircuitsFromServer();
  }

  @override
  Future<void> cancelDownloadCircuits() {
    return _polygonIdSdk.proof.cancelDownloadCircuits();
  }

  @override
  Stream<String> proofGenerationStepsStream() {
    return _polygonIdSdk.proof.proofGenerationStepsStream();
  }

  @override
  Future<JWZProofEntity> prove(
      {required String genesisDid,
      required BigInt profileNonce,
      required BigInt claimSubjectProfileNonce,
      required ClaimEntity claim,
      required CircuitDataEntity circuitData,
      required ProofScopeRequest request,
      String? privateKey,
      String? challenge}) {
    return _polygonIdSdk.proof.prove(
        genesisDid: genesisDid,
        profileNonce: profileNonce,
        claimSubjectProfileNonce: claimSubjectProfileNonce,
        claim: claim,
        circuitData: circuitData,
        request: request,
        privateKey: privateKey,
        challenge: challenge);
  }
}
