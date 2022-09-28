const String tableProduct = 'product';

class ProductFields {
  static final List<String> values = [
    prodId,
    prodName,
    prodDescription,
    prodImage,
    prodCategId,
    shopId
  ];

  static final String prodId = 'prodId';
  static final String prodName = 'prodName';
  static final String prodDescription = 'prodDescription';
  static final String prodImage = 'prodImage';
    static final String prodCategId = 'prodCategId';
  static final String shopId = 'shopId';
}

class Product {
  final int? prodId;
  final String prodName;
  final String? prodDescription;
  final String? prodImage;
  final String? prodCategId;
  final String shopId;

  Product({
    this.prodId,
    required this.prodName,
    this.prodDescription,
    this.prodImage,
    this.prodCategId,
    required this.shopId,
  });
  Product copy({
    int? prodId,
    String? prodName,
    String? prodDescription,
    String? prodImage,
    String? prodCategId,
    String? shopId,
  }) =>
      Product(
        prodId: prodId ?? this.prodId,
        prodName: prodName ?? this.prodName,
        prodDescription: prodDescription ?? this.prodDescription,
        prodImage: prodImage ?? this.prodImage,
        prodCategId: prodCategId ?? this.prodCategId,
        shopId: shopId ?? this.shopId,
      );
  static Product fromJson(Map<String, Object?> json) => Product(
        prodId: json[ProductFields.prodId] as int,
        prodName: json[ProductFields.prodName] as String,
        prodDescription: json[ProductFields.prodDescription] as String,
        prodImage: json[ProductFields.prodImage] as String,
        shopId: json[ProductFields.shopId] as String,
      );
  Map<String, Object?> toJson() => {
        ProductFields.prodId: prodId,
        ProductFields.prodName: prodName,
        ProductFields.prodDescription: prodDescription,
        ProductFields.prodImage: prodImage,
        ProductFields.shopId: shopId,
      };
}
