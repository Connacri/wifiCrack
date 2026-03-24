import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../l10n/app_localizations.dart';
import '../commerce_config.dart';
import '../models/product.dart';
import '../providers/commerce_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommerceProvider>();
    // Look for the product in the provider's list to get the latest favorite state
    final productInList = provider.products.cast<Product?>().firstWhere(
      (p) => p?.id == widget.product.id,
      orElse: () => null,
    );
    final product = productInList ?? widget.product;
    final isFavorited = product.isFavorite;

    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;

    final resolvedImageUrl = CommerceConfig.resolveImageUrl(product.imageUrl);
    final hasImage = resolvedImageUrl != null;
    final isOnPromo = product.isOnPromo;
    final popularity = product.popularity;
    final stock = product.stock;
    final isOutOfStock = stock != null && stock <= 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9), // Subtle grey-blue background
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(28, 14, 28, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Price Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${product.effectivePrice.toStringAsFixed(2)} DZD',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1D1E),
                      ),
                    ),
                  ),
                  if (isOnPromo)
                    Text(
                      '${product.price.toStringAsFixed(2)} DZD',
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Quantity Selector
            Container(
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _QtyAction(
                    icon: Icons.remove,
                    onTap: () => setState(
                      () => _quantity = _quantity > 1 ? _quantity - 1 : 1,
                    ),
                  ),
                  Text(
                    _quantity.toString().padLeft(2, '0'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _QtyAction(
                    icon: Icons.add,
                    onTap: () => setState(() => _quantity++),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Cart Button
            _CartFab(
              onTap: isOutOfStock
                  ? null
                  : () {
                      final provider = context.read<CommerceProvider>();
                      for (int i = 0; i < _quantity; i++)
                        provider.addToCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.addedToCart(product.name))),
                      );
                    },
              isOutOfStock: isOutOfStock,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. Large White Header with Image
            SliverToBoxAdapter(
              child: SizedBox(
                height: size.height * 0.52,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(40),
                          ),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Hero(
                          tag: 'product-hero-${product.id}',
                          child: hasImage
                              ? Image.network(
                                  resolvedImageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 100,
                                          color: Colors.grey,
                                        ),
                                      ),
                                )
                              : const Center(
                                  child: Icon(
                                    Icons.videocam,
                                    size: 120,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    // 2. Decorative Side Badges (BPA Free, etc.)
                    Positioned(
                      top: size.height * 0.2,
                      left: 22,
                      child: Column(
                        children: const [
                          _SideInfoItem(
                            icon: Icons.energy_savings_leaf_rounded,
                            label: "BPA free",
                          ),
                          SizedBox(height: 22),
                          _SideInfoItem(
                            icon: Icons.water_drop_outlined,
                            label: "100%\nLeak proof",
                          ),
                        ],
                      ),
                    ),

                    // 2.5 Right color dots
                    Positioned(
                      top: size.height * 0.24,
                      right: 22,
                      child: Column(
                        children: const [
                          _ColorDot(color: Color(0xFF1A1D1E)),
                          SizedBox(height: 10),
                          _ColorDot(color: Color(0xFF9099A6)),
                          SizedBox(height: 10),
                          _ColorDot(color: Color(0xFFE7A16B)),
                          SizedBox(height: 10),
                          _ColorDot(color: Color(0xFFB15DD8)),
                        ],
                      ),
                    ),

                    // 3. Top Action Buttons
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 10,
                      left: 20,
                      right: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _RoundBtn(
                            icon: Icons.arrow_back_ios_new,
                            onTap: () => Navigator.pop(context),
                          ),
                          _RoundBtn(
                            icon: isFavorited
                                ? Icons.favorite
                                : Icons.favorite_border,
                            iconColor: isFavorited
                                ? Colors.red
                                : Colors.black87,
                            onTap: () => provider.toggleFavorite(product.id),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 4. Content Card using SliverList for smooth scrolling
            SliverList(
              delegate: SliverChildListDelegate([
                Transform.translate(
                  offset: const Offset(0, -24),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 30,
                          offset: Offset(0, -10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(26, 32, 26, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _RatingBox(popularity: popularity),
                        const SizedBox(height: 20),
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1D1E),
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _CompactBadge(
                              label: l10n.bestSeller,
                              color: const Color(0xFF49B3E4),
                            ),
                            const SizedBox(width: 8),
                            _CompactBadge(
                              label: product.category ?? "General",
                              color: const Color(0xFF67C2E9),
                            ),
                            if (isOnPromo) ...[
                              const SizedBox(width: 8),
                              _CompactBadge(
                                label: l10n.promoStatus.toUpperCase(),
                                color: Colors.pinkAccent,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 18),
                        ReadMoreText(
                          product.description ?? "No description available.",
                          trimLines: 3,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: ' ${l10n.readMore}',
                          trimExpandedText: ' ${l10n.showLess}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            height: 1.6,
                          ),
                          moreStyle: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          lessStyle: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),

            // Bottom spacing to avoid overlap with the purchase bar
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _SideInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SideInfoItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.black54, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

class _RoundBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;
  const _RoundBtn({
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: iconColor),
      ),
    );
  }
}

class _RatingBox extends StatelessWidget {
  final int popularity;
  const _RatingBox({required this.popularity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            popularity > 0 ? '$popularity' : '4.5',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.star, color: Colors.amber, size: 16),
          const SizedBox(width: 10),
          const Text('|', style: TextStyle(color: Colors.black12)),
          const SizedBox(width: 10),
          const Text(
            'Ratings >',
            style: TextStyle(fontSize: 12, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}

class _CompactBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _CompactBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _QtyAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Icon(icon, size: 16, color: Colors.black54),
      ),
    );
  }
}

class _CartFab extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isOutOfStock;
  const _CartFab({this.onTap, required this.isOutOfStock});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isOutOfStock ? Colors.grey : const Color(0xFF2B3044),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.shopping_cart_outlined,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  const _ColorDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}
