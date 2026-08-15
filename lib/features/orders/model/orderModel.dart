// lib/features/orders/model/orderModel.dart

enum OrderStatus {
  Pending,
  Processing,
  Shipping,
  Shipped,
  Delivering,
  Delivered,
  Confirmed,
  Cancelled;

  static OrderStatus fromString(String value) {
    return values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => Pending,
    );
  }
}

extension OrderStatusX on OrderStatus {
  String get label => name;

  bool get isPending => this == OrderStatus.Pending;
  bool get isProcessing => this == OrderStatus.Processing;
  bool get isShipping => this == OrderStatus.Shipping;
  bool get isShipped => this == OrderStatus.Shipped;
  bool get isDelivering => this == OrderStatus.Delivering;
  bool get isDelivered => this == OrderStatus.Delivered;
  bool get isConfirmed => this == OrderStatus.Confirmed;
  bool get isCancelled => this == OrderStatus.Cancelled;

  int get progressStep {
    switch (this) {
      case OrderStatus.Pending:
        return 0;
      case OrderStatus.Processing:
        return 1;
      case OrderStatus.Shipping:
        return 2;
      case OrderStatus.Shipped:
        return 3;
      case OrderStatus.Delivering:
        return 4;
      case OrderStatus.Delivered:
        return 5;
      case OrderStatus.Confirmed:
        return 6;
      case OrderStatus.Cancelled:
        return -1;
    }
  }

  bool get showTrackButton =>
      this != OrderStatus.Delivered &&
      this != OrderStatus.Confirmed &&
      this != OrderStatus.Cancelled;
}

// ─── Order Item ───────────────────────────────────────────────────────────────

class OrderItem {
  final String id;
  final String imageUrl;
  final double price;
  final String title;
  final int quantity;

  OrderItem({
    required this.id,
    required this.imageUrl,
    required this.price,
    required this.title,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as String,
      imageUrl: json['image_url'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      title: json['title'] as String,
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'image_url': imageUrl,
    'price': price,
    'title': title,
    'quantity': quantity,
  };
}

// ─── Tracking Event ───────────────────────────────────────────────────────────
//
// Each entry in the timeline the backend has already recorded.
// Future steps the backend has NOT yet recorded are inferred on the
// client from the current status, so the list only ever contains
// completed/current events — never speculative future ones.

class OrderTrackingEvent {
  final String title;
  final String description;
  final DateTime timestamp;
  final bool isCurrent; // true for the most-recent (active) event

  OrderTrackingEvent({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.isCurrent,
  });

  factory OrderTrackingEvent.fromJson(Map<String, dynamic> json) {
    return OrderTrackingEvent(
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      timestamp: DateTime.parse(json['timestamp'] as String),
      isCurrent: json['is_current'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'timestamp': timestamp.toIso8601String(),
    'is_current': isCurrent,
  };
}

// ─── Order ────────────────────────────────────────────────────────────────────

class Order {
  final String id;
  final String orderNumber;

  // Delivery / shipping flags
  final bool? hasDelivery;
  final bool? hasShipping;
  final String? shippingCompany; // e.g. "LGS"
  final String? trackingNumber; // e.g. "LGS-9228715300763731"

  // Status
  final OrderStatus status;

  // Counts & pricing
  final int itemCount;
  final double totalPrice;
  final double? shippingFee;
  final double? deliveryFee;

  // Items
  final List<OrderItem> orderItems;

  // Timeline events (only past/current — future steps are UI-generated)
  final List<OrderTrackingEvent> trackingEvents;

  Order({
    required this.id,
    required this.orderNumber,
    this.hasDelivery,
    this.hasShipping,
    this.shippingCompany,
    this.trackingNumber,
    required this.status,
    required this.itemCount,
    required this.totalPrice,
    this.shippingFee,
    this.deliveryFee,
    required this.orderItems,
    this.trackingEvents = const [],
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      orderNumber: json['order_number'] as String,
      hasDelivery: json['has_delivery'] as bool?,
      hasShipping: json['has_shipping'] as bool?,
      shippingCompany: json['shipping_company'] as String?,
      trackingNumber: json['tracking_number'] as String?,
      status: OrderStatus.fromString(json['status'] as String),
      itemCount: json['item_count'] as int,
      totalPrice: (json['total_price'] as num).toDouble(),
      shippingFee:
          json['shipping_fee'] != null
              ? (json['shipping_fee'] as num).toDouble()
              : null,
      deliveryFee:
          json['delivery_fee'] != null
              ? (json['delivery_fee'] as num).toDouble()
              : null,
      orderItems:
          (json['order_items'] as List<dynamic>)
              .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList(),
      trackingEvents:
          json['tracking_events'] != null
              ? (json['tracking_events'] as List<dynamic>)
                  .map(
                    (e) =>
                        OrderTrackingEvent.fromJson(e as Map<String, dynamic>),
                  )
                  .toList()
              : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'order_number': orderNumber,
    'has_delivery': hasDelivery,
    'has_shipping': hasShipping,
    'shipping_company': shippingCompany,
    'tracking_number': trackingNumber,
    'status': status.name,
    'item_count': itemCount,
    'total_price': totalPrice,
    'shipping_fee': shippingFee,
    'delivery_fee': deliveryFee,
    'order_items': orderItems.map((e) => e.toJson()).toList(),
    'tracking_events': trackingEvents.map((e) => e.toJson()).toList(),
  };

  String get displayDeliveryType {
    if (hasDelivery == true) return 'Standard Delivery';
    if (hasShipping == true) return 'Standard Shipping';
    return 'Standard Delivery';
  }
}
