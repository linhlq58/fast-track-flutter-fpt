import '../models/product.dart';

class ProductRepository {
  ProductRepository()
      : _products = [
          const Product(
            id: '1',
            name: 'Mechanical Keyboard',
            description: 'A compact mechanical keyboard.',
            price: 89.99,
          ),
          const Product(
            id: '2',
            name: 'Wireless Mouse',
            description: 'An ergonomic wireless mouse.',
            price: 39.99,
          ),
          const Product(
            id: '3',
            name: 'USB-C Hub',
            description: 'A multi-port USB-C adapter.',
            price: 49.99,
          ),
        ];

  final List<Product> _products;

  Future<List<Product>> getProducts() async {
    // Return a copy so callers cannot modify the internal list.
    return List.unmodifiable(_products);
  }

  Future<Product?> getProductById(String id) async {
    for (final product in _products) {
      if (product.id == id) {
        return product;
      }
    }

    return null;
  }

  Future<void> updateProduct(Product updatedProduct) async {
    final index = _products.indexWhere(
      (product) => product.id == updatedProduct.id,
    );

    if (index == -1) {
      throw StateError(
        'Product with ID ${updatedProduct.id} was not found.',
      );
    }

    _products[index] = updatedProduct;
  }
}