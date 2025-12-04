import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meshal_doctor_booking_app/core/router/app_router.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/di/service_locator.dart';
import 'package:meshal_doctor_booking_app/firebase_options.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/providers/app_bloc_providers.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/features/localization/localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

String? globalFcmToken;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  // Hive Initialization
  await Hive.initFlutter();

  // Service Locator
  setUpServiceLocators();

  // Lock orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize FCM (APNs + FCM)
  await initializeFCM();

  runApp(const MyApp());
}

Future<void> initializeFCM() async {
  final messaging = FirebaseMessaging.instance;

  // Permission for iOS
  await messaging.requestPermission(alert: true, badge: true, sound: true);

  if (Platform.isIOS) {
    String? apnsToken;
    int retries = 0;

    // Wait until APNs token is ready
    while (apnsToken == null && retries < 10) {
      await Future.delayed(const Duration(milliseconds: 500));
      apnsToken = await messaging.getAPNSToken();
      retries++;
    }

    AppLoggerHelper.logInfo("🍎 APNS Token: $apnsToken");
  }

  // Now get FCM token safely
  globalFcmToken = await messaging.getToken();
  AppLoggerHelper.logInfo("🔥 FCM Token: $globalFcmToken");

  // Refresh listener
  FirebaseMessaging.instance.onTokenRefresh.listen((token) {
    globalFcmToken = token;
    AppLoggerHelper.logInfo("♻️ FCM Token refreshed: $token");
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // App Bloc Providers
      providers: appBlocProviders,

      child: BlocBuilder<LocalizationCubit, LocalizationState>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: "Doctor Meshal App",

            // Localization
            locale: state is LocalizationSelected
                ? Locale(state.selectedLanguage)
                : const Locale("en"),
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],

            // Themes
            theme: ThemeData(
              fontFamily: 'OpenSans',
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColorConstants.primaryColor,
              ),
            ),

            // Router
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
