import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:polygonid_flutter_sdk/proof/domain/entities/download_info_entity.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';
import 'package:polygonid_flutter_sdk_example/env/integration_test_env.dart';
import 'package:polygonid_flutter_sdk_example/src/data/secure_storage.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart'
    as di;
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/routes.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/auth/widgets/auth.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claim_detail/widgets/claim_detail.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/models/claim_model.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/widgets/claim_card.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/widgets/claims.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/widgets/home.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/splash/widgets/splash.dart';
import 'package:polygonid_flutter_sdk_example/utils/blockchain_resources.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_dimensions.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_strings.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_widgets_keys.dart';
import 'package:polygonid_flutter_sdk_example/utils/secure_storage_keys.dart';
import 'package:uuid/uuid.dart';

const String _apiBaseUrl = "https://self-hosted-platform.polygonid.me";
const String _apiVersion = "v1";

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  group('complete flow with live data', () {
    setUpAll(() async {
      await di.init();
    });

    setUp(() async {
      await _initCircuits();
    });

    testWidgets(
      'best case use case, create identity, get identifier, authenticate and then navigate to claims page',
      (WidgetTester widgetTester) async {
        final key = GlobalKey<NavigatorState>();
        await _initNavigation(widgetTester: widgetTester, key: key);

        await testSplashScreen(widgetTester);
        await testHomeScreen(widgetTester);
        await testCreateIdentity(widgetTester);
        await testRemoveIdentity(widgetTester);
        await testCreateIdentity(widgetTester);
        await testAuthentication(widgetTester: widgetTester, key: key);
        await testClaims(widgetTester: widgetTester, key: key);

        final buttonFinder = find.byType(ClaimCard).first;
        await widgetTester.tap(buttonFinder);
        await widgetTester.pumpAndSettle();
        await widgetTester.pumpAndSettle(const Duration(seconds: 5));
        key.currentState?.pop();
        await widgetTester.pumpAndSettle();

        // we go back to authentication page
        key.currentState?.pop();
        await widgetTester.pumpAndSettle();

        await testAuthenticationWithVerifierKYCAgeSig(
            widgetTester: widgetTester, key: key);

        //end
        await widgetTester.pumpAndSettle();
      },
    );
  });
}

///
Future<void> testHomeScreen(WidgetTester widgetTester) async {
  // after navigate to home, initially we expect not to find the identifier
  expect(find.text(CustomStrings.homeDescription), findsOneWidget);
  expect(find.byKey(const ValueKey('identifier')), findsOneWidget);
  expect(find.text(CustomStrings.homeIdentifierSectionPlaceHolder),
      findsOneWidget);
  await widgetTester.pumpAndSettle();
}

///
Future<void> testAuthentication({
  required WidgetTester widgetTester,
  required GlobalKey<NavigatorState> key,
}) async {
  //  then by clicking on the "authentication" feature card,
  //  we expect to navigate to authentication page
  await widgetTester
      .tap(find.byKey(CustomWidgetsKeys.homeScreenFeatureCardAuthenticate));
  await widgetTester.pumpAndSettle(const Duration(seconds: 1));
  expect(find.text(CustomStrings.authDescription), findsOneWidget);
  await widgetTester.pumpAndSettle();

  // we simulate the qrCode scanning, we cannot mock it because
  // it change everytime and also it expire
  String iden3Message = await _getAuthenticationIden3MessageFromApi();
  await widgetTester.tap(find.byKey(CustomWidgetsKeys.authScreenButtonConnect));
  await widgetTester.pumpAndSettle();
  key.currentState?.pop(iden3Message);
  await widgetTester.pumpAndSettle();

  // with the iden3message scanned
  // we expect to authenticate succesfully
  await widgetTester.pumpAndSettle(const Duration(seconds: 3));
  expect(find.text(CustomStrings.authSuccess), findsOneWidget);
  await widgetTester.pumpAndSettle();
}

///
Future<void> testRemoveIdentity(WidgetTester widgetTester) async {
  // we expect to be able to remove the identity
  // so we expect to find the remove button
  expect(find.byKey(CustomWidgetsKeys.homeScreenButtonRemoveIdentity),
      findsOneWidget);

  // after tap on "remove identity" button,
  // we expect not to find identifier
  await widgetTester
      .tap(find.byKey(CustomWidgetsKeys.homeScreenButtonRemoveIdentity));
  await widgetTester.pumpAndSettle(const Duration(seconds: 1));
  expect(find.text(CustomStrings.homeIdentifierSectionPlaceHolder),
      findsOneWidget);
}

/// Initialize the navigation, needed to substitute the navigator in order
/// to mock the qrCode scanning
Future<void> _initNavigation({
  required WidgetTester widgetTester,
  required GlobalKey<NavigatorState> key,
}) async {
  await widgetTester.pumpWidget(
    MaterialApp(
      navigatorKey: key,
      initialRoute: Routes.splashPath,
      routes: {
        Routes.splashPath: (BuildContext context) => SplashScreen(),
        Routes.homePath: (BuildContext context) => const HomeScreen(),
        Routes.authPath: (BuildContext context) => AuthScreen(),
        Routes.qrCodeScannerPath: (BuildContext context) => Container(),
        Routes.claimsPath: (BuildContext context) => ClaimsScreen(),
        Routes.claimDetailPath: (BuildContext context) {
          final args = ModalRoute.of(context)!.settings.arguments as ClaimModel;
          return ClaimDetailScreen(claimModel: args);
        },
      },
    ),
  );
}

///
Future<void> testSplashScreen(WidgetTester widgetTester) async {
  // we wait for the splash screen to be displayed
  await widgetTester.pump();
  await widgetTester.pumpAndSettle();

  // we start from the Splash screen
  expect(find.byType(SvgPicture), findsOneWidget);
  await widgetTester.pumpAndSettle(CustomDimensions.splashDuration);
}

///
Future<void> testCreateIdentity(WidgetTester widgetTester) async {
  // after tap on "create identity" button,
  // we expect to find identifier
  await widgetTester
      .tap(find.byKey(CustomWidgetsKeys.homeScreenButtonCreateIdentity));
  await widgetTester.pumpAndSettle(const Duration(seconds: 1));
  expect(
      find.text(CustomStrings.homeIdentifierSectionPlaceHolder), findsNothing);
}

///
Future<void> testClaims({
  required WidgetTester widgetTester,
  required GlobalKey<NavigatorState> key,
}) async {
  // then, we navigate to the claims list screen
  await widgetTester
      .tap(find.byKey(CustomWidgetsKeys.authScreenButtonNextAction));
  await widgetTester.pumpAndSettle(const Duration(seconds: 1));
  expect(find.text(CustomStrings.claimsDescription), findsOneWidget);
  expect(find.text(CustomStrings.claimsListNoResult), findsOneWidget);

  // then, we create a claim
  String claimId = await _getClaimIdFromApi();
  String claimIden3Message = await _getClaimIden3MessageFromApi(claimId);
  await widgetTester
      .tap(find.byKey(CustomWidgetsKeys.claimsScreenButtonConnect));
  await widgetTester.pumpAndSettle();
  key.currentState?.pop(claimIden3Message);
  await widgetTester.pumpAndSettle();

  // we expect to see the claim in the list
  await widgetTester.pumpAndSettle(const Duration(seconds: 3));
  expect(find.text(CustomStrings.claimsListNoResult), findsNothing);
  await widgetTester.pumpAndSettle();
}

/// Test authentication with verifier with existing identity and claims
Future<void> testAuthenticationWithVerifierKYCAgeSig({
  required WidgetTester widgetTester,
  required GlobalKey<NavigatorState> key,
}) async {
  Map<String, String> queryParams = {
    "type": "kycSig",
  };
  String iden3Message =
      await _getAuthenticationIden3MessageFromApi(queryParams: queryParams);
  await widgetTester.tap(find.byKey(CustomWidgetsKeys.authScreenButtonConnect));
  await widgetTester.pumpAndSettle();
  key.currentState?.pop(iden3Message);
  await widgetTester.pumpAndSettle();

  // with the iden3message scanned
  // we expect to authenticate succesfully
  await widgetTester.pumpAndSettle(const Duration(seconds: 3));
  expect(find.text(CustomStrings.authSuccess), findsOneWidget);
  await widgetTester.pumpAndSettle();
}

///
Future<void> _initCircuits() async {
  Completer completer = Completer();
  getIt<PolygonIdSdk>()
      .proof
      .initCircuitsDownloadAndGetInfoStream
      .then((value) => value.listen(
            (event) {
              if (event.completed) {
                completer.complete();
              }
            },
          ));

  return completer.future;
}

///
Future<String> _getAuthenticationIden3MessageFromApi({
  Map<String, String>? queryParams,
}) async {
  Uri uri = Uri.parse(
      "https://self-hosted-demo-backend-platform.polygonid.me/api/sign-in");

  //add query params
  if (queryParams != null) {
    uri = uri.replace(queryParameters: queryParams);
  }

  http.Response response = await http.get(
    uri,
    headers: {
      HttpHeaders.acceptHeader: '*/*',
      HttpHeaders.contentTypeHeader: 'application/json',
    },
  );
  return response.body;
}

///
Future<String> _getClaimIdFromApi() async {
  String username = IntegrationTestEnv.selfHostedPlatformUsername;
  String password = IntegrationTestEnv.selfHostedPlatformPassword;
  String issuerDid = IntegrationTestEnv.selfHostedPlatformIssuerDid;
  String? privateKey =
      await SecureStorage.read(key: SecureStorageKeys.privateKey);
  String walletDid = await getIt<PolygonIdSdk>().identity.getDidIdentifier(
      privateKey: privateKey!,
      blockchain: BlockchainResources.blockchain,
      network: BlockchainResources.network);

  Map<String, dynamic> claim = {
    "credentialSchema":
        "https://raw.githubusercontent.com/iden3/claim-schema-vocab/main/schemas/json/KYCAgeCredential-v3.json",
    "type": "KYCAgeCredential",
    "credentialSubject": {
      "id": walletDid,
      "birthday": 19960424,
      "documentType": 2
    },
    "expiration": 12345
  };

  final String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));

  Uri uri = Uri.parse("$_apiBaseUrl/$_apiVersion/$issuerDid/claims");

  http.Response response = await http.post(
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
Future<String> _getClaimIden3MessageFromApi(String claimId) async {
  String username = IntegrationTestEnv.selfHostedPlatformUsername;
  String password = IntegrationTestEnv.selfHostedPlatformPassword;
  String issuerDid = IntegrationTestEnv.selfHostedPlatformIssuerDid;

  final String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));

  Uri uri =
      Uri.parse("$_apiBaseUrl/$_apiVersion/$issuerDid/claims/$claimId/qrcode");

  http.Response response = await http.get(
    uri,
    headers: {
      HttpHeaders.authorizationHeader: basicAuth,
      HttpHeaders.acceptHeader: '*/*',
      HttpHeaders.contentTypeHeader: 'application/json',
    },
  );

  return response.body;
}
