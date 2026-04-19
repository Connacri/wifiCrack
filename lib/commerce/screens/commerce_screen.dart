import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
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
  UserRole? _lastRole;

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

    // Rôles qui voient UNIQUEMENT leurs propres commandes
    const clientRoles = {UserRole.client, UserRole.wholesaler};

    // Carrier, driver, warehouse, support, admin voient TOUTES les commandes
    final filterUserId = clientRoles.contains(provider.currentRole)
        ? effectiveUserId
        : null;

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

    if (phone.isEmpty || address.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.phoneAddressRequired),
        ),
      );
      return;
    }

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
      _tabController?.animateTo(1);
      _refreshOrders();

      final message = orderId.trim().isEmpty
          ? l10n.orderCreated
          : l10n.orderCreatedLong(orderId);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
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

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.admin: return Icons.admin_panel_settings;
      case UserRole.support: return Icons.support_agent;
      case UserRole.warehouse: return Icons.inventory_2;
      case UserRole.carrier: return Icons.local_shipping;
      case UserRole.driver: return Icons.delivery_dining;
      case UserRole.wholesaler: return Icons.business;
      case UserRole.client: return Icons.person;
    }
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

    if (_lastRole != provider.currentRole) {
      _lastRole = provider.currentRole;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _refreshOrders();
      });
    }

    final showLogistics =
        provider.currentRole == UserRole.warehouse ||
        provider.currentRole == UserRole.carrier ||
        provider.currentRole == UserRole.driver ||
        provider.currentRole == UserRole.admin ||
        provider.currentRole == UserRole.support;

    final String logisticsTitle = provider.currentRole == UserRole.carrier
        ? l10n.toPickUp
        : (provider.currentRole == UserRole.driver
            ? l10n.toDeliver
            : (provider.currentRole == UserRole.warehouse
                ? l10n.toPrepare
                : l10n.logisticsTab));

    final tabs = <Tab>[
      Tab(text: l10n.productsTab),
      if (showLogistics)
        Tab(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(logisticsTitle),
            ],
          ),
        ),
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
                  PopupMenuButton<UserRole>(
                    tooltip: 'Changer de rôle (Simulation)',
                    icon: Icon(
                      _isAdminMode
                          ? Icons.admin_panel_settings
                          : Icons.person_outline,
                      color: _isAdminMode ? Colors.orange : null,
                    ),
                    onSelected: (role) {
                      provider.setRole(role);
                      setState(() {
                        _isAdminMode = role == UserRole.admin || role == UserRole.support;
                      });
                    },
                    itemBuilder: (context) => UserRole.values.map((role) {
                      final isSelected = provider.currentRole == role;
                      return PopupMenuItem(
                        value: role,
                        child: Row(
                          children: [
                            Icon(
                              _getRoleIcon(role),
                              size: 20,
                              color: isSelected ? Colors.blue : Colors.grey,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              role.toString().split('.').last.toUpperCase(),
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : null,
                                color: isSelected ? Colors.blue : null,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
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
                  if (showLogistics)
                    _LogisticsTab(
                      provider: provider,
                      onRefresh: _refreshOrders,
                    ),
                  _OrdersTab(
                    provider: provider,
                    onRefresh: _refreshOrders,
                    onLoadMore: provider.loadMoreOrders,
                    onUpdateStatus: provider.updateOrderStatus,
                    isUpdating: provider.isUpdatingOrder,
                    canUpdateStatus: _isAdminMode,
                    currentRole: provider.currentRole,
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
                DefaultTabController.of(context),
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
                  onPressed: () => controller.animateTo(controller.length - 1),
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
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    widget.searchCtrl.removeListener(_searchListener);
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollCtrl.hasClients) return;
    if (_scrollCtrl.position.maxScrollExtent - _scrollCtrl.position.pixels <= 320) {
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

  List<Product> _applyFilters(List<Product> products, String? activeCategory, {bool applyFavoritesFilter = true, String? searchQuery}) {
    var filtered = products;
    if (activeCategory != null) filtered = filtered.where((p) => (p.category ?? '').trim() == activeCategory).toList();
    if (_inStockOnly) filtered = filtered.where((p) => p.stock == null || p.stock! > 0).toList();
    final q = searchQuery?.trim() ?? '';
    if (q.isNotEmpty) filtered = filtered.where((p) => _matchesSearch(p, q)).toList();
    if (applyFavoritesFilter && _favoritesOnly) filtered = filtered.where((p) => p.isFavorite).toList();
    return filtered;
  }

  bool _matchesSearch(Product product, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return product.name.toLowerCase().contains(q) || (product.sku?.toLowerCase() ?? '').contains(q);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final products = _applyFilters(widget.provider.products, _selectedCategory, searchQuery: widget.searchCtrl.text);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: widget.searchCtrl,
            decoration: InputDecoration(
              hintText: l10n.searchProductsPlaceholder,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        Expanded(
          child: widget.provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  controller: _scrollCtrl,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _ProductCard(
                      product: product,
                      isAdmin: widget.isAdmin,
                      onAdd: () => widget.provider.addToCart(product),
                      onEdit: widget.onEditProduct != null ? () => widget.onEditProduct!(product) : null,
                      onDelete: widget.onDeleteProduct != null ? () => widget.onDeleteProduct!(product) : null,
                    );
                  },
                ),
        ),
      ],
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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => _openDetail(context, product),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: resolvedImageUrl != null
                    ? Image.network(resolvedImageUrl, width: 80, height: 80, fit: BoxFit.cover)
                    : Container(width: 80, height: 80, color: Colors.grey[200], child: const Icon(Icons.image)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: theme.textTheme.titleMedium),
                    Text('${product.effectivePrice.toStringAsFixed(2)} DZD', style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              if (isAdmin)
                IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
              IconButton(icon: const Icon(Icons.add_shopping_cart), onPressed: onAdd),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrdersTab extends StatefulWidget {
  final CommerceProvider provider;
  final VoidCallback onRefresh, onLoadMore;
  final Future<bool> Function({required String orderId, required String status}) onUpdateStatus;
  final bool Function(String orderId) isUpdating;
  final bool canUpdateStatus;
  final UserRole currentRole;

  const _OrdersTab({
    required this.provider,
    required this.onRefresh,
    required this.onLoadMore,
    required this.onUpdateStatus,
    required this.isUpdating,
    required this.canUpdateStatus,
    required this.currentRole,
  });

  @override
  State<_OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<_OrdersTab> {
  late final ScrollController _scrollCtrl;

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollCtrl.hasClients) return;
    if (_scrollCtrl.position.maxScrollExtent - _scrollCtrl.position.pixels <= 320) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = widget.provider;
    if (provider.ordersLoading) return const Center(child: CircularProgressIndicator());
    return RefreshIndicator(
      onRefresh: () async => widget.onRefresh(),
      child: ListView.builder(
        controller: _scrollCtrl,
        padding: const EdgeInsets.all(16),
        itemCount: provider.orders.length,
        itemBuilder: (context, index) {
          final order = provider.orders[index];
          return _OrderCard(
            order: order,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderId: order.id)),
            ),
          );
        },
      ),
    );
  }
}

class _LogisticsTab extends StatelessWidget {
  final CommerceProvider provider;
  final VoidCallback onRefresh;

  const _LogisticsTab({required this.provider, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final role = provider.currentRole;

    final logisticsOrders = provider.orders.where((order) {
      final status = OrderStatus.fromJson(order.status);
      if (role == UserRole.warehouse) {
        return status == OrderStatus.orderConfirmed || status == OrderStatus.picking || status == OrderStatus.packed;
      } else if (role == UserRole.carrier) {
        return status == OrderStatus.readyToShip || status == OrderStatus.shipped;
      } else if (role == UserRole.driver) {
        return status == OrderStatus.shipped;
      } else if (role == UserRole.admin) {
        return true;
      }
      return false;
    }).toList();

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: logisticsOrders.length,
        itemBuilder: (context, index) {
          final order = logisticsOrders[index];
          return _OrderCard(
            order: order,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderId: order.id)),
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

  Color _getStatusColor(String status) {
    final s = OrderStatus.fromJson(status);
    switch (s) {
      case OrderStatus.delivered: return Colors.green;
      case OrderStatus.readyToShip:
      case OrderStatus.shipped: return Colors.orange;
      case OrderStatus.cancelled: return Colors.red;
      default: return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.shopping_bag, color: _getStatusColor(order.status)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.orderNumber(order.id.substring(0, 8)), style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(order.status),
                  ],
                ),
              ),
              Text('${order.total.toStringAsFixed(2)} DZD', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
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
    return Text(label.toUpperCase(), style: Theme.of(context).textTheme.labelLarge);
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
  late final TextEditingController _nameCtrl, _priceCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.product?.name ?? '');
    _priceCtrl = TextEditingController(text: widget.product?.price.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(controller: _nameCtrl, decoration: InputDecoration(labelText: l10n.productNameLabel)),
            TextFormField(controller: _priceCtrl, decoration: InputDecoration(labelText: l10n.priceLabel), keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saving ? null : () async {
                if (_formKey.currentState!.validate()) {
                  setState(() => _saving = true);
                  final p = Product(
                    id: widget.product?.id ?? '',
                    name: _nameCtrl.text,
                    price: double.parse(_priceCtrl.text),
                    popularity: widget.product?.popularity ?? 0,
                  );
                  await widget.provider.saveProduct(p);
                  if (mounted) Navigator.pop(context, true);
                }
              },
              child: Text(l10n.saveButton),
            ),
            const SizedBox(height: 16),
          ],
        ),
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...provider.cartItems.map((item) => ListTile(title: Text(item.product.name), subtitle: Text('${item.quantity} x ${item.product.price}'))),
        TextField(controller: phoneCtrl, decoration: InputDecoration(labelText: l10n.phoneLabel)),
        TextField(controller: addressCtrl, decoration: InputDecoration(labelText: l10n.addressLabel)),
        ElevatedButton(onPressed: onSubmit, child: Text(l10n.checkoutButton)),
      ],
    );
  }
}
