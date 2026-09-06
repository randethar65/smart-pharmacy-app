class Product {
  final int id;
  final String image;
  final double price;
  final int stockQuantity;
  final bool needsPrescription;
  final int categoryId;
  final String name;
  final String description;
  final List<String> subImages;

  Product({
    required this.id,
    required this.image,
    required this.price,
    required this.stockQuantity,
    required this.needsPrescription,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.subImages,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      stockQuantity: json['stockQuantity'],
      needsPrescription: json['needsPrescription'],
      categoryId: json['categoryId'],
      name: json['name'],
      description: json['description'],
      subImages: List<String>.from(json['subImages'] ?? []),
    );
  }
}