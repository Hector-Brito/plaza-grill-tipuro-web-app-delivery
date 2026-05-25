import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/order_provider.dart';
import 'widgets/header_section.dart';
import 'widgets/menu_category_section.dart';
import 'widgets/sauces_section.dart';
import 'widgets/checkout_section.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const PlazaGrillApp());
}

class PlazaGrillApp extends StatelessWidget {
  const PlazaGrillApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderProvider(),
      child: MaterialApp(
        title: 'Plaza Grill Tipuro',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: GoogleFonts.inter().fontFamily,
          textTheme: GoogleFonts.interTextTheme(),
          scaffoldBackgroundColor: const Color(0xFFF9F9F9),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFB80035),
            surface: const Color(0xFFF9F9F9),
          ),
        ),
        home: const MenuScreen(),
      ),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: const SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderSection(),
                  SizedBox(height: 16),
                  MenuCategorySection(),
                  SizedBox(height: 24),
                  SaucesSection(),
                  SizedBox(height: 24),
                  CheckoutSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
