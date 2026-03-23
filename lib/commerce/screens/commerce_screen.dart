import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../l10n/app_localizations.dart';
import '../commerce_config.dart';
import '../models/cart_item.dart';
import '../models/commerce_enums.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../providers/commerce_provider.dart';
import 'auth_screen.dart';
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
    return _CommerceView(userId: userId);
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

  Future<void> _refreshOrders() async {
    final provider = context.read<CommerceProvider>();
    // Sur Windows, si widget.userId est null, on utilise l'utilisateur Firebase actuel
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final effectiveUserId = widget.userId ?? firebaseUser?.uid;

    // Si pas admin, on charge seulement les commandes de l'utilisateur effectif
    final filterUserId = _isAdminMode ? null : effectiveUserId;
    await provider.loadOrders(userId: filterUserId, reset: true);
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
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final effectiveUserId = widget.userId ?? firebaseUser?.uid;

    if (phone.isEmpty || address.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.phoneAddressRequired),
        ),
      );
      return;
    }

    setState(() => _placingOrder = true);
    final l10n = AppLocalizations.of(context)!;
    try {
      final orderId = await provider.placeOrder(
        phone: phone,
        address: address,
        note: note.isEmpty ? null : note,
        userId: effectiveUserId,
      );

      if (!mounted) return;
      if (orderId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.orderFailedLong)));
        return;
      }

      _noteCtrl.clear();
      _phoneCtrl.clear();
      _addressCtrl.clear();

      // Basculer vers l'onglet des commandes (index 1)
      DefaultTabController.of(context).animateTo(1);

      // Rafraîchir la liste des commandes
      _refreshOrders();

      final message = orderId.trim().isEmpty
          ? l10n.orderCreated
          : l10n.orderCreatedLong(orderId);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.orderFailedLong)));
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
    final l10n = AppLocalizations.of(context)!;
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
            content: Text(isNew ? l10n.productCreated : l10n.productUpdated),
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
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.deleteProductTitle),
        content: Text(l10n.deleteProductConfirm(product.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (ok != true) return;
    final deleted = await provider.deleteProduct(product.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(deleted ? l10n.productDeleted : l10n.deleteFailed),
      ),
    );
  }

  void _toggleAdminMode(CommerceProvider provider) {
    setState(() => _isAdminMode = !_isAdminMode);
    _refreshOrders();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommerceProvider>();
    final firebaseUser = FirebaseAuth.instance.currentUser;
    // Sur Windows, si widget.userId est null, on tente de récupérer le currentUser actuel
    final effectiveUserId = widget.userId ?? firebaseUser?.uid;
    final l10n = AppLocalizations.of(context)!;

    final tabs = <Tab>[
      Tab(text: l10n.productsTab),
      Tab(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.ordersTab),
            if (provider.orders.isNotEmpty) ...[
              const SizedBox(width: 4),
              Badge(
                label: Text(provider.orders.length.toString()),
                backgroundColor: Colors.blue,
              ),
            ],
          ],
        ),
      ),
      Tab(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.cartTab),
            if (provider.totalItems > 0) ...[
              const SizedBox(width: 4),
              Badge(
                label: Text(provider.totalItems.toString()),
                backgroundColor: Colors.green,
              ),
            ],
          ],
        ),
      ),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.commerce),
              actions: [
                if (firebaseUser == null)
                  IconButton(
                    tooltip: l10n.login,
                    icon: const Icon(Icons.login, color: Colors.blue),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                    ),
                  ),
                IconButton(
                  tooltip: l10n.logout,
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(l10n.logout),
                        content: Text(l10n.commerceDisconnectConfirm),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(l10n.cancel),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(l10n.logout),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        provider.setRole(UserRole.client);
                        setState(() => _isAdminMode = false);
                        Navigator.of(context).pop(); // Retour au HomeScreen
                      }
                    }
                  },
                ),
                IconButton(
                  onPressed: provider.isLoading
                      ? null
                      : () => provider.loadProducts(query: _searchCtrl.text),
                  icon: const Icon(Icons.refresh),
                ),
                IconButton(
                  tooltip: _isAdminMode
                      ? l10n.clientModeTooltip
                      : l10n.adminModeTooltip,
                  icon: Icon(
                    _isAdminMode
                        ? Icons.admin_panel_settings
                        : Icons.person_outline,
                  ),
                  onPressed: () => _toggleAdminMode(provider),
                ),
                if (_isAdminMode)
                  IconButton(
                    tooltip: l10n.addProductTooltip,
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
    final l10n = AppLocalizations.of(context)!;
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
                        l10n.itemsCount(provider.totalItems),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Text(
                        l10n.orderTotal(provider.total.toStringAsFixed(2)),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed: () => controller.animateTo(cartIndex),
                  child: Text(l10n.placeOrderButton),
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
  String? _selectedCategory;
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
    return list;
  }

  List<Product> _applyFilters(List<Product> products, String? activeCategory) {
    var filtered = products;

    if (activeCategory != null) {
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

  String _sortLabel(AppLocalizations l10n, ProductSort sort) {
    switch (sort) {
      case ProductSort.priceAsc:
        return l10n.sortPriceAsc;
      case ProductSort.priceDesc:
        return l10n.sortPriceDesc;
      case ProductSort.stockAsc:
        return l10n.sortStockAsc;
      case ProductSort.stockDesc:
        return l10n.sortStockDesc;
      case ProductSort.popularityDesc:
        return l10n.sortPopularity;
      case ProductSort.nameAsc:
      default:
        return l10n.sortName;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final categories = _extractCategories(widget.provider.products);
    final activeCategory = categories.contains(_selectedCategory)
        ? _selectedCategory
        : null;
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
              hintText: l10n.searchProductsPlaceholder,
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
                if (index == 0) {
                  return ChoiceChip(
                    label: Text(l10n.allFilter),
                    selected: activeCategory == null,
                    onSelected: (_) => setState(() => _selectedCategory = null),
                  );
                }
                final category = categories[index - 1];
                return ChoiceChip(
                  label: Text(category),
                  selected: activeCategory == category,
                  onSelected: (_) =>
                      setState(() => _selectedCategory = category),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: categories.length + 1,
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: Text(l10n.inStockFilter),
                selected: _inStockOnly,
                onSelected: (value) => setState(() => _inStockOnly = value),
              ),
              if (widget.isAdmin)
                FilterChip(
                  label: Text(l10n.includeInactiveFilter),
                  selected: widget.includeInactive,
                  onSelected: widget.onToggleInactive,
                ),
              PopupMenuButton<ProductSort>(
                initialValue: _sort,
                onSelected: (value) => setState(() => _sort = value),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: ProductSort.nameAsc,
                    child: Text(l10n.sortName),
                  ),
                  PopupMenuItem(
                    value: ProductSort.priceAsc,
                    child: Text(l10n.sortPriceAsc),
                  ),
                  PopupMenuItem(
                    value: ProductSort.priceDesc,
                    child: Text(l10n.sortPriceDesc),
                  ),
                  PopupMenuItem(
                    value: ProductSort.stockAsc,
                    child: Text(l10n.sortStockAsc),
                  ),
                  PopupMenuItem(
                    value: ProductSort.stockDesc,
                    child: Text(l10n.sortStockDesc),
                  ),
                  PopupMenuItem(
                    value: ProductSort.popularityDesc,
                    child: Text(l10n.sortPopularity),
                  ),
                ],
                child: _FilterPill(
                  icon: Icons.sort,
                  label: _sortLabel(l10n, _sort),
                ),
              ),
              if (widget.isAdmin && widget.onAddProduct != null)
                FilledButton.icon(
                  onPressed: widget.onAddProduct,
                  icon: const Icon(Icons.add),
                  label: Text(l10n.addProductTitle),
                ),
              _FilterPill(
                icon: _gridView ? Icons.view_list : Icons.grid_view,
                label: _gridView ? l10n.listView : l10n.gridView,
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
                      child: Text(l10n.retry),
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
                    Text(
                      l10n.noProductsMatch,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => setState(() {
                        _selectedCategory = null;
                        _inStockOnly = false;
                        _sort = ProductSort.nameAsc;
                      }),
                      child: Text(l10n.clearFilters),
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
    final l10n = AppLocalizations.of(context)!;
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
                l10n.allProductsLoaded,
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
    final l10n = AppLocalizations.of(context)!;
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
                l10n.allProductsLoaded,
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
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.formErrors)),
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
      ).showSnackBar(SnackBar(content: Text(l10n.saveFailed)));
    }
  }

  Future<void> _pickAndUploadImage() async {
    if (_uploadingImage) return;
    final l10n = AppLocalizations.of(context)!;
    final bucket = CommerceConfig.supabaseImagesBucket.trim();
    debugPrint('[Commerce] Starting image pick. Bucket: "$bucket"');

    if (bucket.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.supabaseBucketNotConfigured)),
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
      ).showSnackBar(SnackBar(content: Text(l10n.imageUploaded)));
    } catch (e) {
      debugPrint('[Commerce] Image upload error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.imageUploadFailed(e.toString()))));
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
    final l10n = AppLocalizations.of(context)!;
    final title = widget.product == null
        ? l10n.addProductTitle
        : l10n.editProductTitle;
    final previewUrl = CommerceConfig.resolveImageUrl(
      _imageCtrl.text.trim().isEmpty ? null : _imageCtrl.text.trim(),
    );
    return SafeArea(
      child: Padding(
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
                _SectionHeader(label: l10n.productInfoSection),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.productNameLabel,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.nameRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _skuCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.skuLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descCtrl,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: l10n.descriptionLabel,
                    border: const OutlineInputBorder(),
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
                  decoration: InputDecoration(
                    labelText: l10n.priceLabel,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.priceRequired;
                    }
                    final parsed = double.tryParse(
                      value.trim().replaceAll(',', '.'),
                    );
                    if (parsed == null || parsed < 0) {
                      return l10n.invalidPrice;
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
                  decoration: InputDecoration(
                    labelText: l10n.promoPriceLabel,
                    border: const OutlineInputBorder(),
                    helperText: l10n.optionalHelper,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return null;
                    }
                    final parsed = double.tryParse(
                      value.trim().replaceAll(',', '.'),
                    );
                    if (parsed == null || parsed < 0) {
                      return l10n.invalidPromoPrice;
                    }
                    final price = double.tryParse(
                      _priceCtrl.text.trim().replaceAll(',', '.'),
                    );
                    if (price != null && parsed >= price) {
                      return l10n.promoLowerThanPrice;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _SectionHeader(label: l10n.productImageSection),
                const SizedBox(height: 8),
                TextField(
                  controller: _imageCtrl,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: l10n.imageLabel,
                    border: const OutlineInputBorder(),
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
                              ? l10n.uploadingButton
                              : (_imageCtrl.text.trim().isEmpty
                                    ? l10n.uploadImageButton
                                    : l10n.replaceImageButton),
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
                      label: Text(l10n.clear),
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
                _SectionHeader(label: l10n.productStockStatusSection),
                const SizedBox(height: 8),
                TextField(
                  controller: _categoryCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.categoryLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _stockCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: l10n.stockLabel,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    final parsed = int.tryParse(value.trim());
                    if (parsed == null || parsed < 0) {
                      return l10n.invalidStock;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _popularityCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: l10n.popularityLabel,
                    border: const OutlineInputBorder(),
                    helperText: l10n.popularityHelper,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    final parsed = int.tryParse(value.trim());
                    if (parsed == null || parsed < 0) {
                      return l10n.invalidPopularity;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _isActive,
                  title: Text(l10n.activeLabel),
                  onChanged: (value) => setState(() => _isActive = value),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: (_saving || _uploadingImage) ? null : _onSave,
                    child: Text(
                      _saving ? l10n.savingButton : l10n.saveButton,
                    ),
                  ),
                ),
              ],
            ),
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
    final l10n = AppLocalizations.of(context)!;
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
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text(l10n.edit),
                                ),
                              if (onDelete != null)
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text(l10n.delete),
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
                          _StatusBadge(
                            text: l10n.promoStatus,
                            color: Colors.pink,
                          ),
                        if (showPopularity)
                          _Tag(text: '${l10n.popularityLabel}: $popularity'),
                        if (isAdmin && hasSku)
                          _Tag(text: '${l10n.skuLabel}: $sku'),
                        if (product.category != null &&
                            product.category!.trim().isNotEmpty)
                          _Tag(text: product.category!),
                        if (product.stock != null)
                          _Tag(text: '${l10n.stockLabel}: ${product.stock}'),
                        if (!product.isActive)
                          _StatusBadge(
                            text: l10n.inactiveStatus,
                            color: Colors.grey,
                          ),
                        if (isOutOfStock)
                          _StatusBadge(
                            text: l10n.outOfStockStatus,
                            color: Colors.red,
                          )
                        else if (isLowStock)
                          _StatusBadge(
                            text: l10n.lowStockStatus,
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
                    label: Text(l10n.add),
                  ),
                  if (isOutOfStock)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        l10n.unavailableStatus,
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
    final l10n = AppLocalizations.of(context)!;
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
                              PopupMenuItem(
                                value: 'edit',
                                child: Text(l10n.edit),
                              ),
                            if (onDelete != null)
                              PopupMenuItem(
                                value: 'delete',
                                child: Text(l10n.delete),
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
                        _StatusBadge(
                          text: l10n.promoStatus,
                          color: Colors.pink,
                        ),
                      if (showPopularity)
                        _Tag(text: '${l10n.popularityLabel}: $popularity'),
                      if (isAdmin && hasSku)
                        _Tag(text: '${l10n.skuLabel}: $sku'),
                      if (product.category != null &&
                          product.category!.trim().isNotEmpty)
                        _Tag(text: product.category!),
                      if (product.stock != null)
                        _Tag(text: '${l10n.stockLabel}: ${product.stock}'),
                      if (!product.isActive)
                        _StatusBadge(
                          text: l10n.inactiveStatus,
                          color: Colors.grey,
                        ),
                      if (isOutOfStock)
                        _StatusBadge(
                          text: l10n.outOfStockStatus,
                          color: Colors.red,
                        )
                      else if (isLowStock)
                        _StatusBadge(
                          text: l10n.lowStockStatus,
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
                      label: Text(l10n.add),
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
    final l10n = AppLocalizations.of(context)!;
    if (provider.cartItems.isEmpty) {
      return Center(child: Text(l10n.cartEmpty));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(l10n.yourCart, style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              TextButton.icon(
                onPressed: provider.clearCart,
                icon: const Icon(Icons.delete_sweep),
                label: Text(l10n.clearCart),
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
                    label: l10n.itemsLabel,
                    value: provider.totalItems.toString(),
                  ),
                  _SummaryLine(
                    label: l10n.subtotalLabel,
                    value: '${provider.total.toStringAsFixed(2)} DZD',
                  ),
                  _SummaryLine(label: l10n.deliveryLabel, value: '0.00 DZD'),
                  const Divider(height: 16),
                  _SummaryLine(
                    label: l10n.totalLabel,
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
                    decoration: InputDecoration(
                      labelText: l10n.phoneLabel,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: addressCtrl,
                    decoration: InputDecoration(
                      labelText: l10n.addressLabel,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: noteCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: '${l10n.noteLabel} (${l10n.optionalHelper})',
                      border: const OutlineInputBorder(),
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
              child: Text(
                placingOrder ? l10n.placingOrderButton : l10n.placeOrderButton,
              ),
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
  OrderStatus? _statusFilter;
  OrderSort _sort = OrderSort.dateDesc;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<OrderStatus> _extractStatuses(List<Order> orders) {
    final statuses = <OrderStatus>{};
    for (final order in orders) {
      statuses.add(order.status);
    }
    final list = statuses.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  List<Order> _applyFilters(List<Order> orders, OrderStatus? activeStatus) {
    var filtered = orders;
    final query = _searchCtrl.text.trim().toLowerCase();

    if (activeStatus != null) {
      filtered = filtered.where((o) => o.status == activeStatus).toList();
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
    final l10n = AppLocalizations.of(context)!;
    if (widget.provider.ordersLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final statuses = _extractStatuses(widget.provider.orders);
    final activeStatus = statuses.contains(_statusFilter)
        ? _statusFilter
        : null;
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
              hintText: l10n.searchOrderPlaceholder,
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
                itemCount: statuses.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return ChoiceChip(
                      label: Text(l10n.allFilter),
                      selected: activeStatus == null,
                      onSelected: (_) =>
                          setState(() => _statusFilter = null),
                    );
                  }
                  final s = statuses[index - 1];
                  return ChoiceChip(
                    label: Text(s.label(l10n)),
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
                child: Text(l10n.loadMoreButton),
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
    final l10n = AppLocalizations.of(context)!;
    final statusColor = _statusColor(order.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.orderNumber(order.id.substring(0, 8)),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (order.createdAt != null)
                        Text(
                          DateFormat(
                            'dd MMM yyyy, HH:mm',
                          ).format(order.createdAt!),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                  _StatusBadge(
                    text: order.status.label(l10n).toUpperCase(),
                    color: statusColor,
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 20,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Text(l10n.itemsCount(order.items.length)),
                  const Spacer(),
                  Text(
                    '${order.total.toStringAsFixed(2)} DZD',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _DeliveryProgressBar(status: order.status),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return Colors.purple;
      case OrderStatus.shipped:
        return Colors.orange;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.paid:
        return Colors.green;
      case OrderStatus.created:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

class _DeliveryProgressBar extends StatelessWidget {
  final OrderStatus status;

  const _DeliveryProgressBar({required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    int step = 0;
    // Progression : created(0) -> orderConfirmed(1) -> packed(2) -> shipped(3) -> delivered(4)
    if (status == OrderStatus.orderConfirmed)
      step = 1;
    else if (status == OrderStatus.packed || status == OrderStatus.readyToShip)
      step = 2;
    else if (status == OrderStatus.shipped ||
        status == OrderStatus.partiallyShipped)
      step = 3;
    else if (status == OrderStatus.delivered)
      step = 4;
    else if (status == OrderStatus.cancelled)
      step = -1;

    return Column(
      children: [
        Row(
          children: List.generate(5, (index) {
            bool isPast = step >= index;
            bool isCurrent = step == index;
            Color color = isPast ? Colors.green : Colors.grey.shade300;
            if (status == OrderStatus.cancelled)
              color = Colors.red.withValues(alpha: 0.3);

            return Expanded(
              child: Container(
                height: 6,
                margin: EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: Colors.green.withValues(alpha: 0.4),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.orderConfirmedStep, style: _stepStyle(context, step >= 0)),
            Text(l10n.shippedStep, style: _stepStyle(context, step >= 3)),
            Text(l10n.deliveredStep, style: _stepStyle(context, step >= 4)),
          ],
        ),
      ],
    );
  }

  TextStyle _stepStyle(BuildContext context, bool active) {
    return Theme.of(context).textTheme.labelSmall!.copyWith(
      color: active ? Colors.green : Colors.grey,
      fontWeight: active ? FontWeight.bold : FontWeight.normal,
    );
  }
}
