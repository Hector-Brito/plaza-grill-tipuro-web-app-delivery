import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plaza_grill_tipuro/providers/menu_provider.dart';
import 'package:plaza_grill_tipuro/widgets/menu/header_section.dart';
import 'package:plaza_grill_tipuro/widgets/menu/menu_category_section.dart';
import 'package:plaza_grill_tipuro/widgets/menu/checkout_section.dart';

import 'package:plaza_grill_tipuro/config/theme.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MenuProvider>(context, listen: false).loadMenuFromAppSheet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 768;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 1000 : 480,
            ),
            child: Consumer<MenuProvider>(
              builder: (context, menuProvider, child) {
                if (menuProvider.isLoadingMenu) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (menuProvider.hasMenuError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Error al cargar el menú"),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => menuProvider.loadMenuFromAppSheet(),
                          child: const Text("Reintentar"),
                        ),
                      ],
                    ),
                  );
                }

                if (isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Catálogo
                      const Expanded(
                        flex: 6,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HeaderSection(),
                              SizedBox(height: 16),
                              MenuCategorySection(),
                              KioskoSection(),
                              SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                      // Divisor vertical
                      Container(
                        width: 1.5,
                        color: AppTheme.darkText,
                      ),
                      // Resumen de Orden
                      const Expanded(
                        flex: 4,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 16),
                              CheckoutSection(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderSection(),
                        SizedBox(height: 16),
                        MenuCategorySection(),
                        KioskoSection(),
                        SizedBox(height: 24),
                        CheckoutSection(),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
