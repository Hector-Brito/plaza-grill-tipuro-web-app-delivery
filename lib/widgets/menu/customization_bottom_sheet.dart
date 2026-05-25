import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:plaza_grill_tipuro/models/menu_item.dart';
import 'package:plaza_grill_tipuro/models/cart_item.dart';
import 'package:plaza_grill_tipuro/models/customization_option.dart';
import 'package:plaza_grill_tipuro/models/add_on_option.dart';
import 'package:plaza_grill_tipuro/providers/cart_provider.dart';
import 'package:plaza_grill_tipuro/widgets/shared/custom_snackbar.dart';
import 'package:plaza_grill_tipuro/config/theme.dart';
import 'package:plaza_grill_tipuro/widgets/menu/customization/protein_selector.dart';
import 'package:plaza_grill_tipuro/widgets/menu/customization/ingredient_remover.dart';
import 'package:plaza_grill_tipuro/widgets/menu/customization/extras_selector.dart';
import 'package:plaza_grill_tipuro/widgets/menu/customization/quantity_selector.dart';

class CustomizationBottomSheet extends StatefulWidget {
  final MenuItem item;

  const CustomizationBottomSheet({super.key, required this.item});

  static Future<void> show(BuildContext context, MenuItem item) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: CustomizationBottomSheet(item: item),
        ),
      ),
    );
  }

  @override
  State<CustomizationBottomSheet> createState() => _CustomizationBottomSheetState();
}

class _CustomizationBottomSheetState extends State<CustomizationBottomSheet> {
  int _quantity = 1;
  final TextEditingController _noteController = TextEditingController();

  // Clone options to avoid mutating the original catalog item
  late List<CustomizationOption> _removableIngredients;
  late List<AddOnOption> _availableExtras;
  late List<AddOnOption> _availableProteins;
  AddOnOption? _selectedProtein;

  @override
  void initState() {
    super.initState();
    _removableIngredients = widget.item.removableIngredients
        .map(
          (e) => CustomizationOption(
            id: e.id,
            name: e.name,
            isRemoved: e.isRemoved,
          ),
        )
        .toList();
    _availableExtras = widget.item.availableExtras
        .map(
          (e) => AddOnOption(
            id: e.id,
            name: e.name,
            price: e.price,
            isSelected: e.isSelected,
          ),
        )
        .toList();
    _availableProteins = widget.item.availableProteins
        .map(
          (e) => AddOnOption(
            id: e.id,
            name: e.name,
            price: e.price,
            isSelected: e.isSelected,
          ),
        )
        .toList();
  }

  Future<void> _showQuantityDialog() async {
    final controller = TextEditingController(text: _quantity.toString());
    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cantidad', style: TextStyle(fontWeight: FontWeight.w800, color: AppTheme.darkText)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppTheme.primaryRed)),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: AppTheme.primaryRed)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryRed, foregroundColor: Colors.white),
            onPressed: () {
              final val = int.tryParse(controller.text);
              Navigator.pop(context, val);
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
    if (result != null && result > 0) {
      setState(() {
        _quantity = result;
      });
    }
  }

  void _addToCart() {
    if (widget.item.requiresProtein &&
        _selectedProtein == null &&
        _availableProteins.isNotEmpty) {
      CustomSnackBar.showError(context, 'Por favor, selecciona una proteína');
      return;
    }

    final cartItem = CartItem(
      cartItemId: const Uuid().v4(),
      menuItem: widget.item,
      quantity: _quantity,
      specialNote: _noteController.text,
      removedIngredients: _removableIngredients
          .where((e) => e.isRemoved)
          .toList(),
      selectedExtras: _availableExtras.where((e) => e.isSelected).toList(),
      selectedProtein: _selectedProtein,
    );

    context.read<CartProvider>().addToCart(cartItem);
    Navigator.pop(context);
    CustomSnackBar.showSuccess(context, '${widget.item.name} agregado al carrito');
  }

  @override
  Widget build(BuildContext context) {
    final cartItemDraft = CartItem(
      cartItemId: '',
      menuItem: widget.item,
      quantity: _quantity,
      removedIngredients: _removableIngredients.where((e) => e.isRemoved).toList(),
      selectedExtras: _availableExtras.where((e) => e.isSelected).toList(),
      selectedProtein: _selectedProtein,
    );

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Personalizar ${widget.item.name}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryRed,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppTheme.darkText),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(color: Color(0xFFE5E5E5), thickness: 1.5),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  if (widget.item.requiresProtein && _availableProteins.isNotEmpty) ...[
                    ProteinSelector(
                      title: widget.item.categoryId == '46d3742f' ? 'ELIGE TU SABOR' : 'ELIGE TU PROTEÍNA',
                      options: _availableProteins,
                      selectedOption: _selectedProtein,
                      onChanged: (value) => setState(() => _selectedProtein = value),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (_removableIngredients.isNotEmpty) ...[
                    IngredientRemover(
                      ingredients: _removableIngredients,
                      onChanged: (option, isRemoved) => setState(() => option.isRemoved = isRemoved),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (_availableExtras.isNotEmpty) ...[
                    ExtrasSelector(
                      extras: _availableExtras,
                      onChanged: (option, isSelected) => setState(() => option.isSelected = isSelected),
                    ),
                    const SizedBox(height: 20),
                  ],
                  const Text(
                    'NOTA ESPECIAL',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: AppTheme.darkText,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      hintText: 'Ej. Bien cocida, sin sal...',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.hintText,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.primaryRed),
                      ),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),
                  QuantitySelector(
                    quantity: _quantity,
                    onIncrement: () => setState(() => _quantity++),
                    onDecrement: () {
                      if (_quantity > 1) setState(() => _quantity--);
                    },
                    onTapQuantity: _showQuantityDialog,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _addToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                'AGREGAR AL PEDIDO (\$${cartItemDraft.totalPrice.toStringAsFixed(2)})',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
