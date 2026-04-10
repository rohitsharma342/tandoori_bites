class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool isVegetarian;
  final bool isSpicy;
  final double rating;
  final int reviewCount;
  final List<String> customizations;
  final bool isAvailable;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.isVegetarian = false,
    this.isSpicy = false,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.customizations = const [],
    this.isAvailable = true,
  });

  MenuItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    bool? isVegetarian,
    bool? isSpicy,
    double? rating,
    int? reviewCount,
    List<String>? customizations,
    bool? isAvailable,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isSpicy: isSpicy ?? this.isSpicy,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      customizations: customizations ?? this.customizations,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}