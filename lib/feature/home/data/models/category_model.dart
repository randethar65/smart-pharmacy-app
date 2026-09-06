class CategoryModel {
  final int id;
  final String name;
  final String? image;

  CategoryModel({
    required this.id,
    required this.name,
    this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      // لو ما في ترجمة للغة المطلوبة، الباك يرجّع name = null.
      name: json['name'] as String? ?? '',
      image: json['image'] as String?,
    );
  }

  static List<CategoryModel> categoriesFromJson(List<dynamic> json) {
    return json
        .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
