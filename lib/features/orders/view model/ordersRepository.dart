import 'package:dio/dio.dart';
import '../model/orderModel.dart';

abstract class OrdersRepository {
  Future<List<Order>> getOrders();
  Future<Order> getOrderById(String orderId);
  Future<void> trackOrder(String orderId);
  Future<void> reviewOrder(String orderId, {String? review, double? rating});
  Future<Order> changeOrderStatus(String orderId, OrderStatus newStatus);
}

class OrdersRepositoryImpl implements OrdersRepository {
  final Dio _dio;
  List<Order>? _mockCache;

  OrdersRepositoryImpl({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://your-api-base-url.com',
              headers: {'Content-Type': 'application/json'},
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  @override
  Future<List<Order>> getOrders() async {
    /* Swap to live API:
    final response = await _dio.get('/api/orders');
    final List<dynamic> payload = response.data['data'] as List<dynamic>;
    return payload.map((e) => Order.fromJson(e as Map<String, dynamic>)).toList();
    */
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockOrders();
  }

  @override
  Future<Order> getOrderById(String orderId) async {
    /* Swap to live API:
    final response = await _dio.get('/api/orders/$orderId');
    final payload = response.data['data'] as Map<String, dynamic>;
    return Order.fromJson(payload);
    */
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockOrders().firstWhere((o) => o.id == orderId);
  }

  @override
  Future<void> trackOrder(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<void> reviewOrder(
    String orderId, {
    String? review,
    double? rating,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<Order> changeOrderStatus(String orderId, OrderStatus newStatus) async {
    /* Swap to live API:
    final response = await _dio.post(
      '/api/changeOrderStatus',
      data: {
        'order_id': orderId,
        'status': newStatus.name,
      },
    );
    final payload = response.data['data'] as Map<String, dynamic>;
    return Order.fromJson(payload);
    */
    await Future.delayed(const Duration(milliseconds: 600));

    final orders = _mockOrders();
    final index = orders.indexWhere((o) => o.id == orderId);
    if (index == -1) throw Exception('Order not found');

    final old = orders[index];
    final updated = Order(
      id: old.id,
      orderNumber: old.orderNumber,
      hasDelivery: old.hasDelivery,
      hasShipping: old.hasShipping,
      shippingCompany: old.shippingCompany,
      trackingNumber: old.trackingNumber,
      status: newStatus,
      itemCount: old.itemCount,
      totalPrice: old.totalPrice,
      shippingFee: old.shippingFee,
      deliveryFee: old.deliveryFee,
      orderItems: old.orderItems,
      trackingEvents: old.trackingEvents,
    );

    orders[index] = updated;
    return updated;
  }

  List<Order> _mockOrders() {
    if (_mockCache != null) return _mockCache!;

    _mockCache = [
      Order(
        id: '1',
        orderNumber: '#92287157',
        status: OrderStatus.Pending,
        itemCount: 3,
        totalPrice: 145.00,
        hasDelivery: true,
        shippingFee: 5.00,
        orderItems: [
          OrderItem(
            id: 'p1',
            imageUrl: '',
            price: 45.0,
            title: 'Pink Sweater',
            quantity: 1,
          ),
          OrderItem(
            id: 'p2',
            imageUrl: '',
            price: 60.0,
            title: 'Red Bag',
            quantity: 1,
          ),
          OrderItem(
            id: 'p3',
            imageUrl: '',
            price: 40.0,
            title: 'White Shirt',
            quantity: 1,
          ),
        ],
      ),
      Order(
        id: '2',
        orderNumber: '#92287158',
        status: OrderStatus.Processing,
        itemCount: 4,
        totalPrice: 220.00,
        hasDelivery: true,
        shippingFee: 5.00,
        orderItems: [
          OrderItem(
            id: 'p4',
            imageUrl: '',
            price: 55.0,
            title: 'Blue Sneakers',
            quantity: 1,
          ),
          OrderItem(
            id: 'p5',
            imageUrl: '',
            price: 80.0,
            title: 'Denim Jacket',
            quantity: 1,
          ),
          OrderItem(
            id: 'p6',
            imageUrl: '',
            price: 45.0,
            title: 'White Tee',
            quantity: 1,
          ),
          OrderItem(
            id: 'p7',
            imageUrl: '',
            price: 40.0,
            title: 'Yellow Dress',
            quantity: 1,
          ),
        ],
      ),
      Order(
        id: '3',
        orderNumber: '#92287159',
        status: OrderStatus.Shipping,
        itemCount: 2,
        totalPrice: 90.00,
        hasShipping: true,
        shippingCompany: 'LGS',
        shippingFee: 10.00,
        trackingNumber: 'LGS-9228715900763731',
        orderItems: [
          OrderItem(
            id: 'p8',
            imageUrl: 'https://cdn.example.com/items/p8.jpg',
            price: 50.0,
            title: 'Beige Coat',
            quantity: 2,
          ),
          OrderItem(
            id: 'p9',
            imageUrl: 'https://cdn.example.com/items/p9.jpg',
            price: 40.0,
            title: 'Red Hoodie',
            quantity: 1,
          ),
        ],
        trackingEvents: [
          OrderTrackingEvent(
            title: 'Packed',
            description:
                'Your parcel is packed and will be handed over to our delivery partner.',
            timestamp: DateTime.parse('2025-08-12T09:30:00Z'),
            isCurrent: false,
          ),
          OrderTrackingEvent(
            title: 'On the Way to Logistic Facility',
            description:
                'Your parcel is on its way to the nearest logistic facility.',
            timestamp: DateTime.parse('2025-08-12T14:00:00Z'),
            isCurrent: false,
          ),
          OrderTrackingEvent(
            title: 'Arrived at Logistic Facility',
            description:
                'Your parcel has arrived at the logistic facility and is being processed.',
            timestamp: DateTime.parse('2025-08-13T08:45:00Z'),
            isCurrent: true,
          ),
        ],
      ),
      Order(
        id: '4',
        orderNumber: '#92287160',
        status: OrderStatus.Shipped,
        itemCount: 5,
        totalPrice: 310.00,
        hasShipping: true,
        shippingCompany: 'LGS',
        shippingFee: 10.00,
        orderItems: [
          OrderItem(
            id: 'p10',
            imageUrl: '',
            price: 60.0,
            title: 'Pink Bag',
            quantity: 1,
          ),
          OrderItem(
            id: 'p11',
            imageUrl: '',
            price: 70.0,
            title: 'Blue Dress',
            quantity: 1,
          ),
          OrderItem(
            id: 'p12',
            imageUrl: '',
            price: 55.0,
            title: 'Black Top',
            quantity: 1,
          ),
          OrderItem(
            id: 'p13',
            imageUrl: '',
            price: 65.0,
            title: 'White Sneakers',
            quantity: 1,
          ),
          OrderItem(
            id: 'p14',
            imageUrl: '',
            price: 60.0,
            title: 'Grey Cardigan',
            quantity: 1,
          ),
        ],
      ),
      Order(
        id: '5',
        orderNumber: '#92287161',
        status: OrderStatus.Delivering,
        itemCount: 1,
        totalPrice: 75.00,
        hasDelivery: true,
        deliveryFee: 5.00,
        orderItems: [
          OrderItem(
            id: 'p15',
            imageUrl: '',
            price: 75.0,
            title: 'Purple Scarf',
            quantity: 1,
          ),
        ],
      ),
      Order(
        id: '6',
        orderNumber: '#92287162',
        status: OrderStatus.Delivered,
        itemCount: 2,
        totalPrice: 130.00,
        hasDelivery: true,
        deliveryFee: 5.00,
        orderItems: [
          OrderItem(
            id: 'p16',
            imageUrl: '',
            price: 80.0,
            title: 'Leather Boots',
            quantity: 1,
          ),
          OrderItem(
            id: 'p17',
            imageUrl: '',
            price: 50.0,
            title: 'Wool Hat',
            quantity: 1,
          ),
        ],
      ),
      Order(
        id: '7',
        orderNumber: '#92287163',
        status: OrderStatus.Confirmed,
        itemCount: 3,
        totalPrice: 180.00,
        hasDelivery: true,
        orderItems: [
          OrderItem(
            id: 'p18',
            imageUrl: '',
            price: 60.0,
            title: 'Silk Blouse',
            quantity: 1,
          ),
          OrderItem(
            id: 'p19',
            imageUrl: '',
            price: 70.0,
            title: 'Pleated Skirt',
            quantity: 1,
          ),
          OrderItem(
            id: 'p20',
            imageUrl: '',
            price: 50.0,
            title: 'Gold Earrings',
            quantity: 1,
          ),
        ],
      ),
      Order(
        id: '8',
        orderNumber: '#92287164',
        status: OrderStatus.Cancelled,
        itemCount: 1,
        totalPrice: 45.00,
        orderItems: [
          OrderItem(
            id: 'p21',
            imageUrl: '',
            price: 45.0,
            title: 'Cotton Socks',
            quantity: 1,
          ),
        ],
      ),
    ];
    return _mockCache!;
  }
}
