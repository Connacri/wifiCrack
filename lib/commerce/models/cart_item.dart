import 'cctv_product.dart';

class CartItem {
  final CctvProduct product;
  final int quantity;

  const CartItem({
    required this.product,
    required this.quantity,
  });

  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }

  double get subtotal => product.effectivePrice * quantity;
}
