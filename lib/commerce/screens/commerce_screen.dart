import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../data/sources/supabase_service.dart';
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
  final _clientNameCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  bool _placingOrder = false;
  bool _openingProductForm = false;
  bool _isAdminMode = false;
  TabController? _tabController;

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
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final effectiveUserId = widget.userId ?? firebaseUser?.uid;
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
    final clientNameInput = _clientNameCtrl.text.trim();
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final effectiveUserId = widget.userId ?? firebaseUser?.uid;
    debugPrint(
      '[Commerce] UI submitOrder: userId=$effectiveUserId '
      'phoneProvided=${phone.isNotEmpty} addressProvided=${address.isNotEmpty}',
    );

    if (phone.isEmpty || address.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.phoneAddressRequired),
        ),
      );
      return;
    }

    // Fallback: use email if client name is empty
    final effectiveClientName = clientNameInput.isNotEmpty
        ? clientNameInput
        : (firebaseUser?.email ?? 'Guest');

    setState(() => _placingOrder = true);
    final l10n = AppLocalizations.of(context)!;
    try {
      final orderId = await provider.placeOrder(
        phone: phone,
        address: address,
        note: note.isEmpty ? null : note,
        userId: effectiveUserId,
        clientName: effectiveClientName,
      );

      if (!mounted) return;
      if (orderId == null) {
        final errorMsg = provider.ordersError ?? l10n.orderFailedLong;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMsg)));
        return;
      }

      _noteCtrl.clear();
      _phoneCtrl.clear();
      _addressCtrl.clear();
      _clientNameCtrl.clear();
      if (_tabController == null) {
        debugPrint('[Commerce] UI submitOrder warning: tabController is null');
      } else {
        _tabController!.animateTo(1);
      }
      _refreshOrders();

      final message = orderId.trim().isEmpty
          ? l10n.orderCreated
          : l10n.orderCreatedLong(orderId);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e, st) {
      debugPrint('[Commerce] UI submitOrder error: $e');
      debugPrint('[Commerce] UI submitOrder stack: $st');
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
    final l10n = AppLocalizations.of(context)!;

    final effectiveUserId = widget.userId ?? firebaseUser?.uid;
    if (provider.currentUserId != effectiveUserId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.setCurrentUserId(effectiveUserId);
      });
    }

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
          _tabController = DefaultTabController.of(context);
          final tabController = DefaultTabController.of(context);
          return SafeArea(
            child: Scaffold(
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
                          Navigator.of(context).pop();
                        }
                      }
                    },
                  ),
                  IconButton(
                    onPressed: provider.isLoading
                        ? null
                        : () {
                            final q = _searchCtrl.text.trim();
                            provider.loadProducts(query: q.isEmpty ? null : q);
                          },
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
                    clientNameCtrl: _clientNameCtrl,
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
                  onPressed: () => controller.animateTo(2),
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
  bool _favoritesOnly = false;
  ProductSort _sort = ProductSort.nameAsc;
  bool _gridView = false;
  late final ScrollController _scrollCtrl;
  late final VoidCallback _searchListener;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController()..addListener(_onScroll);
    _searchListener = () {
      if (!mounted) return;
      _searchDebounce?.cancel();
      _searchDebounce = Timer(const Duration(milliseconds: 350), () {
        if (!mounted) return;
        final q = widget.searchCtrl.text.trim();
        widget.provider.loadProducts(query: q.isEmpty ? null : q);
      });
      setState(() {});
    };
    widget.searchCtrl.addListener(_searchListener);
  }

  @override
  void dispose() {
    _scrollCtrl
      ..removeListener(_onScroll)
      ..dispose();
    widget.searchCtrl.removeListener(_searchListener);
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollCtrl.hasClients) return;
    if (_scrollCtrl.position.maxScrollExtent - _scrollCtrl.position.pixels <=
        320) {
      widget.provider.loadMoreProducts();
    }
  }

  List<String> _extractCategories(List<Product> products) {
    final categories = <String>{};
    for (final p in products) {
      final c = p.category?.trim();
      if (c != null && c.isNotEmpty) categories.add(c);
    }
    return categories.toList()..sort();
  }

  List<Product> _applyFilters(
    List<Product> products,
    String? activeCategory, {
    bool applyFavoritesFilter = true,
    String? searchQuery,
  }) {
    var filtered = products;
    if (activeCategory != null)
      filtered = filtered
          .where((p) => (p.category ?? '').trim() == activeCategory)
          .toList();
    if (_inStockOnly)
      filtered = filtered
          .where((p) => p.stock == null || p.stock! > 0)
          .toList();
    final q = searchQuery?.trim() ?? '';
    if (q.isNotEmpty) {
      filtered = filtered.where((p) => _matchesSearch(p, q)).toList();
    }
    if (applyFavoritesFilter && _favoritesOnly)
      filtered = filtered.where((p) => p.isFavorite).toList();
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
        default:
          // Default: Newest/Most recently modified first
          final aDate = a.updatedAt ?? a.createdAt ?? DateTime(0);
          final bDate = b.updatedAt ?? b.createdAt ?? DateTime(0);
          return bDate.compareTo(aDate);
      }
    });
    return filtered;
  }

  bool _matchesSearch(Product product, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    final name = product.name.toLowerCase();
    final description = product.description?.toLowerCase() ?? '';
    final sku = product.sku?.toLowerCase() ?? '';
    return name.contains(q) || description.contains(q) || sku.contains(q);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final activeSearch = widget.searchCtrl.text.trim();
    final baseForCategoryCounts = _applyFilters(
      widget.provider.products,
      null,
      applyFavoritesFilter: false,
      searchQuery: activeSearch,
    );
    final categoryCounts = <String, int>{};
    for (final product in baseForCategoryCounts) {
      final cat = (product.category ?? '').trim();
      if (cat.isEmpty) continue;
      categoryCounts.update(cat, (v) => v + 1, ifAbsent: () => 1);
    }
    final totalCount = baseForCategoryCounts.length;
    final categories = _extractCategories(
      baseForCategoryCounts.isNotEmpty
          ? baseForCategoryCounts
          : widget.provider.products,
    );
    final activeCategory = categories.contains(_selectedCategory)
        ? _selectedCategory
        : null;
    final baseFiltered = _applyFilters(
      widget.provider.products,
      activeCategory,
      applyFavoritesFilter: false,
      searchQuery: activeSearch,
    );
    final products = _applyFilters(
      widget.provider.products,
      activeCategory,
      searchQuery: activeSearch,
    );
    final favoriteCount = baseFiltered.where((p) => p.isFavorite).length;
    final badgeColor =
        _favoritesOnly ? Colors.red : theme.colorScheme.primary;
    final isSearching = activeSearch.isNotEmpty &&
        (widget.provider.isLoading || widget.provider.isLoadingMore);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: widget.searchCtrl,
            onSubmitted: (_) =>
                widget.provider.loadProducts(
                  query: widget.searchCtrl.text.trim().isEmpty
                      ? null
                      : widget.searchCtrl.text.trim(),
                ),
            decoration: InputDecoration(
              hintText: l10n.searchProductsPlaceholder,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        if (isSearching)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 8),
                Text(
                  '${l10n.search}...',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
        if (categories.isNotEmpty)
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                if (index == 0) {
                  final badgeBg = activeCategory == null
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest;
                  final badgeFg = activeCategory == null
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant;
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(l10n.allFilter),
                        const SizedBox(width: 6),
                        Badge(
                          label: Text(
                            totalCount.toString(),
                            style: TextStyle(color: badgeFg),
                          ),
                          backgroundColor: badgeBg,
                        ),
                      ],
                    ),
                    selected: activeCategory == null,
                    onSelected: (_) => setState(() => _selectedCategory = null),
                  );
                }
                final cat = categories[index - 1];
                final count = categoryCounts[cat] ?? 0;
                final isSelected = activeCategory == cat;
                final badgeBg = isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest;
                final badgeFg = isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant;
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(cat),
                      const SizedBox(width: 6),
                      Badge(
                        label: Text(
                          count.toString(),
                          style: TextStyle(color: badgeFg),
                        ),
                        backgroundColor: badgeBg,
                      ),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedCategory = cat),
                );
              },
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
                onSelected: (v) => setState(() => _inStockOnly = v),
              ),
              FilterChip(
                avatar: Icon(
                  _favoritesOnly ? Icons.favorite : Icons.favorite_border,
                  size: 16,
                  color: _favoritesOnly ? Colors.red : null,
                ),
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Favoris'),
                    if (favoriteCount > 0) ...[
                      const SizedBox(width: 6),
                      Badge(
                        label: Text(favoriteCount.toString()),
                        backgroundColor: badgeColor,
                      ),
                    ],
                  ],
                ),
                selected: _favoritesOnly,
                onSelected: (v) => setState(() => _favoritesOnly = v),
              ),
              if (widget.isAdmin)
                FilterChip(
                  label: Text(l10n.includeInactiveFilter),
                  selected: widget.includeInactive,
                  onSelected: widget.onToggleInactive,
                ),
              _FilterPill(
                icon: Icons.sort,
                label: l10n.sortName,
                onTap: () {
                  // Show sort menu
                },
              ),
              _FilterPill(
                icon: _gridView ? Icons.view_list : Icons.grid_view,
                label: _gridView ? l10n.listView : l10n.gridView,
                onTap: () => setState(() => _gridView = !_gridView),
              ),
            ],
          ),
        ),
        Expanded(
          child: widget.provider.isLoading
              ? const _ProductSkeletonList()
              : _gridView
              ? _ProductGrid(
                  controller: _scrollCtrl,
                  products: products,
                  isAdmin: widget.isAdmin,
                  onAdd: (p) => widget.provider.addToCart(p),
                  onEdit: widget.onEditProduct,
                  onDelete: widget.onDeleteProduct,
                  isLoadingMore: widget.provider.isLoadingMore,
                  hasMore: widget.provider.productsHasMore,
                )
              : _ProductList(
                  controller: _scrollCtrl,
                  products: products,
                  isAdmin: widget.isAdmin,
                  onAdd: (p) => widget.provider.addToCart(p),
                  onEdit: widget.onEditProduct,
                  onDelete: widget.onDeleteProduct,
                  isLoadingMore: widget.provider.isLoadingMore,
                  hasMore: widget.provider.productsHasMore,
                ),
        ),
      ],
    );
  }
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
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
      itemCount: products.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (context, index) {
        if (index >= products.length) {
          if (isLoadingMore)
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(child: CircularProgressIndicator()),
            );
          if (!hasMore)
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  l10n.allProductsLoaded,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            );
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;
    final count = width >= 1100 ? 4 : (width >= 800 ? 3 : 2);
    final aspectRatio = count == 2 ? 0.45 : (count == 3 ? 0.52 : 0.58);

    return GridView.builder(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: count,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: aspectRatio,
      ),
      itemCount: products.length + 1,
      itemBuilder: (context, index) {
        if (index >= products.length) {
          if (isLoadingMore)
            return const Center(child: CircularProgressIndicator());
          if (!hasMore)
            return Center(
              child: Text(
                l10n.allProductsLoaded,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            );
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
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final resolvedImageUrl = CommerceConfig.resolveImageUrl(product.imageUrl);
    final stock = product.stock;
    final isOutOfStock = stock != null && stock <= 0;
    final isLowStock = stock != null && stock > 0 && stock <= 3;
    final isOnPromo = product.isOnPromo;
    final popularity = product.popularity;
    final sku = product.sku?.trim();
    final hasSku = sku != null && sku.isNotEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openDetail(context, product),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Hero(
                      tag: 'product-hero-${product.id}',
                      child: resolvedImageUrl != null
                          ? Image.network(
                              resolvedImageUrl,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 90,
                                    height: 90,
                                    alignment: Alignment.center,
                                    color: theme
                                        .colorScheme
                                        .surfaceContainerHighest,
                                    child: const Icon(Icons.broken_image),
                                  ),
                            )
                          : Container(
                              width: 90,
                              height: 90,
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: const Icon(Icons.videocam, size: 32),
                            ),
                    ),
                  ),
                  if (isOnPromo)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          l10n.promoStatus.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (hasSku)
                                Text(
                                  'SKU: $sku',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            product.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: product.isFavorite
                                ? Colors.red
                                : Colors.grey,
                            size: 20,
                          ),
                          onPressed: () {
                            context.read<CommerceProvider>().toggleFavorite(
                              product.id,
                            );
                          },
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
                            child: const Icon(
                              Icons.more_vert,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                    if (product.description != null &&
                        product.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2, bottom: 4),
                        child: Text(
                          product.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        if (product.category != null)
                          _Tag(text: product.category!, isCompact: true),
                        if (popularity > 0)
                          _Tag(text: '★ $popularity', isCompact: true),
                        _StatusBadge(
                          text: isOutOfStock
                              ? l10n.outOfStockStatus
                              : (stock != null
                                    ? '$stock ${l10n.stockLabel}'
                                    : l10n.inStockFilter),
                          color: isOutOfStock
                              ? Colors.red
                              : (isLowStock ? Colors.orange : Colors.green),
                          isCompact: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${product.effectivePrice.toStringAsFixed(2)} DZD',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (isOnPromo)
                              Text(
                                '${product.price.toStringAsFixed(2)} DZD',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 34,
                          child: FilledButton.tonalIcon(
                            onPressed: isOutOfStock ? null : onAdd,
                            icon: const Icon(Icons.add_shopping_cart, size: 14),
                            label: Text(
                              l10n.add,
                              style: const TextStyle(fontSize: 11),
                            ),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final resolvedImageUrl = CommerceConfig.resolveImageUrl(product.imageUrl);
    final stock = product.stock;
    final isOutOfStock = stock != null && stock <= 0;
    final isLowStock = stock != null && stock > 0 && stock <= 3;
    final isOnPromo = product.isOnPromo;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openDetail(context, product),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Hero(
                      tag: 'product-hero-${product.id}',
                      child: resolvedImageUrl != null
                          ? Image.network(
                              resolvedImageUrl,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    alignment: Alignment.center,
                                    color: theme
                                        .colorScheme
                                        .surfaceContainerHighest,
                                    child: const Icon(Icons.broken_image),
                                  ),
                            )
                          : Container(
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: const Center(
                                child: Icon(Icons.videocam, size: 40),
                              ),
                            ),
                    ),
                  ),
                  if (isOnPromo)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          l10n.promoStatus.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 4,
                    right: isAdmin ? 40 : 4,
                    child: CircleAvatar(
                      backgroundColor: Colors.black26,
                      radius: 16,
                      child: IconButton(
                        iconSize: 16,
                        color: product.isFavorite ? Colors.red : Colors.white,
                        icon: Icon(
                          product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                        ),
                        onPressed: () {
                          context.read<CommerceProvider>().toggleFavorite(
                            product.id,
                          );
                        },
                      ),
                    ),
                  ),
                  if (isAdmin)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: CircleAvatar(
                        backgroundColor: Colors.black26,
                        radius: 16,
                        child: IconButton(
                          iconSize: 16,
                          color: Colors.white,
                          icon: const Icon(Icons.edit),
                          onPressed: onEdit,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${product.effectivePrice.toStringAsFixed(2)} DZD',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            if (isOnPromo)
                              Text(
                                '${product.price.toStringAsFixed(2)} DZD',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                          ],
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: isOutOfStock ? null : onAdd,
                        icon: const Icon(Icons.add_shopping_cart, size: 16),
                        constraints: const BoxConstraints.tightFor(
                          width: 34,
                          height: 34,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _StatusBadge(
                    text: isOutOfStock
                        ? l10n.outOfStockStatus
                        : (stock != null
                              ? '$stock ${l10n.stockLabel}'
                              : l10n.inStockFilter),
                    color: isOutOfStock
                        ? Colors.red
                        : (isLowStock ? Colors.orange : Colors.green),
                    isCompact: true,
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

class _ProductFormSheet extends StatefulWidget {
  final CommerceProvider provider;
  final Product? product;
  const _ProductFormSheet({required this.provider, this.product});
  @override
  State<_ProductFormSheet> createState() => _ProductFormSheetState();
}

class _ProductFormSheetState extends State<_ProductFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl,
      _skuCtrl,
      _descCtrl,
      _priceCtrl,
      _promoCtrl,
      _imageCtrl,
      _categoryCtrl,
      _stockCtrl,
      _popularityCtrl;
  late bool _isActive;
  bool _saving = false, _uploadingImage = false;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _skuCtrl = TextEditingController(text: p?.sku ?? '');
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _priceCtrl = TextEditingController(
      text: p != null ? p.price.toStringAsFixed(2) : '',
    );
    _promoCtrl = TextEditingController(
      text: p?.promoPrice != null ? p!.promoPrice!.toStringAsFixed(2) : '',
    );
    _imageCtrl = TextEditingController(text: p?.imageUrl ?? '');
    _categoryCtrl = TextEditingController(text: p?.category ?? '');
    _stockCtrl = TextEditingController(text: p?.stock?.toString() ?? '');
    _popularityCtrl = TextEditingController(
      text: p?.popularity.toString() ?? '',
    );
    _isActive = p?.isActive ?? true;
  }

  @override
  void dispose() {
    for (var c in [
      _nameCtrl,
      _skuCtrl,
      _descCtrl,
      _priceCtrl,
      _promoCtrl,
      _imageCtrl,
      _categoryCtrl,
      _stockCtrl,
      _popularityCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _onSave() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final p = Product(
      id: widget.product?.id ?? '',
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      price: double.parse(_priceCtrl.text.trim().replaceAll(',', '.')),
      promoPrice: _promoCtrl.text.trim().isEmpty
          ? null
          : double.parse(_promoCtrl.text.trim().replaceAll(',', '.')),
      sku: _skuCtrl.text.trim().isEmpty ? null : _skuCtrl.text.trim(),
      imageUrl: _imageCtrl.text.trim().isEmpty ? null : _imageCtrl.text.trim(),
      category: _categoryCtrl.text.trim().isEmpty
          ? null
          : _categoryCtrl.text.trim(),
      stock: _stockCtrl.text.trim().isEmpty
          ? null
          : int.tryParse(_stockCtrl.text.trim()),
      popularity: int.tryParse(_popularityCtrl.text.trim()) ?? 0,
      isActive: _isActive,
    );
    final ok = await widget.provider.saveProduct(p);
    if (mounted) {
      setState(() => _saving = false);
      if (ok)
        Navigator.pop(context, true);
      else
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.saveFailed)));
    }
  }

  Future<void> _pickAndUploadImage() async {
    if (_uploadingImage) return;
    final l10n = AppLocalizations.of(context)!;
    final bucket = CommerceConfig.supabaseImagesBucket.trim();
    debugPrint('[Commerce] Image upload start: bucket="$bucket"');
    if (bucket.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.supabaseBucketNotConfigured)));
      return;
    }

    setState(() => _uploadingImage = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;

      final file = result.files.single;
      final bytes = file.bytes;
      if (bytes == null) throw Exception('No file data.');

      final extension = (file.extension ?? '').toLowerCase();
      final safeExtension = extension.isEmpty ? 'jpg' : extension;
      final fileName = '${Uuid().v4()}.$safeExtension';
      final contentType =
          _contentTypeForExtension(safeExtension) ?? 'application/octet-stream';
      debugPrint(
        '[Commerce] Image upload picked: name=${file.name} '
        'ext=$safeExtension bytes=${bytes.length} '
        'fileName=$fileName contentType=$contentType',
      );

      _logStorageDiagnostics(bucket);

      try {
        debugPrint('[Commerce] Bucket check start: "$bucket"');
        await SupabaseService.storageCheckBucket(bucket);
        debugPrint('[Commerce] Bucket check OK: id=$bucket');
      } catch (e) {
        debugPrint('[Commerce] Bucket check FAILED for "$bucket": $e');
      }

      debugPrint(
        '[Commerce] Upload start: path=$fileName bytes=${bytes.length} '
        'contentType=$contentType',
      );
      await SupabaseService.storageUploadBinary(
        bucket: bucket,
        path: fileName,
        bytes: bytes,
        contentType: contentType,
        upsert: true,
      );

      if (!mounted) return;
      setState(() => _imageCtrl.text = fileName);
      debugPrint('[Commerce] Image upload success: path=$fileName');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.imageUploaded)));
    } catch (e, st) {
      debugPrint('[Commerce] Image upload error: $e');
      debugPrint('[Commerce] Image upload stack: $st');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.imageUploadFailed(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _uploadingImage = false);
    }
  }

  String? _contentTypeForExtension(String ext) {
    switch (ext) {
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'webp':
        return 'image/webp';
      case 'gif':
        return 'image/gif';
      default:
        return null;
    }
  }

  void _logStorageDiagnostics(String bucket) {
    final storageUrl = SupabaseService.storageBaseUrl;
    final apikey = SupabaseService.storageAnonKey;
    final hasAuthHeader = true;
    final clientHeaders = Supabase.instance.client.headers;
    debugPrint(
      '[Commerce] Storage diag: storageUrl=$storageUrl bucket="$bucket" '
      'apikey=${_maskKey(apikey)} hasAuth=$hasAuthHeader '
      'storageHeaders=[apikey, Authorization] '
      'clientHeaders=${clientHeaders.keys.toList()}',
    );
  }

  String _maskKey(String? key) {
    if (key == null || key.isEmpty) return '<empty>';
    var value = key;
    if (value.startsWith('Bearer ')) {
      value = value.substring('Bearer '.length);
    }
    if (value.length <= 12) return '${value.substring(0, value.length)}(len=${value.length})';
    final prefix = value.substring(0, 12);
    final suffix = value.substring(value.length - 6);
    return '$prefix...$suffix(len=${value.length})';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product == null
                      ? l10n.addProductTitle
                      : l10n.editProductTitle,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _SectionHeader(label: l10n.productInfoSection),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.productNameLabel,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v?.isEmpty ?? true ? l10n.nameRequired : null,
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
                TextFormField(
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
                  decoration: InputDecoration(
                    labelText: l10n.priceLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _promoCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.promoPriceLabel,
                    border: const OutlineInputBorder(),
                    helperText: l10n.optionalHelper,
                  ),
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
                              : l10n.uploadImageButton,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () => setState(() => _imageCtrl.clear()),
                      child: Text(l10n.clear),
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
                        child: Image.network(
                          previewUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                _SectionHeader(label: l10n.productStockStatusSection),
                const SizedBox(height: 8),
                TextFormField(
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
                  decoration: InputDecoration(
                    labelText: l10n.stockLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _popularityCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.popularityLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _isActive,
                  title: Text(l10n.activeLabel),
                  onChanged: (v) => setState(() => _isActive = v),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _saving || _uploadingImage ? null : _onSave,
                    child: Text(_saving ? l10n.savingButton : l10n.saveButton),
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

class _Tag extends StatelessWidget {
  final String text;
  final bool isCompact;
  const _Tag({required this.text, this.isCompact = false});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 6 : 10,
        vertical: isCompact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(isCompact ? 6 : 12),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          fontSize: isCompact ? 10 : null,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final bool isCompact;
  const _StatusBadge({
    required this.text,
    required this.color,
    this.isCompact = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 6 : 8,
        vertical: isCompact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(isCompact ? 6 : 10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontSize: isCompact ? 10 : null,
          fontWeight: FontWeight.bold,
        ),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
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
      ),
    );
  }
}

class _ProductSkeletonList extends StatelessWidget {
  const _ProductSkeletonList();
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Card(child: Container(height: 100, width: double.infinity)),
      ),
    );
  }
}

class _CartTab extends StatelessWidget {
  final CommerceProvider provider;
  final TextEditingController phoneCtrl, addressCtrl, clientNameCtrl, noteCtrl;
  final bool placingOrder;
  final VoidCallback onSubmit;

  const _CartTab({
    required this.provider,
    required this.phoneCtrl,
    required this.addressCtrl,
    required this.clientNameCtrl,
    required this.noteCtrl,
    required this.placingOrder,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (provider.cartItems.isEmpty) return Center(child: Text(l10n.cartEmpty));
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  l10n.yourCart,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: provider.clearCart,
                  icon: const Icon(Icons.delete_sweep),
                  label: Text(l10n.clearCart),
                ),
              ],
            ),
            ...provider.cartItems.map(
              (item) => _CartItemRow(
                item: item,
                onIncrement: () =>
                    provider.updateQuantity(item.product.id, item.quantity + 1),
                onDecrement: () =>
                    provider.updateQuantity(item.product.id, item.quantity - 1),
                onRemove: () => provider.removeFromCart(item.product.id),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      controller: clientNameCtrl,
                      decoration: InputDecoration(
                        labelText: l10n.fullNameLabel,
                        hintText: l10n.optionalHelper,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: phoneCtrl,
                      decoration: InputDecoration(labelText: l10n.phoneLabel),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: addressCtrl,
                      decoration: InputDecoration(labelText: l10n.addressLabel),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: noteCtrl,
                      decoration: InputDecoration(
                        labelText: l10n.orderNoteLabel,
                      ),
                      maxLines: 2,
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
                  placingOrder
                      ? l10n.placingOrderButton
                      : l10n.placeOrderButton,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement, onDecrement, onRemove;
  const _CartItemRow({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(item.product.name),
        subtitle: Text('${item.subtotal.toStringAsFixed(2)} DZD'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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

class _OrdersTab extends StatelessWidget {
  final CommerceProvider provider;
  final VoidCallback onRefresh, onLoadMore;
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (provider.ordersLoading)
      return const Center(child: CircularProgressIndicator());
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.orders.length + (provider.ordersHasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= provider.orders.length)
            return Center(
              child: TextButton(
                onPressed: onLoadMore,
                child: Text(l10n.loadMoreButton),
              ),
            );
          final order = provider.orders[index];
          return _OrderCard(
            order: order,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OrderDetailsScreen(orderId: order.id),
              ),
            ),
          );
        },
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
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(l10n.orderNumber(order.id.substring(0, 8))),
        subtitle: Text(order.status.label(l10n)),
        trailing: Text(
          '${order.total.toStringAsFixed(2)} DZD',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
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
