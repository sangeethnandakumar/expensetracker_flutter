class CategoryModel {
  final String id;
  final String title;
  final String? icon;
  final String color;
  final String? customImage;

  CategoryModel({
    required this.id,
    required this.title,
    this.icon,
    required this.color,
    this.customImage,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      title: json['title'],
      icon: json['icon'],
      color: json['color'],
      customImage: json['customImage'],
    );
  }
}
