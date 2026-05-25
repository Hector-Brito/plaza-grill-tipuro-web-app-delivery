import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plaza_grill_tipuro/providers/menu_provider.dart';
import 'package:plaza_grill_tipuro/providers/cart_provider.dart';
import 'package:plaza_grill_tipuro/providers/payment_provider.dart';
import 'package:plaza_grill_tipuro/screens/menu_screen.dart';

import 'package:plaza_grill_tipuro/config/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const PlazaGrillApp());
}

class PlazaGrillApp extends StatelessWidget {
  const PlazaGrillApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
      ],
      child: MaterialApp(
        title: 'Plaza Grill Tipuro',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MenuScreen(),
      ),
    );
  }
}

