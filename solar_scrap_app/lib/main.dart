import 'package:flutter/material.dart';
import 'screens/role_selection_screen.dart';
import 'screens/buyer/buyer_dashboard_screen.dart';
import 'screens/buyer/buyer_account_created_screen.dart';
import 'screens/seller/seller_dashboard_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool isLoggedIn = await AuthService.instance.tryAutoLogin();
  runApp(MyApp(isLoggedIn: isLoggedIn));
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
    return MaterialApp(
      title: 'Solar Scrap',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00A63E),
          primary: const Color(0xFF00A63E),
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: _resolveInitialScreen(),
    );
  }
}
