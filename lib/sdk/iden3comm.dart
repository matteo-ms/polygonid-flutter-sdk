import 'package:injectable/injectable.dart';
import 'package:polygonid_flutter_sdk/common/domain/domain_constants.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/filter_entity.dart';
import 'package:polygonid_flutter_sdk/credential/domain/entities/claim_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/interaction/interaction_base_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/interaction/interaction_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/jwz_proof_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/request/auth/auth_iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/request/offer/offer_iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/exceptions/iden3comm_exceptions.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/use_cases/authenticate_use_case.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/use_cases/fetch_and_save_claims_use_case.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/use_cases/get_filters_use_case.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/use_cases/get_iden3comm_claims_use_case.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/use_cases/get_iden3comm_proofs_use_case.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/use_cases/get_iden3message_use_case.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/use_cases/get_vocabs_use_case.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/use_cases/interaction/add_interaction_use_case.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/use_cases/interaction/get_interactions_use_case.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/use_cases/interaction/remove_interactions_use_case.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/use_cases/interaction/update_interaction_use_case.dart';

import '../iden3comm/domain/use_cases/get_schemas_use_case.dart';

abstract class PolygonIdSdkIden3comm {
  /// Returns a [Iden3MessageEntity] from an iden3comm message string.
  ///
  /// The [message] is the iden3comm message in string format
  ///
  /// When communicating through iden3comm with an Issuer or Verifier,
  /// iden3comm message string needs to be parsed to a supported
  /// [Iden3MessageEntity] by the Polygon Id Sdk using this method.
  Future<Iden3MessageEntity> getIden3Message({required String message});

  /// Returns the schemas from an [Iden3MessageEntity].
  Future<List<Map<String, dynamic>>> getSchemas(
      {required Iden3MessageEntity message});

  /// Returns the vocabs from an [Iden3MessageEntity].
  Future<List<Map<String, dynamic>>> getVocabs(
      {required Iden3MessageEntity message});

  /// Returns a list of [FilterEntity] from an iden3comm message to
  /// apply to [Credential.getClaims]
  ///
  /// The [message] is the iden3comm message entity
  Future<List<FilterEntity>> getFilters({required Iden3MessageEntity message});

  /// Fetch a list of [ClaimEntity] from issuer using iden3comm message
  /// and stores them in Polygon Id Sdk.
  ///
  /// The [message] is the iden3comm message entity
  ///
  /// The [genesisDid] is the unique id of the identity
  ///
  /// The [profileNonce] is the nonce of the profile used from identity
  /// to obtain the did identifier
  ///
  /// The [privateKey] is the key used to access all the sensitive info from the identity
  /// and also to realize operations like generating proofs
  Future<List<ClaimEntity>> fetchAndSaveClaims(
      {required Iden3MessageEntity message,
      required String genesisDid,
      BigInt? profileNonce,
      required String privateKey});

  /// Get a list of [ClaimEntity] from iden3comm message
  /// stored in Polygon Id Sdk.
  ///
  /// The [message] is the iden3comm message entity
  ///
  /// The [genesisDid] is the unique id of the identity
  ///
  /// The [profileNonce] is the nonce of the profile used from identity
  /// to obtain the did identifier
  ///
  /// The [privateKey] is the key used to access all the sensitive info from the identity
  /// and also to realize operations like generating proofs
  Future<List<ClaimEntity?>> getClaimsFromIden3Message({
    required Iden3MessageEntity message,
    required String genesisDid,
    BigInt? profileNonce,
    required String privateKey,
  });

  /// Get a list of [JWZProofEntity] from iden3comm message
  ///
  /// The [message] is the iden3comm message entity
  ///
  /// The [genesisDid] is the unique id of the identity
  ///
  /// The [profileNonce] is the nonce of the profile used from identity
  /// to obtain the did identifier
  ///
  /// The [privateKey] is the key used to access all the sensitive info from the identity
  /// and also to realize operations like generating proofs
  Future<List<JWZProofEntity>> getProofs(
      {required Iden3MessageEntity message,
      required String genesisDid,
      BigInt? profileNonce,
      required String privateKey,
      String? challenge});

  /// Authenticate response from iden3Message sharing the needed
  /// (if any) proofs requested by it
  ///
  /// The [message] is the iden3comm message entity
  ///
  /// The [genesisDid] is the unique id of the identity
  ///
  /// The [profileNonce] is the nonce of the profile used from identity
  /// to obtain the did identifier
  ///
  /// The [privateKey] is the key used to access all the sensitive info from the identity
  /// and also to realize operations like generating proofs
  ///
  /// The [pushToken] is the push notification registration token so the issuer/verifer
  /// can send notifications to the identity.
  Future<void> authenticate({
    required Iden3MessageEntity message,
    required String genesisDid,
    BigInt? profileNonce,
    required String privateKey,
    String? pushToken,
  });

  /// Gets a list of [InteractionEntity] associated to the identity previously stored
  /// in the the Polygon ID Sdk
  ///
  /// /// The [genesisDid] is the unique id of the identity
  ///
  /// The [profileNonce] is the nonce of the profile used from identity
  /// to obtain the did identifier
  ///
  /// The [privateKey]  is the key used to access all the sensitive info from the identity
  /// and also to realize operations like generating proofs
  Future<List<InteractionBaseEntity>> getInteractions({
    String? genesisDid,
    BigInt? profileNonce,
    String? privateKey,
    List<InteractionType>? types,
    List<InteractionState>? states,
    List<FilterEntity>? filters,
  });

  /// Saves an [InteractionBaseEntity] in the Polygon ID Sdk
  ///
  /// The [interaction] is the interaction to be saved
  /// The [privateKey]  is the key used to access all the sensitive info from the identity
  Future<InteractionBaseEntity> addInteraction({
    required InteractionBaseEntity interaction,
    String? genesisDid,
    String? privateKey,
  });

  /// Removes a list of [InteractionEntity] from the Polygon ID Sdk by their ids
  ///
  /// The [genesisDid] is the unique id of the identity
  /// The [privateKey]  is the key used to access all the sensitive info from the identity
  /// The [ids] is the list of ids of the interactions to be removed
  Future<void> removeInteractions({
    String? genesisDid,
    String? privateKey,
    required List<String> ids,
  });

  /// Updated the states of a [InteractionBaseEntity] in the Polygon ID Sdk
  ///
  /// The [id] is the id of the notification to be updated
  /// The [genesisDid] is the unique id of the identity
  /// The [privateKey]  is the key used to access all the sensitive info from the identity
  /// The [state] is the new state of the inteaction
  Future<InteractionBaseEntity> updateInteraction({
    required String id,
    String? genesisDid,
    String? privateKey,
    InteractionState? state,
  });

  /// Handles notifications and store them
  ///
  /// The [payload] is the notification payload
// Future<void> handleNotification({required String payload});
}

@injectable
class Iden3comm implements PolygonIdSdkIden3comm {
  final FetchAndSaveClaimsUseCase _fetchAndSaveClaimsUseCase;
  final GetIden3MessageUseCase _getIden3MessageUseCase;
  final GetSchemasUseCase _getSchemasUseCase;
  final GetVocabsUseCase _getVocabsUseCase;
  final AuthenticateUseCase _authenticateUseCase;
  final GetFiltersUseCase _getFiltersUseCase;
  final GetIden3commClaimsUseCase _getIden3commClaimsUseCase;
  final GetIden3commProofsUseCase _getIden3commProofsUseCase;
  final GetInteractionsUseCase _getInteractionsUseCase;
  final AddInteractionUseCase _addInteractionUseCase;
  final RemoveInteractionsUseCase _removeInteractionsUseCase;
  final UpdateInteractionUseCase _updateInteractionUseCase;

  Iden3comm(
    this._fetchAndSaveClaimsUseCase,
    this._getIden3MessageUseCase,
    this._getSchemasUseCase,
    this._getVocabsUseCase,
    this._authenticateUseCase,
    this._getFiltersUseCase,
    this._getIden3commClaimsUseCase,
    this._getIden3commProofsUseCase,
    this._getInteractionsUseCase,
    this._addInteractionUseCase,
    this._removeInteractionsUseCase,
    this._updateInteractionUseCase,
  );

  @override
  Future<Iden3MessageEntity> getIden3Message({required String message}) {
    return _getIden3MessageUseCase.execute(param: message);
  }

  @override
  Future<List<Map<String, dynamic>>> getSchemas(
      {required Iden3MessageEntity message}) {
    return _getSchemasUseCase.execute(param: message);
  }

  @override
  Future<List<Map<String, dynamic>>> getVocabs(
      {required Iden3MessageEntity message}) {
    return _getVocabsUseCase.execute(param: message);
  }

  @override
  Future<List<FilterEntity>> getFilters({required Iden3MessageEntity message}) {
    return _getFiltersUseCase.execute(param: message);
  }

  @override
  Future<List<ClaimEntity>> fetchAndSaveClaims(
      {required Iden3MessageEntity message,
      required String genesisDid,
      BigInt? profileNonce,
      required String privateKey}) {
    if (message is! OfferIden3MessageEntity) {
      throw InvalidIden3MsgTypeException(
          Iden3MessageType.offer, message.messageType);
    }
    return _fetchAndSaveClaimsUseCase.execute(
        param: FetchAndSaveClaimsParam(
            message: message,
            genesisDid: genesisDid,
            profileNonce: profileNonce ?? GENESIS_PROFILE_NONCE,
            privateKey: privateKey));
  }

  @override
  Future<List<ClaimEntity?>> getClaimsFromIden3Message(
      {required Iden3MessageEntity message,
      required String genesisDid,
      BigInt? profileNonce,
      required String privateKey}) {
    return _getIden3commClaimsUseCase.execute(
        param: GetIden3commClaimsParam(
      message: message,
      genesisDid: genesisDid,
      profileNonce: profileNonce ?? GENESIS_PROFILE_NONCE,
      privateKey: privateKey,
    ));
  }

  @override
  Future<List<JWZProofEntity>> getProofs(
      {required Iden3MessageEntity message,
      required String genesisDid,
      BigInt? profileNonce,
      required String privateKey,
      String? challenge}) {
    return _getIden3commProofsUseCase.execute(
        param: GetIden3commProofsParam(
      message: message,
      genesisDid: genesisDid,
      profileNonce: profileNonce ?? GENESIS_PROFILE_NONCE,
      privateKey: privateKey,
      challenge: challenge,
    ));
  }

  @override
  Future<void> authenticate(
      {required Iden3MessageEntity message,
      required String genesisDid,
      BigInt? profileNonce,
      required String privateKey,
      String? pushToken}) {
    if (message is! AuthIden3MessageEntity) {
      throw InvalidIden3MsgTypeException(
          Iden3MessageType.auth, message.messageType);
    }

    return _authenticateUseCase.execute(
        param: AuthenticateParam(
      message: message,
      genesisDid: genesisDid,
      profileNonce: profileNonce ?? GENESIS_PROFILE_NONCE,
      privateKey: privateKey,
      pushToken: pushToken,
    ));
  }

  @override
  Future<List<InteractionBaseEntity>> getInteractions({
    String? genesisDid,
    BigInt? profileNonce,
    String? privateKey,
    List<InteractionType>? types,
    List<InteractionState>? states,
    List<FilterEntity>? filters,
  }) {
    return _getInteractionsUseCase.execute(
        param: GetInteractionsParam(
      genesisDid: genesisDid,
      profileNonce: profileNonce ?? GENESIS_PROFILE_NONCE,
      privateKey: privateKey,
      types: types,
      filters: filters,
    ));
  }

  @override
  Future<void> removeInteractions({
    required List<String> ids,
    String? genesisDid,
    BigInt? profileNonce,
    String? privateKey,
  }) {
    return _removeInteractionsUseCase.execute(
        param: RemoveInteractionsParam(
            genesisDid: genesisDid,
            profileNonce: profileNonce,
            privateKey: privateKey,
            ids: ids));
  }

  @override
  Future<InteractionBaseEntity> addInteraction({
    required InteractionBaseEntity interaction,
    String? genesisDid,
    BigInt? profileNonce,
    String? privateKey,
  }) {
    return _addInteractionUseCase.execute(
        param: AddInteractionParam(
            genesisDid: genesisDid,
            profileNonce: profileNonce,
            privateKey: privateKey,
            interaction: interaction));
  }

  @override
  Future<InteractionBaseEntity> updateInteraction({
    required String id,
    String? genesisDid,
    BigInt? profileNonce,
    String? privateKey,
    InteractionState? state,
  }) {
    return _updateInteractionUseCase.execute(
        param: UpdateInteractionParam(
      genesisDid: genesisDid,
      profileNonce: profileNonce,
      privateKey: privateKey,
      id: id,
      state: state,
    ));
  }
}
