class ProductModel {
  final String id;
  final String title;
  final String category;
  final double price;
  final String unit;
  final double rating;
  final int reviewCount;
  final bool inStock;
  final String description;
  final String imageUrl;

  const ProductModel({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.unit,
    required this.rating,
    required this.reviewCount,
    required this.inStock,
    required this.description,
    required this.imageUrl,
  });
}
