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

import 'data/data_sources/remote_data_source.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  group('complete flow with live data', () {
    setUpAll(() async {
      await di.init();
      di.getIt.registerFactory<RemoteDataSource>(() => RemoteDataSource());
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
  RemoteDataSource remoteDataSource = RemoteDataSource();
  //  then by clicking on the "authentication" feature card,
  //  we expect to navigate to authentication page
  await widgetTester
      .tap(find.byKey(CustomWidgetsKeys.homeScreenFeatureCardAuthenticate));
  await widgetTester.pumpAndSettle(const Duration(seconds: 1));
  expect(find.text(CustomStrings.authDescription), findsOneWidget);
  await widgetTester.pumpAndSettle();

  // we simulate the qrCode scanning, we cannot mock it because
  // it change everytime and also it expire
  String iden3Message =
      await remoteDataSource.getAuthenticationIden3MessageFromApi();
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
  RemoteDataSource remoteDataSource = getIt.get<RemoteDataSource>();

  // then, we navigate to the claims list screen
  await widgetTester
      .tap(find.byKey(CustomWidgetsKeys.authScreenButtonNextAction));
  await widgetTester.pumpAndSettle(const Duration(seconds: 1));
  expect(find.text(CustomStrings.claimsDescription), findsOneWidget);
  expect(find.text(CustomStrings.claimsListNoResult), findsOneWidget);

  // then, we create a claim
  String claimId = await remoteDataSource.getClaimIdFromApi();
  String claimIden3Message =
      await remoteDataSource.getClaimIden3MessageFromApi(claimId);
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
  RemoteDataSource remoteDataSource = getIt.get<RemoteDataSource>();
  Map<String, String> queryParams = {
    "type": "kycSig",
  };
  String iden3Message =
      await remoteDataSource.getAuthenticationIden3MessageFromApi(queryParams: queryParams);
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
