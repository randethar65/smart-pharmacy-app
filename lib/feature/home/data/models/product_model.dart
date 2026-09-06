class ProductModel {
  final int id;
  final String name;
  final String? description;
  final String? image;
  final List<String> subImages;
  final double price;
  final int stockQuantity;
  final bool needsPrescription;
  final int categoryId;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    this.image,
    this.subImages = const [],
    required this.price,
    required this.stockQuantity,
    required this.needsPrescription,
    required this.categoryId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      // لو ما في ترجمة للغة المطلوبة، الباك يرجّع name/description = null.
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      image: json['image'] as String?,
      subImages: (json['subImages'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      price: (json['price'] as num).toDouble(),
      stockQuantity: json['stockQuantity'] as int? ?? 0,
      needsPrescription: json['needsPrescription'] as bool? ?? false,
      categoryId: json['categoryId'] as int? ?? 0,
    );
  }

  static List<ProductModel> productsFromJson(List<dynamic> json) {
    return json
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

/// One page of the product catalog — mirrors the backend's
/// `PagenationResponse<ProductResponse>` (data + page/totalPage), so the UI
/// can tell whether there's a next page to load.
class ProductListResult {
  final List<ProductModel> products;
  final int page;
  final int totalPages;

  ProductListResult({
    required this.products,
    required this.page,
    required this.totalPages,
  });

  bool get hasMore => page < totalPages;
}
