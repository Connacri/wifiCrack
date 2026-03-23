import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../commerce_config.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final resolvedImageUrl = CommerceConfig.resolveImageUrl(product.imageUrl);
    final price = product.effectivePrice;
    final promo = product.promoPrice;
    final hasPromo = promo != null && promo > 0 && promo < product.price;
    final stock = product.stock;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeroImage(resolvedImageUrl),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${price.toStringAsFixed(2)} DZD',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (hasPromo) ...[
                        const SizedBox(width: 12),
                        Text(
                          product.price.toStringAsFixed(2) + ' DZD',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color:
                                    Theme.of(context).colorScheme.onSurface.withAlpha(120),
                              ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (product.description != null && product.description!.isNotEmpty)
                    Text(
                      product.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    children: [
                      Chip(
                        label: Text(
                          stock == null
                              ? l10n.stockUnknown
                              : stock > 0
                                  ? '${l10n.stockLabel}: $stock'
                                  : l10n.outOfStockStatus,
                        ),
                      ),
                      if (product.category != null && product.category!.isNotEmpty)
                        Chip(label: Text(product.category!)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: Text(l10n.addToCart),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImage(String? url) {
    const heroTag = 'product-hero-';
    return Hero(
      tag: '$heroTag${product.id}',
      child: SizedBox(
        height: 280,
        child: url != null
            ? Image.network(
                url,
                fit: BoxFit.cover,
                width: double.infinity,
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              )
            : Container(
                color: Colors.grey,
                child: const Center(child: Icon(Icons.videocam, size: 64)),
              ),
      ),
    );
  }
}
