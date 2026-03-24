import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final product = widget.product;

    final resolvedImageUrl = CommerceConfig.resolveImageUrl(product.imageUrl);
    final hasImage = resolvedImageUrl != null;
    final isOnPromo = product.isOnPromo;
    final popularity = product.popularity;
    final stock = product.stock;
    final isOutOfStock = stock != null && stock <= 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9), // Subtle grey-blue background
      body: Stack(
        children: [
          // 1. Large White Header with Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.52,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
              ),
              child: Center(
                child: Hero(
                  tag: 'product-hero-${product.id}',
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: hasImage
                        ? Image.network(
                            resolvedImageUrl,
                            fit: BoxFit.contain,
                            width: size.width * 0.75,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.broken_image,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                          )
                        : const Icon(
                            Icons.videocam,
                            size: 120,
                            color: Colors.grey,
                          ),
                  ),
                ),
              ),
            ),
          ),

          // 2. Decorative Side Badges (BPA Free, etc.)
          Positioned(
            top: size.height * 0.2,
            left: 25,
            child: Column(
              children: [
                _SideInfoItem(
                  icon: Icons.energy_savings_leaf_rounded,
                  label: "BPA free",
                ),
                const SizedBox(height: 25),
                _SideInfoItem(
                  icon: Icons.water_drop_outlined,
                  label: "100%\nLeak proof",
                ),
              ],
            ),
          ),

          // 3. Top Action Buttons (Explicitly positioned to avoid overlap)
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
                  icon: _isFavorited ? Icons.favorite : Icons.favorite_border,
                  iconColor: _isFavorited ? Colors.red : Colors.black87,
                  onTap: () => setState(() => _isFavorited = !_isFavorited),
                ),
              ],
            ),
          ),

          // 4. Content Card (Overlaying bottom of header)
          Positioned(
            top: size.height * 0.46,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 30,
                    offset: Offset(0, -10),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(30, 35, 30, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ratings Box
                  _RatingBox(popularity: popularity),
                  const SizedBox(height: 20),

                  // Product Title
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1D1E),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tags
                  Row(
                    children: [
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
                  const SizedBox(height: 25),

                  // Description Snippet
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 120),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15,
                            height: 1.6,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  product.description ??
                                  "No description available.",
                            ),
                            const TextSpan(
                              text: ' read more',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 5. Fixed Bottom Purchase Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 15, 30, 35),
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
                        Text(
                          '${product.effectivePrice.toStringAsFixed(2)} DZD',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1D1E),
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

                  // Quantity Selector
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F5F9),
                      borderRadius: BorderRadius.circular(15),
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
                            fontSize: 16,
                          ),
                        ),
                        _QtyAction(
                          icon: Icons.add,
                          onTap: () => setState(() => _quantity++),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),

                  // Cart Button
                  _CartFab(
                    onTap: isOutOfStock
                        ? null
                        : () {
                            final provider = context.read<CommerceProvider>();
                            for (int i = 0; i < _quantity; i++)
                              provider.addToCart(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.addedToCart(product.name)),
                              ),
                            );
                          },
                    isOutOfStock: isOutOfStock,
                  ),
                ],
              ),
            ),
          ),
        ],
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
    return GestureDetector(
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
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isOutOfStock ? Colors.grey : const Color(0xFF2B3044),
          borderRadius: BorderRadius.circular(18),
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
          size: 26,
        ),
      ),
    );
  }
}
