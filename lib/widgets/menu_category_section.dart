import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart' as models;
import '../providers/order_provider.dart';

class MenuCategorySection extends StatelessWidget {
  const MenuCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    // Categories are static — use read() to avoid unnecessary rebuilds
    final provider = context.read<OrderProvider>();
    final categories = provider.categories;

    return Column(
      children: categories.map((category) {
        final items = provider.getItemsByCategory(category);
        return _CategoryAccordion(category: category, items: items);
      }).toList(),
    );
  }
}

class _CategoryAccordion extends StatelessWidget {
  final String category;
  final List<models.MenuItem> items;

  const _CategoryAccordion({required this.category, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF1B1B1B), width: 1.5),
          ),
          clipBehavior: Clip.hardEdge,
          child: ExpansionTile(
            initiallyExpanded: true,
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            backgroundColor: Colors.white,
            collapsedBackgroundColor: const Color(0xFFFBBF24),
            iconColor: const Color(0xFF1B1B1B),
            collapsedIconColor: const Color(0xFF1B1B1B),
            title: Text(
              category,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFFB80035),
                letterSpacing: 0.5,
              ),
            ),
            children: [...items.map((item) => _ProductCard(item: item))],
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final models.MenuItem item;

  const _ProductCard({required this.item});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.item.note);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quantity = context.select<OrderProvider, int>(
      (provider) => widget.item.quantity,
    );

    // Sync controller if note was cleared externally (e.g. decrement to 0)
    if (quantity == 0 && _noteController.text.isNotEmpty) {
      _noteController.clear();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1B1B1B), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + Price row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1B1B1B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.item.description,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF5C3F40),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '\$${widget.item.priceUsd.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1B1B1B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Quantity stepper
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _StepperButton(
                icon: Icons.remove,
                onPressed: () =>
                    context.read<OrderProvider>().decrementItem(widget.item),
              ),
              Container(
                width: 44,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF1B1B1B), width: 1),
                ),
                child: Text(
                  '$quantity',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B1B1B),
                  ),
                ),
              ),
              _StepperButton(
                icon: Icons.add,
                onPressed: () =>
                    context.read<OrderProvider>().incrementItem(widget.item),
              ),
            ],
          ),
          // Notes field — only visible when item is in the cart
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: quantity > 0
                ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextField(
                      controller: _noteController,
                      onChanged: (value) {
                        context
                            .read<OrderProvider>()
                            .setItemNote(widget.item, value);
                      },
                      style: const TextStyle(fontSize: 13),
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Notas: Ej. Sin cebolla, extra queso...',
                        hintStyle: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF906F70),
                        ),
                        prefixIcon: const Icon(
                          Icons.edit_note_rounded,
                          size: 20,
                          color: Color(0xFFB80035),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        isDense: true,
                        filled: true,
                        fillColor: const Color(0xFFFFF8E1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: Color(0xFFFBBF24),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: Color(0xFFFBBF24),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: Color(0xFFB80035),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _StepperButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFFBBF24),
            border: Border.all(color: const Color(0xFF1B1B1B), width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(icon, color: const Color(0xFFB80035), size: 22),
        ),
      ),
    );
  }
}
