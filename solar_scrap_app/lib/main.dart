import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'l10n/app_localizations.dart';
import 'screens/role_selection_screen.dart';
import 'screens/buyer/buyer_dashboard_screen.dart';
import 'screens/buyer/buyer_account_created_screen.dart';
import 'screens/seller/seller_dashboard_screen.dart';
import 'services/auth_service.dart';
import 'services/remote_config_service.dart';
import 'services/push_notification_service.dart';
import 'services/user_preferences_service.dart';
import 'services/locale_notifier.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }

  // Fast local storage reads (<10ms)
  await UserPreferencesService.instance.init();
  final bool isLoggedIn = await AuthService.instance.tryAutoLogin();

  // Mount UI immediately so the user never sees a delayed or black screen
  runApp(MyApp(isLoggedIn: isLoggedIn));

  // Initialize remote background services without blocking UI rendering
  RemoteConfigService.instance.init();
  PushNotificationService.instance.initialize();
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  Widget _resolveInitialScreen() {
    if (!isLoggedIn || !AuthService.instance.isAuthenticated) {
      return const RoleSelectionScreen();
    }

    final user = AuthService.instance.currentUser;
    final role = user?.role.toLowerCase() ?? '';

    if (role == 'buyer') {
      if (user != null && user.isPending) {
        return BuyerAccountCreatedScreen(
          companyName: user.companyName ?? 'Scrap Buyer Account',
          location: user.city ?? 'Registered Office',
          email: user.email,
          userId: user.userId,
        );
      }
      return const BuyerDashboardScreen();
    } else if (role == 'seller') {
      return const SellerDashboardScreen();
    }

    return const RoleSelectionScreen();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: LocaleNotifier.instance,
      builder: (context, locale, _) {
        return MaterialApp(
          title: 'Solar Scrap',
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF00A63E),
              primary: const Color(0xFF00A63E),
            ),
            scaffoldBackgroundColor: Colors.white,
            useMaterial3: true,
            fontFamily: locale.languageCode == 'ur'
                ? GoogleFonts.notoSansArabic().fontFamily
                : null,
          ),
          debugShowCheckedModeBanner: false,
          home: _resolveInitialScreen(),
        );
      },
    );
  }
}

