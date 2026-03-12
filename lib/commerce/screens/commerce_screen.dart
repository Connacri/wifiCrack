import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_item.dart';
import '../models/cctv_product.dart';
import '../providers/commerce_provider.dart';
import '../services/commerce_service.dart';

class CommerceScreen extends StatelessWidget {
  final String? userId;

  const CommerceScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CommerceProvider(CommerceService())..loadProducts(),
      child: _CommerceView(userId: userId),
    );
  }
}

class _CommerceView extends StatefulWidget {
  final String? userId;

  const _CommerceView({this.userId});

  @override
  State<_CommerceView> createState() => _CommerceViewState();
}

class _CommerceViewState extends State<_CommerceView> {
  final _searchCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  bool _placingOrder = false;
  bool _openingProductForm = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitOrder(CommerceProvider provider) async {
    final phone = _phoneCtrl.text.trim();
    final address = _addressCtrl.text.trim();
    final note = _noteCtrl.text.trim();

    if (phone.isEmpty || address.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone and address are required.')),
      );
      return;
    }

    setState(() => _placingOrder = true);
    try {
      final orderId = await provider.placeOrder(
        phone: phone,
        address: address,
        note: note.isEmpty ? null : note,
        userId: widget.userId,
      );

      if (!mounted) return;
      if (orderId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order failed.')),
        );
        return;
      }

      _noteCtrl.clear();
      _phoneCtrl.clear();
      _addressCtrl.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order created: $orderId')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order failed.')),
      );
    } finally {
      if (mounted) setState(() => _placingOrder = false);
    }
  }

  Future<void> _openProductForm({
    required CommerceProvider provider,
    CctvProduct? product,
  }) async {
    if (_openingProductForm) return;
    _openingProductForm = true;
    final nameCtrl = TextEditingController(text: product?.name ?? '');
    final descCtrl = TextEditingController(text: product?.description ?? '');
    final priceCtrl = TextEditingController(
      text: product != null ? product.price.toStringAsFixed(2) : '',
    );
    final imageCtrl = TextEditingController(text: product?.imageUrl ?? '');
    final categoryCtrl = TextEditingController(text: product?.category ?? '');
    final stockCtrl =
        TextEditingController(text: product?.stock?.toString() ?? '');
    bool isActive = product?.isActive ?? true;
    bool saving = false;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          Future<void> onSave() async {
            final name = nameCtrl.text.trim();
            final price =
                double.tryParse(priceCtrl.text.trim().replaceAll(',', '.'));

            if (name.isEmpty || price == null) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Name and price are required.')),
              );
              return;
            }

            setSheetState(() => saving = true);
            final newProduct = CctvProduct(
              id: product?.id ?? '',
              name: name,
              description: descCtrl.text.trim().isEmpty
                  ? null
                  : descCtrl.text.trim(),
              price: price,
              imageUrl:
                  imageCtrl.text.trim().isEmpty ? null : imageCtrl.text.trim(),
              category: categoryCtrl.text.trim().isEmpty
                  ? null
                  : categoryCtrl.text.trim(),
              stock: stockCtrl.text.trim().isEmpty
                  ? null
                  : int.tryParse(stockCtrl.text.trim()),
              isActive: isActive,
            );

            final ok = await provider.saveProduct(newProduct);
            if (!mounted) return;

            setSheetState(() => saving = false);
            if (ok) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(product == null
                      ? 'Product created.'
                      : 'Product updated.'),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Save failed.')),
              );
            }
          }

          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product == null ? 'Add product' : 'Edit product',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: priceCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Price (DZD)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: imageCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Image URL',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: categoryCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: stockCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Stock',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: isActive,
                    title: const Text('Active'),
                    onChanged: (value) => setSheetState(() {
                      isActive = value;
                    }),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: saving ? null : onSave,
                      child: Text(saving ? 'Saving...' : 'Save'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    nameCtrl.dispose();
    descCtrl.dispose();
    priceCtrl.dispose();
    imageCtrl.dispose();
    categoryCtrl.dispose();
    stockCtrl.dispose();
    _openingProductForm = false;
  }

  Future<void> _confirmDelete(
    CommerceProvider provider,
    CctvProduct product,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete product'),
        content: Text('Delete "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (ok != true) return;
    final deleted = await provider.deleteProduct(product.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(deleted ? 'Product deleted.' : 'Delete failed.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommerceProvider>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CCTV Commerce'),
          actions: [
            IconButton(
              onPressed: provider.isLoading
                  ? null
                  : () => provider.loadProducts(query: _searchCtrl.text),
              icon: const Icon(Icons.refresh),
            ),
            IconButton(
              tooltip: 'Add product',
              onPressed: () => _openProductForm(provider: provider),
              icon: const Icon(Icons.add),
            ),
          ],
          bottom: TabBar(
            tabs: [
              const Tab(text: 'Products'),
              Tab(text: 'Cart (${provider.totalItems})'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ProductsTab(
              provider: provider,
              searchCtrl: _searchCtrl,
              includeInactive: provider.includeInactive,
              onToggleInactive: provider.setIncludeInactive,
              onAddProduct: () => _openProductForm(provider: provider),
              onEditProduct: (product) =>
                  _openProductForm(provider: provider, product: product),
              onDeleteProduct: (product) => _confirmDelete(provider, product),
            ),
            _CartTab(
              provider: provider,
              phoneCtrl: _phoneCtrl,
              addressCtrl: _addressCtrl,
              noteCtrl: _noteCtrl,
              placingOrder: _placingOrder,
              onSubmit: () => _submitOrder(provider),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductsTab extends StatelessWidget {
  final CommerceProvider provider;
  final TextEditingController searchCtrl;
  final bool includeInactive;
  final ValueChanged<bool> onToggleInactive;
  final VoidCallback onAddProduct;
  final ValueChanged<CctvProduct> onEditProduct;
  final ValueChanged<CctvProduct> onDeleteProduct;

  const _ProductsTab({
    required this.provider,
    required this.searchCtrl,
    required this.includeInactive,
    required this.onToggleInactive,
    required this.onAddProduct,
    required this.onEditProduct,
    required this.onDeleteProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: searchCtrl,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) =>
                provider.loadProducts(query: searchCtrl.text),
            decoration: InputDecoration(
              hintText: 'Search CCTV products',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () =>
                    provider.loadProducts(query: searchCtrl.text),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: includeInactive,
                  title: const Text('Show inactive'),
                  onChanged: onToggleInactive,
                ),
              ),
              FilledButton.icon(
                onPressed: onAddProduct,
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
            ],
          ),
        ),
        if (provider.isLoading)
          const Expanded(
            child: Center(child: CircularProgressIndicator()),
          )
        else if (provider.error != null)
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      provider.error!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () =>
                          provider.loadProducts(query: searchCtrl.text),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          )
        else if (provider.products.isEmpty)
          const Expanded(
            child: Center(child: Text('No products available.')),
          )
        else
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: provider.products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final product = provider.products[index];
                return _ProductCard(
                  product: product,
                  onAdd: () => provider.addToCart(product),
                  onEdit: () => onEditProduct(product),
                  onDelete: () => onDeleteProduct(product),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final CctvProduct product;
  final VoidCallback onAdd;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductCard({
    required this.product,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage =
        product.imageUrl != null && product.imageUrl!.trim().isNotEmpty;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.imageUrl!,
                  width: 86,
                  height: 86,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.videocam),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: theme.textTheme.titleMedium,
                  ),
                  if (product.description != null &&
                      product.description!.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        product.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _Tag(text: '${product.price.toStringAsFixed(2)} DZD'),
                      if (product.category != null &&
                          product.category!.trim().isNotEmpty)
                        _Tag(text: product.category!),
                      if (product.stock != null)
                        _Tag(text: 'Stock: ${product.stock}'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Add'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;

  const _Tag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}

class _CartTab extends StatelessWidget {
  final CommerceProvider provider;
  final TextEditingController phoneCtrl;
  final TextEditingController addressCtrl;
  final TextEditingController noteCtrl;
  final bool placingOrder;
  final VoidCallback onSubmit;

  const _CartTab({
    required this.provider,
    required this.phoneCtrl,
    required this.addressCtrl,
    required this.noteCtrl,
    required this.placingOrder,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    if (provider.cartItems.isEmpty) {
      return const Center(child: Text('Cart is empty.'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: provider.clearCart,
              icon: const Icon(Icons.delete_sweep),
              label: const Text('Clear cart'),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.cartItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = provider.cartItems[index];
              return _CartItemRow(
                item: item,
                onDecrement: () => provider.updateQuantity(
                  item.product.id,
                  item.quantity - 1,
                ),
                onIncrement: () => provider.updateQuantity(
                  item.product.id,
                  item.quantity + 1,
                ),
                onRemove: () => provider.removeFromCart(item.product.id),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Total: ${provider.total.toStringAsFixed(2)} DZD',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: addressCtrl,
            decoration: const InputDecoration(
              labelText: 'Address',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: noteCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Note (optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: placingOrder ? null : onSubmit,
              child: Text(placingOrder ? 'Placing order...' : 'Place order'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartItemRow({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.subtotal.toStringAsFixed(2)} DZD',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onDecrement,
              icon: const Icon(Icons.remove),
            ),
            Text(item.quantity.toString()),
            IconButton(
              onPressed: onIncrement,
              icon: const Icon(Icons.add),
            ),
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}
