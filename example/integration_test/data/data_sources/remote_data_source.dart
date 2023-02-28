import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';
import 'package:polygonid_flutter_sdk_example/env/integration_test_env.dart';
import 'package:polygonid_flutter_sdk_example/src/data/secure_storage.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/utils/blockchain_resources.dart';
import 'package:polygonid_flutter_sdk_example/utils/secure_storage_keys.dart';

class RemoteDataSource {
  final String _apiBaseUrl = "https://self-hosted-platform.polygonid.me";
  final String _apiBackendUrl =
      "https://self-hosted-demo-backend-platform.polygonid.me/api";
  final String _apiVersion = "v1";

  ///
  Future<String> getAuthenticationIden3MessageFromApi({
    Map<String, String>? queryParams,
  }) async {
    Uri uri = Uri.parse("$_apiBackendUrl/sign-in");

    //add query params
    if (queryParams != null) {
      uri = uri.replace(queryParameters: queryParams);
    }

    Response response = await get(
      uri,
      headers: {
        HttpHeaders.acceptHeader: '*/*',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );
    return response.body;
  }

  ///
  Future<String> getClaimIdFromApi() async {
    String username = IntegrationTestEnv.selfHostedPlatformUsername;
    String password = IntegrationTestEnv.selfHostedPlatformPassword;
    String issuerDid = IntegrationTestEnv.selfHostedPlatformIssuerDid;
    String? privateKey =
        await SecureStorage.read(key: SecureStorageKeys.privateKey);
    String walletDid = await getIt<PolygonIdSdk>().identity.getDidIdentifier(
        privateKey: privateKey!,
        blockchain: BlockchainResources.blockchain,
        network: BlockchainResources.network);

    // NB: expiration is in seconds unix time
    Map<String, dynamic> claim = {
      "credentialSchema":
          "https://raw.githubusercontent.com/iden3/claim-schema-vocab/main/schemas/json/KYCAgeCredential-v3.json",
      "type": "KYCAgeCredential",
      "credentialSubject": {
        "id": walletDid,
        "birthday": 19960424,
        "documentType": 2
      },
      "expiration": 1740747898
    };

    final String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    Uri uri = Uri.parse("$_apiBaseUrl/$_apiVersion/$issuerDid/claims");

    Response response = await post(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: basicAuth,
        HttpHeaders.acceptHeader: '*/*',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(claim),
    );

    Map<String, dynamic> responseJson = jsonDecode(response.body);
    String claimId = responseJson['id'];
    return claimId;
  }

  ///
  Future<String> getClaimIden3MessageFromApi(String claimId) async {
    String username = IntegrationTestEnv.selfHostedPlatformUsername;
    String password = IntegrationTestEnv.selfHostedPlatformPassword;
    String issuerDid = IntegrationTestEnv.selfHostedPlatformIssuerDid;

    final String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    Uri uri = Uri.parse(
        "$_apiBaseUrl/$_apiVersion/$issuerDid/claims/$claimId/qrcode");

    Response response = await get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: basicAuth,
        HttpHeaders.acceptHeader: '*/*',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    return response.body;
  }
}
