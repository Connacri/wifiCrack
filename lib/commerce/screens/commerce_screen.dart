import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../commerce_config.dart';
import '../models/cart_item.dart';
import '../models/commerce_enums.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../providers/commerce_provider.dart';
import '../services/commerce_service.dart';
import 'order_details_screen.dart';
import 'product_detail_screen.dart';

enum ProductSort {
  nameAsc,
  priceAsc,
  priceDesc,
  stockAsc,
  stockDesc,
  popularityDesc,
}

enum OrderSort { dateDesc, dateAsc, totalDesc, totalAsc }

void _openDetail(BuildContext context, Product product) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
  );
}

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
  bool _isAdminMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _refreshOrders();
    });
  }

  void _refreshOrders() {
    final provider = context.read<CommerceProvider>();
    // If not admin, only load orders for current userId
    final filterUserId = _isAdminMode ? null : widget.userId;
    provider.loadOrders(userId: filterUserId, reset: true);
  }

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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Order failed.')));
        return;
      }

      _noteCtrl.clear();
      _phoneCtrl.clear();
      _addressCtrl.clear();

      final message = orderId.trim().isEmpty
          ? 'Order created.'
          : 'Order created: $orderId';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Order failed.')));
    } finally {
      if (mounted) setState(() => _placingOrder = false);
    }
  }

  Future<void> _openProductForm({
    required CommerceProvider provider,
    Product? product,
  }) async {
    if (_openingProductForm) return;
    _openingProductForm = true;
    final isNew = product == null;
    try {
      final saved = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        builder: (context) =>
            _ProductFormSheet(provider: provider, product: product),
      );

      if (!mounted) return;
      if (saved == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isNew ? 'Product created.' : 'Product updated.'),
          ),
        );
      }
    } finally {
      _openingProductForm = false;
    }
  }

  Future<void> _confirmDelete(
    CommerceProvider provider,
    Product product,
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
      SnackBar(content: Text(deleted ? 'Product deleted.' : 'Delete failed.')),
    );
  }

  void _toggleAdminMode(CommerceProvider provider) {
    setState(() => _isAdminMode = !_isAdminMode);
    _refreshOrders();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommerceProvider>();

    final tabs = <Tab>[
      const Tab(text: 'Products'),
      const Tab(text: 'Orders'),
      Tab(text: 'Cart (${provider.totalItems})'),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Commerce'),
              actions: [
                IconButton(
                  onPressed: provider.isLoading
                      ? null
                      : () => provider.loadProducts(query: _searchCtrl.text),
                  icon: const Icon(Icons.refresh),
                ),
                IconButton(
                  tooltip: _isAdminMode ? 'Client mode' : 'Admin mode',
                  icon: Icon(
                    _isAdminMode
                        ? Icons.admin_panel_settings
                        : Icons.person_outline,
                  ),
                  onPressed: () => _toggleAdminMode(provider),
                ),
                if (_isAdminMode)
                  IconButton(
                    tooltip: 'Add product',
                    onPressed: () => _openProductForm(provider: provider),
                    icon: const Icon(Icons.add),
                  ),
              ],
              bottom: TabBar(tabs: tabs),
            ),
            body: TabBarView(
              children: [
                _ProductsTab(
                  provider: provider,
                  searchCtrl: _searchCtrl,
                  includeInactive: provider.includeInactive,
                  onToggleInactive: provider.setIncludeInactive,
                  onAddProduct: _isAdminMode
                      ? () => _openProductForm(provider: provider)
                      : null,
                  onEditProduct: _isAdminMode
                      ? (product) => _openProductForm(
                          provider: provider,
                          product: product,
                        )
                      : null,
                  onDeleteProduct: _isAdminMode
                      ? (product) => _confirmDelete(provider, product)
                      : null,
                  isAdmin: _isAdminMode,
                ),
                _OrdersTab(
                  provider: provider,
                  onRefresh: () => provider.loadOrders(reset: true),
                  onLoadMore: provider.loadMoreOrders,
                  onUpdateStatus: provider.updateOrderStatus,
                  isUpdating: provider.isUpdatingOrder,
                  canUpdateStatus: _isAdminMode,
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
            bottomNavigationBar: _buildCartBar(
              context,
              tabController,
              provider,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCartBar(
    BuildContext context,
    TabController controller,
    CommerceProvider provider,
  ) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final show = controller.index == 0 && provider.totalItems > 0;
        if (!show) return const SizedBox.shrink();
        const cartIndex = 2;

        return SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${provider.totalItems} items',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Text(
                        'Total ${provider.total.toStringAsFixed(2)} DZD',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed: () => controller.animateTo(cartIndex),
                  child: const Text('Commander'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProductsTab extends StatefulWidget {
  final CommerceProvider provider;
  final TextEditingController searchCtrl;
  final bool includeInactive;
  final ValueChanged<bool> onToggleInactive;
  final VoidCallback? onAddProduct;
  final ValueChanged<Product>? onEditProduct;
  final ValueChanged<Product>? onDeleteProduct;
  final bool isAdmin;

  const _ProductsTab({
    required this.provider,
    required this.searchCtrl,
    required this.includeInactive,
    required this.onToggleInactive,
    required this.onAddProduct,
    required this.onEditProduct,
    required this.onDeleteProduct,
    required this.isAdmin,
  });

  @override
  State<_ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends State<_ProductsTab> {
  String _selectedCategory = 'All';
  bool _inStockOnly = false;
  ProductSort _sort = ProductSort.nameAsc;
  bool _gridView = false;
  late final ScrollController _scrollCtrl;

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollCtrl.hasClients) return;
    final position = _scrollCtrl.position;
    if (position.maxScrollExtent - position.pixels <= 320) {
      widget.provider.loadMoreProducts();
    }
  }

  List<String> _extractCategories(List<Product> products) {
    final categories = <String>{};
    for (final product in products) {
      final category = product.category?.trim();
      if (category != null && category.isNotEmpty) {
        categories.add(category);
      }
    }
    final list = categories.toList()..sort();
    return ['All', ...list];
  }

  List<Product> _applyFilters(List<Product> products, String activeCategory) {
    var filtered = products;

    if (activeCategory != 'All') {
      filtered = filtered
          .where((p) => (p.category ?? '').trim() == activeCategory)
          .toList();
    }

    if (_inStockOnly) {
      filtered = filtered
          .where((p) => p.stock == null || p.stock! > 0)
          .toList();
    }

    filtered.sort((a, b) {
      switch (_sort) {
        case ProductSort.priceAsc:
          return a.effectivePrice.compareTo(b.effectivePrice);
        case ProductSort.priceDesc:
          return b.effectivePrice.compareTo(a.effectivePrice);
        case ProductSort.stockAsc:
          return (a.stock ?? 0).compareTo(b.stock ?? 0);
        case ProductSort.stockDesc:
          return (b.stock ?? 0).compareTo(a.stock ?? 0);
        case ProductSort.popularityDesc:
          return b.popularity.compareTo(a.popularity);
        case ProductSort.nameAsc:
        default:
          return a.name.compareTo(b.name);
      }
    });

    return filtered;
  }

  String _sortLabel(ProductSort sort) {
    switch (sort) {
      case ProductSort.priceAsc:
        return 'Price ↑';
      case ProductSort.priceDesc:
        return 'Price ↓';
      case ProductSort.stockAsc:
        return 'Stock ↑';
      case ProductSort.stockDesc:
        return 'Stock ↓';
      case ProductSort.popularityDesc:
        return 'Popularity';
      case ProductSort.nameAsc:
      default:
        return 'Name';
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = _extractCategories(widget.provider.products);
    final activeCategory = categories.contains(_selectedCategory)
        ? _selectedCategory
        : 'All';
    final products = _applyFilters(widget.provider.products, activeCategory);
    _maybeAutoFetchMore(products);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: widget.searchCtrl,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) =>
                widget.provider.loadProducts(query: widget.searchCtrl.text),
            decoration: InputDecoration(
              hintText: 'Search products or SKU',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () =>
                    widget.provider.loadProducts(query: widget.searchCtrl.text),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        if (categories.length > 1)
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ChoiceChip(
                  label: Text(category),
                  selected: activeCategory == category,
                  onSelected: (_) =>
                      setState(() => _selectedCategory = category),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: categories.length,
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: const Text('In stock'),
                selected: _inStockOnly,
                onSelected: (value) => setState(() => _inStockOnly = value),
              ),
              if (widget.isAdmin)
                FilterChip(
                  label: const Text('Include inactive'),
                  selected: widget.includeInactive,
                  onSelected: widget.onToggleInactive,
                ),
              PopupMenuButton<ProductSort>(
                initialValue: _sort,
                onSelected: (value) => setState(() => _sort = value),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: ProductSort.nameAsc,
                    child: Text('Name'),
                  ),
                  const PopupMenuItem(
                    value: ProductSort.priceAsc,
                    child: Text('Price low-high'),
                  ),
                  const PopupMenuItem(
                    value: ProductSort.priceDesc,
                    child: Text('Price high-low'),
                  ),
                  const PopupMenuItem(
                    value: ProductSort.stockAsc,
                    child: Text('Stock low-high'),
                  ),
                  const PopupMenuItem(
                    value: ProductSort.stockDesc,
                    child: Text('Stock high-low'),
                  ),
                  const PopupMenuItem(
                    value: ProductSort.popularityDesc,
                    child: Text('Popularity'),
                  ),
                ],
                child: _FilterPill(icon: Icons.sort, label: _sortLabel(_sort)),
              ),
              if (widget.isAdmin && widget.onAddProduct != null)
                FilledButton.icon(
                  onPressed: widget.onAddProduct,
                  icon: const Icon(Icons.add),
                  label: const Text('Add product'),
                ),
              _FilterPill(
                icon: _gridView ? Icons.view_list : Icons.grid_view,
                label: _gridView ? 'List' : 'Grid',
                onTap: () => setState(() => _gridView = !_gridView),
              ),
            ],
          ),
        ),
        if (widget.provider.isLoading)
          const Expanded(child: _ProductSkeletonList())
        else if (widget.provider.error != null)
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 12),
                    Text(widget.provider.error!, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => widget.provider.loadProducts(
                        query: widget.searchCtrl.text,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          )
        else if (products.isEmpty)
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.inventory_2_outlined, size: 48),
                    const SizedBox(height: 12),
                    const Text(
                      'No products match your filters.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => setState(() {
                        _selectedCategory = 'All';
                        _inStockOnly = false;
                        _sort = ProductSort.nameAsc;
                      }),
                      child: const Text('Clear filters'),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          Expanded(
            child: _gridView
                ? _ProductGrid(
                    controller: _scrollCtrl,
                    products: products,
                    isAdmin: widget.isAdmin,
                    onAdd: (product) => widget.provider.addToCart(product),
                    onEdit: widget.onEditProduct,
                    onDelete: widget.onDeleteProduct,
                    isLoadingMore: widget.provider.isLoadingMore,
                    hasMore: widget.provider.productsHasMore,
                  )
                : _ProductList(
                    controller: _scrollCtrl,
                    products: products,
                    isAdmin: widget.isAdmin,
                    onAdd: (product) => widget.provider.addToCart(product),
                    onEdit: widget.onEditProduct,
                    onDelete: widget.onDeleteProduct,
                    isLoadingMore: widget.provider.isLoadingMore,
                    hasMore: widget.provider.productsHasMore,
                  ),
          ),
      ],
    );
  }

  void _maybeAutoFetchMore(List<Product> products) {
    if (!widget.provider.productsHasMore ||
        widget.provider.isLoading ||
        widget.provider.isLoadingMore) {
      return;
    }
    if (products.length < 8) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.provider.loadMoreProducts();
      });
    }
  }
}

class _ProductFormSheet extends StatefulWidget {
  final CommerceProvider provider;
  final Product? product;

  const _ProductFormSheet({required this.provider, this.product});

  @override
  State<_ProductFormSheet> createState() => _ProductFormSheetState();
}

class _ProductList extends StatelessWidget {
  final ScrollController controller;
  final List<Product> products;
  final bool isAdmin;
  final ValueChanged<Product> onAdd;
  final ValueChanged<Product>? onEdit;
  final ValueChanged<Product>? onDelete;
  final bool isLoadingMore;
  final bool hasMore;

  const _ProductList({
    required this.controller,
    required this.products,
    required this.isAdmin,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    required this.isLoadingMore,
    required this.hasMore,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: products.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        if (index >= products.length) {
          if (isLoadingMore) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (!hasMore) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'All products loaded.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            );
          }
          return const SizedBox.shrink();
        }

        final product = products[index];
        return _ProductCard(
          product: product,
          isAdmin: isAdmin,
          onAdd: () => onAdd(product),
          onEdit: onEdit == null ? null : () => onEdit!(product),
          onDelete: onDelete == null ? null : () => onDelete!(product),
        );
      },
    );
  }
}

class _ProductGrid extends StatelessWidget {
  final ScrollController controller;
  final List<Product> products;
  final bool isAdmin;
  final ValueChanged<Product> onAdd;
  final ValueChanged<Product>? onEdit;
  final ValueChanged<Product>? onDelete;
  final bool isLoadingMore;
  final bool hasMore;

  const _ProductGrid({
    required this.controller,
    required this.products,
    required this.isAdmin,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    required this.isLoadingMore,
    required this.hasMore,
  });

  int _crossAxisCount(double width) {
    if (width >= 1100) return 4;
    if (width >= 800) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final count = _crossAxisCount(width);
    final totalItems = products.length + 1;

    return GridView.builder(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: count,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: totalItems,
      itemBuilder: (context, index) {
        if (index >= products.length) {
          if (isLoadingMore) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!hasMore) {
            return Center(
              child: Text(
                'All products loaded.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            );
          }
          return const SizedBox.shrink();
        }

        final product = products[index];
        return _ProductGridCard(
          product: product,
          isAdmin: isAdmin,
          onAdd: () => onAdd(product),
          onEdit: onEdit == null ? null : () => onEdit!(product),
          onDelete: onDelete == null ? null : () => onDelete!(product),
        );
      },
    );
  }
}

class _ProductFormSheetState extends State<_ProductFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _skuCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _promoCtrl;
  late final TextEditingController _imageCtrl;
  late final TextEditingController _categoryCtrl;
  late final TextEditingController _stockCtrl;
  late final TextEditingController _popularityCtrl;
  late bool _isActive;
  bool _saving = false;
  bool _uploadingImage = false;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _nameCtrl = TextEditingController(text: product?.name ?? '');
    _skuCtrl = TextEditingController(text: product?.sku ?? '');
    _descCtrl = TextEditingController(text: product?.description ?? '');
    _priceCtrl = TextEditingController(
      text: product != null ? product.price.toStringAsFixed(2) : '',
    );
    _promoCtrl = TextEditingController(
      text: product?.promoPrice != null
          ? product!.promoPrice!.toStringAsFixed(2)
          : '',
    );
    _imageCtrl = TextEditingController(text: product?.imageUrl ?? '');
    _categoryCtrl = TextEditingController(text: product?.category ?? '');
    _stockCtrl = TextEditingController(text: product?.stock?.toString() ?? '');
    _popularityCtrl = TextEditingController(
      text: product == null ? '' : product.popularity.toString(),
    );
    _isActive = product?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _skuCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _promoCtrl.dispose();
    _imageCtrl.dispose();
    _categoryCtrl.dispose();
    _stockCtrl.dispose();
    _popularityCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the form errors.')),
      );
      return;
    }
    final name = _nameCtrl.text.trim();
    final price = double.parse(_priceCtrl.text.trim().replaceAll(',', '.'));
    final promoText = _promoCtrl.text.trim();
    final promoPrice = promoText.isEmpty
        ? null
        : double.parse(promoText.replaceAll(',', '.'));
    final rawSku = _skuCtrl.text.trim();
    final sku = rawSku.isEmpty ? null : rawSku;
    final popularityText = _popularityCtrl.text.trim();
    final popularity = popularityText.isEmpty
        ? 0
        : int.tryParse(popularityText) ?? 0;

    setState(() => _saving = true);
    debugPrint(
      '[Commerce] Attempting to save product: ${name} (ID: ${widget.product?.id ?? "new"})',
    );
    final product = Product(
      id: widget.product?.id ?? '',
      name: name,
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      price: price,
      promoPrice: promoPrice,
      sku: sku,
      imageUrl: _imageCtrl.text.trim().isEmpty ? null : _imageCtrl.text.trim(),
      category: _categoryCtrl.text.trim().isEmpty
          ? null
          : _categoryCtrl.text.trim(),
      stock: _stockCtrl.text.trim().isEmpty
          ? null
          : int.tryParse(_stockCtrl.text.trim()),
      popularity: popularity,
      isActive: _isActive,
    );

    debugPrint(
      '[Commerce] Product data to map: ${product.toMap(includeId: true)}',
    );
    final ok = await widget.provider.saveProduct(product);
    if (!mounted) return;

    setState(() => _saving = false);
    if (ok) {
      debugPrint('[Commerce] Product saved successfully.');
      Navigator.pop(context, true);
    } else {
      debugPrint('[Commerce] Product save FAILED.');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Save failed.')));
    }
  }

  Future<void> _pickAndUploadImage() async {
    if (_uploadingImage) return;
    final bucket = CommerceConfig.supabaseImagesBucket.trim();
    debugPrint('[Commerce] Starting image pick. Bucket: "$bucket"');

    if (bucket.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Supabase image bucket is not configured.'),
        ),
      );
      return;
    }

    setState(() => _uploadingImage = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (result == null || result.files.isEmpty) {
        debugPrint('[Commerce] Image pick cancelled.');
        return;
      }

      final file = result.files.single;
      final bytes = file.bytes;
      if (bytes == null) {
        throw Exception('No file data.');
      }

      final extension = (file.extension ?? '').toLowerCase();
      final safeExt = extension.isEmpty ? 'jpg' : extension;
      final fileName = '${Uuid().v4()}.$safeExt';
      final contentType = _contentTypeForExtension(safeExt);

      debugPrint(
        '[Commerce] Prepared upload: fileName=$fileName, contentType=$contentType, size=${bytes.length} bytes',
      );

      await Supabase.instance.client.storage
          .from(bucket)
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: FileOptions(
              contentType: contentType ?? 'application/octet-stream',
              upsert: true,
            ),
          );

      debugPrint('[Commerce] Upload binary SUCCESS. Path set to: $fileName');

      if (!mounted) return;
      setState(() => _imageCtrl.text = fileName);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Image uploaded.')));
    } catch (e) {
      debugPrint('[Commerce] Image upload error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Image upload failed: $e')));
    } finally {
      if (mounted) setState(() => _uploadingImage = false);
    }
  }

  String? _contentTypeForExtension(String extension) {
    switch (extension) {
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'webp':
        return 'image/webp';
      case 'gif':
        return 'image/gif';
      case 'bmp':
        return 'image/bmp';
      case 'heic':
      case 'heif':
        return 'image/heic';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.product == null ? 'Add product' : 'Edit product';
    final previewUrl = CommerceConfig.resolveImageUrl(
      _imageCtrl.text.trim().isEmpty ? null : _imageCtrl.text.trim(),
    );
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              _SectionHeader(label: 'Info'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _skuCtrl,
                decoration: const InputDecoration(
                  labelText: 'SKU / Reference',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d\.,]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Price (DZD)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Price is required';
                  }
                  final parsed = double.tryParse(
                    value.trim().replaceAll(',', '.'),
                  );
                  if (parsed == null || parsed < 0) {
                    return 'Enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _promoCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d\.,]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Promo price (DZD)',
                  border: OutlineInputBorder(),
                  helperText: 'Optional',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }
                  final parsed = double.tryParse(
                    value.trim().replaceAll(',', '.'),
                  );
                  if (parsed == null || parsed < 0) {
                    return 'Enter a valid promo price';
                  }
                  final price = double.tryParse(
                    _priceCtrl.text.trim().replaceAll(',', '.'),
                  );
                  if (price != null && parsed >= price) {
                    return 'Promo must be lower than price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _SectionHeader(label: 'Image'),
              const SizedBox(height: 8),
              TextField(
                controller: _imageCtrl,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  labelText: 'Image URL or Storage path',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _uploadingImage ? null : _pickAndUploadImage,
                      icon: const Icon(Icons.cloud_upload),
                      label: Text(
                        _uploadingImage
                            ? 'Uploading...'
                            : (_imageCtrl.text.trim().isEmpty
                                  ? 'Upload image'
                                  : 'Replace image'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed:
                        (_imageCtrl.text.trim().isEmpty || _uploadingImage)
                        ? null
                        : () => setState(_imageCtrl.clear),
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear'),
                  ),
                ],
              ),
              if (previewUrl != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(previewUrl, fit: BoxFit.cover),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              _SectionHeader(label: 'Stock & status'),
              const SizedBox(height: 8),
              TextField(
                controller: _categoryCtrl,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _stockCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Stock',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return null;
                  final parsed = int.tryParse(value.trim());
                  if (parsed == null || parsed < 0) {
                    return 'Enter a valid stock';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _popularityCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Popularity',
                  border: OutlineInputBorder(),
                  helperText: 'Higher means more popular',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return null;
                  final parsed = int.tryParse(value.trim());
                  if (parsed == null || parsed < 0) {
                    return 'Enter a valid popularity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _isActive,
                title: const Text('Active'),
                onChanged: (value) => setState(() => _isActive = value),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: (_saving || _uploadingImage) ? null : _onSave,
                  child: Text(_saving ? 'Saving...' : 'Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final bool isAdmin;
  final VoidCallback onAdd;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _ProductCard({
    required this.product,
    required this.isAdmin,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedImageUrl = CommerceConfig.resolveImageUrl(product.imageUrl);
    final hasImage = resolvedImageUrl != null;
    final stock = product.stock;
    final isOutOfStock = stock != null && stock <= 0;
    final isLowStock = stock != null && stock > 0 && stock <= 3;
    final canAdd = !isOutOfStock;
    final isOnPromo = product.isOnPromo;
    final popularity = product.popularity;
    final showPopularity = popularity > 0;
    final sku = product.sku?.trim();
    final hasSku = sku != null && sku.isNotEmpty;
    final heroTag = 'product-hero-${product.id}';
    final originalPriceStyle = (theme.textTheme.labelSmall ?? const TextStyle())
        .copyWith(
          decoration: TextDecoration.lineThrough,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        );

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openDetail(context, product),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasImage)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Hero(
                    tag: heroTag,
                    child: Image.network(
                      resolvedImageUrl!,
                      width: 86,
                      height: 86,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Hero(tag: heroTag, child: const Icon(Icons.videocam)),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        if (isAdmin && (onEdit != null || onDelete != null))
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                onEdit?.call();
                              } else if (value == 'delete') {
                                onDelete?.call();
                              }
                            },
                            itemBuilder: (context) => [
                              if (onEdit != null)
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                              if (onDelete != null)
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                            ],
                          ),
                      ],
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
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _Tag(
                          text:
                              '${product.effectivePrice.toStringAsFixed(2)} DZD',
                        ),
                        if (isOnPromo)
                          _Tag(
                            text: '${product.price.toStringAsFixed(2)} DZD',
                            style: originalPriceStyle,
                          ),
                        if (isOnPromo)
                          const _StatusBadge(text: 'Promo', color: Colors.pink),
                        if (showPopularity)
                          _Tag(text: 'Popularity: $popularity'),
                        if (isAdmin && hasSku) _Tag(text: 'SKU: $sku'),
                        if (product.category != null &&
                            product.category!.trim().isNotEmpty)
                          _Tag(text: product.category!),
                        if (product.stock != null)
                          _Tag(text: 'Stock: ${product.stock}'),
                        if (!product.isActive)
                          const _StatusBadge(
                            text: 'Inactive',
                            color: Colors.grey,
                          ),
                        if (isOutOfStock)
                          const _StatusBadge(
                            text: 'Out of stock',
                            color: Colors.red,
                          )
                        else if (isLowStock)
                          const _StatusBadge(
                            text: 'Low stock',
                            color: Colors.orange,
                          ),
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
                    onPressed: canAdd ? onAdd : null,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Add'),
                  ),
                  if (isOutOfStock)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'Unavailable',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductGridCard extends StatelessWidget {
  final Product product;
  final bool isAdmin;
  final VoidCallback onAdd;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _ProductGridCard({
    required this.product,
    required this.isAdmin,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedImageUrl = CommerceConfig.resolveImageUrl(product.imageUrl);
    final stock = product.stock;
    final isOutOfStock = stock != null && stock <= 0;
    final isLowStock = stock != null && stock > 0 && stock <= 3;
    final canAdd = !isOutOfStock;
    final isOnPromo = product.isOnPromo;
    final popularity = product.popularity;
    final showPopularity = popularity > 0;
    final sku = product.sku?.trim();
    final hasSku = sku != null && sku.isNotEmpty;
    final originalPriceStyle = (theme.textTheme.labelSmall ?? const TextStyle())
        .copyWith(
          decoration: TextDecoration.lineThrough,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        );
    final heroTag = 'product-hero-${product.id}';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openDetail(context, product),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (resolvedImageUrl != null)
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Hero(
                  tag: heroTag,
                  child: Image.network(resolvedImageUrl, fit: BoxFit.cover),
                ),
              )
            else
              Container(
                height: 120,
                color: theme.colorScheme.surfaceContainerHighest,
                alignment: Alignment.center,
                child: Hero(
                  tag: heroTag,
                  child: const Icon(Icons.videocam, size: 40),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                      if (isAdmin && (onEdit != null || onDelete != null))
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              onEdit?.call();
                            } else if (value == 'delete') {
                              onDelete?.call();
                            }
                          },
                          itemBuilder: (context) => [
                            if (onEdit != null)
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                            if (onDelete != null)
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (isOnPromo)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${product.effectivePrice.toStringAsFixed(2)} DZD',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Text(
                          '${product.price.toStringAsFixed(2)} DZD',
                          style: originalPriceStyle,
                        ),
                      ],
                    )
                  else
                    Text(
                      '${product.price.toStringAsFixed(2)} DZD',
                      style: theme.textTheme.titleMedium,
                    ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      if (isOnPromo)
                        const _StatusBadge(text: 'Promo', color: Colors.pink),
                      if (showPopularity) _Tag(text: 'Popularity: $popularity'),
                      if (isAdmin && hasSku) _Tag(text: 'SKU: $sku'),
                      if (product.category != null &&
                          product.category!.trim().isNotEmpty)
                        _Tag(text: product.category!),
                      if (product.stock != null)
                        _Tag(text: 'Stock: ${product.stock}'),
                      if (!product.isActive)
                        const _StatusBadge(
                          text: 'Inactive',
                          color: Colors.grey,
                        ),
                      if (isOutOfStock)
                        const _StatusBadge(
                          text: 'Out of stock',
                          color: Colors.red,
                        )
                      else if (isLowStock)
                        const _StatusBadge(
                          text: 'Low stock',
                          color: Colors.orange,
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: canAdd ? onAdd : null,
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Add'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const _Tag({required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = theme.textTheme.labelSmall;
    final resolvedStyle = style == null
        ? baseStyle
        : (baseStyle?.merge(style) ?? style);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: resolvedStyle),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _FilterPill({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: color),
          ),
        ],
      ),
    );

    if (onTap == null) return content;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: content,
    );
  }
}

class _ProductSkeletonList extends StatelessWidget {
  const _ProductSkeletonList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 14,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Container(height: 12, width: 180, color: Colors.white),
                        const SizedBox(height: 12),
                        Container(height: 10, width: 120, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;

  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        letterSpacing: 0.8,
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
          Row(
            children: [
              Text('Your cart', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              TextButton.icon(
                onPressed: provider.clearCart,
                icon: const Icon(Icons.delete_sweep),
                label: const Text('Clear'),
              ),
            ],
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _SummaryLine(
                    label: 'Items',
                    value: provider.totalItems.toString(),
                  ),
                  _SummaryLine(
                    label: 'Subtotal',
                    value: '${provider.total.toStringAsFixed(2)} DZD',
                  ),
                  const _SummaryLine(label: 'Delivery', value: '0.00 DZD'),
                  const Divider(height: 16),
                  _SummaryLine(
                    label: 'Total',
                    value: '${provider.total.toStringAsFixed(2)} DZD',
                    emphasis: true,
                  ),
                ],
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.cartItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = provider.cartItems[index];
              return Dismissible(
                key: ValueKey(item.product.id),
                background: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.red.withValues(alpha: 0.15),
                  child: const Icon(Icons.delete_outline, color: Colors.red),
                ),
                secondaryBackground: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.red.withValues(alpha: 0.15),
                  child: const Icon(Icons.delete_outline, color: Colors.red),
                ),
                onDismissed: (_) => provider.removeFromCart(item.product.id),
                child: _CartItemRow(
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
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
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
                ],
              ),
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
                  Text(item.product.name, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(
                    '${item.subtotal.toStringAsFixed(2)} DZD',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(onPressed: onDecrement, icon: const Icon(Icons.remove)),
            Text(item.quantity.toString()),
            IconButton(onPressed: onIncrement, icon: const Icon(Icons.add)),
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

class _SummaryLine extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasis;

  const _SummaryLine({
    required this.label,
    required this.value,
    this.emphasis = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = emphasis
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: style),
        ],
      ),
    );
  }
}

class _OrdersTab extends StatefulWidget {
  final CommerceProvider provider;
  final VoidCallback onRefresh;
  final VoidCallback onLoadMore;
  final Future<bool> Function({
    required String orderId,
    required OrderStatus status,
  })
  onUpdateStatus;
  final bool Function(String orderId) isUpdating;
  final bool canUpdateStatus;

  const _OrdersTab({
    required this.provider,
    required this.onRefresh,
    required this.onLoadMore,
    required this.onUpdateStatus,
    required this.isUpdating,
    required this.canUpdateStatus,
  });

  @override
  State<_OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<_OrdersTab> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _statusFilter = 'All';
  OrderSort _sort = OrderSort.dateDesc;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<String> _extractStatuses(List<Order> orders) {
    final statuses = <String>{};
    for (final order in orders) {
      statuses.add(order.status.name);
    }
    final list = statuses.toList()..sort();
    return ['All', ...list];
  }

  List<Order> _applyFilters(List<Order> orders, String activeStatus) {
    var filtered = orders;
    final query = _searchCtrl.text.trim().toLowerCase();

    if (activeStatus != 'All') {
      filtered = filtered.where((o) => o.status.name == activeStatus).toList();
    }

    if (query.isNotEmpty) {
      filtered = filtered.where((o) {
        return o.id.toLowerCase().contains(query) ||
            o.phone.toLowerCase().contains(query) ||
            o.address.toLowerCase().contains(query);
      }).toList();
    }

    filtered.sort((a, b) {
      switch (_sort) {
        case OrderSort.dateAsc:
          return (a.createdAt ?? DateTime(0)).compareTo(
            b.createdAt ?? DateTime(0),
          );
        case OrderSort.totalDesc:
          return b.total.compareTo(a.total);
        case OrderSort.totalAsc:
          return a.total.compareTo(b.total);
        case OrderSort.dateDesc:
        default:
          return (b.createdAt ?? DateTime(0)).compareTo(
            a.createdAt ?? DateTime(0),
          );
      }
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.provider.ordersLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final statuses = _extractStatuses(widget.provider.orders);
    final activeStatus = statuses.contains(_statusFilter)
        ? _statusFilter
        : 'All';
    final orders = _applyFilters(widget.provider.orders, activeStatus);

    return RefreshIndicator(
      onRefresh: () async => widget.onRefresh(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          TextField(
            controller: _searchCtrl,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Rechercher une commande...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          if (statuses.length > 1) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: statuses.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final s = statuses[index];
                  return ChoiceChip(
                    label: Text(s == 'All' ? 'Tout' : s),
                    selected: activeStatus == s,
                    onSelected: (_) => setState(() => _statusFilter = s),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 12),
          ...orders.map(
            (order) => _OrderCard(
              order: order,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderDetailsScreen(orderId: order.id),
                ),
              ),
            ),
          ),
          if (widget.provider.ordersHasMore)
            Center(
              child: TextButton(
                onPressed: widget.onLoadMore,
                child: const Text('Charger plus'),
              ),
            ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const _OrderCard({required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        title: Text('Commande #${order.id.substring(0, 8)}'),
        subtitle: Text(
          '${order.total.toStringAsFixed(2)} DZD • ${order.items.length} articles',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _StatusBadge(
              text: order.status.label,
              color: _statusColor(order.status),
            ),
            const SizedBox(height: 4),
            if (order.createdAt != null)
              Text(
                DateFormat('dd/MM').format(order.createdAt!),
                style: theme.textTheme.labelSmall,
              ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.shipped:
        return Colors.orange;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.paid:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
