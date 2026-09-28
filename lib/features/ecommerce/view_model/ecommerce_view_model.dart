import 'package:cooli/features/ecommerce/model/product_model.dart';
import 'package:cooli/features/ecommerce/model/cart_model.dart';
import 'package:cooli/features/ecommerce/model/order_model.dart';
import 'package:cooli/features/ecommerce/repo/ecommerce_repo.dart';
import 'package:cooli/providers/view_model.dart';

class EcommerceViewModel extends ViewModel {
  final EcommerceRepo _repo;

  EcommerceViewModel({EcommerceRepo? repo}) : _repo = repo ?? EcommerceRepo() {
    loadProducts();
    _initSampleCart();
  }

  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  List<ProductModel> get products => _filteredProducts;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  final List<String> categories = ['All', 'Sand', 'Bricks', 'Cement', 'Aggregates'];

  // Cart
  final List<CartItemModel> _cartItems = [];
  List<CartItemModel> get cartItems => _cartItems;

  int _productQuantity = 1;
  int get productQuantity => _productQuantity;

  // Checkout
  String _selectedPaymentMethod = 'UPI';
  String get selectedPaymentMethod => _selectedPaymentMethod;

  int _checkoutStep = 3; // Step 3: Payment
  int get checkoutStep => _checkoutStep;

  OrderModel? _currentOrder;
  OrderModel? get currentOrder => _currentOrder;

  double get subtotal =>
      _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get deliveryFee => _cartItems.isEmpty ? 0.0 : 250.0;
  double get totalAmount => subtotal + deliveryFee;

  void loadProducts() {
    _allProducts = _repo.getProducts();
    _filteredProducts = List.from(_allProducts);
    _currentOrder = _repo.getSampleOrder();
    notifyListeners();
  }

  void _initSampleCart() {
    if (_allProducts.length >= 2) {
      _cartItems.add(CartItemModel(product: _allProducts[0], quantity: 2));
      _cartItems.add(CartItemModel(product: _allProducts[1], quantity: 1));
    }
  }

  void filterCategory(String category) {
    _selectedCategory = category;
    if (category == 'All') {
      _filteredProducts = List.from(_allProducts);
    } else {
      _filteredProducts =
          _allProducts.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
    }
    notifyListeners();
  }

  void setProductQuantity(int quantity) {
    if (quantity >= 1) {
      _productQuantity = quantity;
      notifyListeners();
    }
  }

  void addToCart(ProductModel product, {int quantity = 1}) {
    final existingIndex = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += quantity;
    } else {
      _cartItems.add(CartItemModel(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void updateCartItemQuantity(CartItemModel item, int delta) {
    item.quantity += delta;
    if (item.quantity <= 0) {
      _cartItems.remove(item);
    }
    notifyListeners();
  }

  void removeCartItem(CartItemModel item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  void setCheckoutStep(int step) {
    _checkoutStep = step;
    notifyListeners();
  }
}
