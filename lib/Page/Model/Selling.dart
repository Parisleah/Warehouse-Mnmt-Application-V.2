const String tableSelling = 'selling';

class SellingFields {
  static final List<String> values = [
    selId,
    orderedDate,
    customerId,
    cAddreId,
    shipping,
    shippingCost,
    amount,
    discountPercent,
    total,
    speacialReq,
    isDelivered,
    shopId
  ];

  static final String selId = 'selId';
  static final String orderedDate = 'orderedDate';
  static final String customerId = 'customerId';
  static final String cAddreId = 'cAddreId';
  static final String shipping = 'shipping';
  static final String shippingCost = 'shippingCost';
  static final String amount = 'amount';
  static final String discountPercent = 'discountPercent';
  static final String total = 'total';
  static final String speacialReq = 'speacialReq';
  static final String isDelivered = 'isDelivered';
  static final String shopId = 'shopId';
}

class SellingModel {
  final int? selId;
  final DateTime orderedDate;
  final int customerId;
  final int cAddreId;
  final String? shipping;
  final int shippingCost;
  final int amount;
  final int discountPercent;
  final int total;
  final String? speacialReq;
  final bool isDelivered;
  final int? shopId;

  SellingModel(
      {this.selId,
      required this.orderedDate,
      required this.customerId,
      required this.cAddreId,
      required this.shipping,
      required this.shippingCost,
      required this.amount,
      required this.discountPercent,
      required this.total,
      required this.speacialReq,
      required this.isDelivered,
      required this.shopId});
  SellingModel copy({
    int? selId,
    DateTime? orderedDate,
    int? customerId,
    int? cAddreId,
    int? shippingCost,
    String? shipping,
    int? amount,
    int? discountPercent,
    int? total,
    String? speacialReq,
    bool? isDelivered,
    int? shopId,
  }) =>
      SellingModel(
          selId: selId ?? this.selId,
          orderedDate: orderedDate ?? this.orderedDate,
          customerId: customerId ?? this.customerId,
          cAddreId: cAddreId ?? this.cAddreId,
          shipping: shipping ?? this.shipping,
          shippingCost: shippingCost ?? this.shippingCost,
          amount: amount ?? this.amount,
          discountPercent: discountPercent ?? this.discountPercent,
          total: total ?? this.total,
          speacialReq: speacialReq ?? this.speacialReq,
          isDelivered: isDelivered ?? this.isDelivered,
          shopId: shopId ?? this.shopId);
  static SellingModel fromJson(Map<String, Object?> json) => SellingModel(
        selId: json[SellingFields.selId] as int?,
        orderedDate: DateTime.parse(json[SellingFields.orderedDate] as String),
        customerId: json[SellingFields.customerId] as int,
        cAddreId: json[SellingFields.cAddreId] as int,
        shipping: json[SellingFields.shipping] as String,
        shippingCost: json[SellingFields.shippingCost] as int,
        amount: json[SellingFields.amount] as int,
        discountPercent: json[SellingFields.discountPercent] as int,
        total: json[SellingFields.total] as int,
        speacialReq: json[SellingFields.speacialReq] as String,
        isDelivered: json[SellingFields.isDelivered] == 1,
        shopId: json[SellingFields.shopId] as int,
      );
  Map<String, Object?> toJson() => {
        SellingFields.selId: selId,
        SellingFields.orderedDate: orderedDate.toIso8601String(),
        SellingFields.customerId: customerId,
        SellingFields.cAddreId: cAddreId,
        SellingFields.shipping: shipping,
        SellingFields.shippingCost: shippingCost,
        SellingFields.amount: amount,
        SellingFields.speacialReq: speacialReq,
        SellingFields.discountPercent: discountPercent,
        SellingFields.total: total,
        SellingFields.isDelivered: isDelivered ? 1 : 0,
        SellingFields.shopId: shopId,
      };
}
