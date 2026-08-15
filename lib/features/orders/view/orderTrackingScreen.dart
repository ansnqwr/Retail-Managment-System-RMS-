// lib/features/orders/view/orderTrackingScreen.dart

import 'package:delni_rms/features/orders/model/orderModel.dart';
import 'package:delni_rms/features/orders/view%20model/orderBloc.dart';
import 'package:delni_rms/features/orders/view%20model/orderEvent.dart';
import 'package:delni_rms/features/orders/view%20model/orderState.dart';
import 'package:delni_rms/features/orders/view%20model/ordersRepository.dart';
import 'package:delni_rms/features/orders/view/scannerScreen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersBloc>().add(LoadOrderDetails(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoading || state is OrderActionInProgress) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is OrdersError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    TextButton(
                      onPressed:
                          () => context.read<OrdersBloc>().add(
                            LoadOrderDetails(widget.orderId),
                          ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            if (state is OrderDetailsLoaded) {
              return _OrderTrackingView(order: state.order);
            }
            if (state is OrdersLoaded) {
              final order = state.orders.firstWhere(
                (o) => o.id == widget.orderId,
                orElse: () => throw Exception('Order not found'),
              );
              return _OrderTrackingView(order: order);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _OrderTrackingView extends StatelessWidget {
  final Order order;
  const _OrderTrackingView({required this.order});

  @override
  Widget build(BuildContext context) {
    final steps = _generateTimeline(order);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        _ProgressBar(status: order.status),
        _TrackingNumberCard(order: order),
        const SizedBox(height: 8),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              ...steps.map((step) => _TimelineStepWidget(step: step)),
              const SizedBox(height: 24),
              _OrderItemsSection(order: order),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'To Receive',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D1B2E),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Track Your Order',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          _IconButton(
            icon: Icons.qr_code_scanner,
            onTap: () async {
              final confirmed = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder:
                      (_) => BlocProvider(
                        create:
                            (context) => OrdersBloc(
                              repository: context.read<OrdersRepository>(),
                            ),
                        child: QrScannerScreen(
                          orderId: order.id,
                          orderNumber: order.orderNumber,
                        ),
                      ),
                ),
              );
              if (confirmed == true && context.mounted) {
                context.read<OrdersBloc>().add(LoadOrderDetails(order.id));
              }
            },
          ),
        ],
      ),
    );
  }

  List<_TrackingStep> _generateTimeline(Order order) {
    final now = DateTime.now();

    if (order.trackingEvents.isNotEmpty) {
      int currentIndex = order.trackingEvents.indexWhere((e) => e.isCurrent);
      if (currentIndex == -1) currentIndex = order.trackingEvents.length - 1;

      return order.trackingEvents.asMap().entries.map((entry) {
        final i = entry.key;
        final event = entry.value;
        return _TrackingStep(
          title: event.title,
          description: event.description,
          date: event.timestamp,
          isCompleted: i < currentIndex,
          isCurrent: i == currentIndex,
          isFuture: i > currentIndex,
        );
      }).toList();
    }

    final steps = <_TrackingStep>[];

    int statusStage(OrderStatus s) {
      switch (s) {
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

    final current = statusStage(order.status);
    if (current == -1) return steps;

    _TrackingStep add(String title, String desc, int stepStage, int dayOffset) {
      final isCompleted = current > stepStage;
      final isCurrent = current == stepStage;
      final isFuture = current < stepStage;
      final date = now.add(Duration(days: dayOffset));
      return _TrackingStep(
        title: title,
        description: desc,
        date: date,
        isCompleted: isCompleted,
        isCurrent: isCurrent,
        isFuture: isFuture,
      );
    }

    steps.add(
      add(
        'Packed',
        'Your parcel is packed and will be handed over to our delivery partner.',
        1,
        -3,
      ),
    );
    steps.add(
      add(
        'On the Way to Logistic Facility',
        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.',
        2,
        -3,
      ),
    );
    steps.add(
      add(
        'Arrived at Logistic Facility',
        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.',
        2,
        -3,
      ),
    );
    steps.add(
      add(
        'Shipped',
        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.',
        3,
        -2,
      ),
    );
    steps.add(
      add(
        'Out for Delivery',
        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.',
        4,
        0,
      ),
    );
    steps.add(
      add(
        'Delivered',
        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.',
        5,
        0,
      ),
    );

    return steps;
  }
}

class _ProgressBar extends StatelessWidget {
  final OrderStatus status;
  const _ProgressBar({required this.status});

  @override
  Widget build(BuildContext context) {
    final step = status.progressStep;
    if (step == -1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
      child: Row(
        children: [
          _dot(0, step),
          _line(0, step),
          _dot(1, step),
          _line(1, step),
          _dot(2, step),
        ],
      ),
    );
  }

  Widget _dot(int index, int currentStep) {
    final isCompleted = currentStep > index;
    final isCurrent = currentStep == index;

    Color color;
    if (isCompleted) {
      color = const Color(0xFF5B2E5A);
    } else if (isCurrent) {
      color =
          status == OrderStatus.Delivered || status == OrderStatus.Confirmed
              ? const Color(0xFF4CAF50)
              : const Color(0xFFE53935);
    } else {
      color = Colors.grey.shade300;
    }

    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  Widget _line(int index, int currentStep) {
    final isCompleted = currentStep > index;
    return Expanded(
      child: Container(
        height: 3,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isCompleted ? const Color(0xFF5B2E5A) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _TrackingNumberCard extends StatelessWidget {
  final Order order;
  const _TrackingNumberCard({required this.order});

  String get _displayTrackingNumber {
    return order.trackingNumber ??
        'LGS-${order.orderNumber.replaceAll('#', '')}300763731';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF2EC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tracking Number',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xFF2D1B2E),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _displayTrackingNumber,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: _displayTrackingNumber));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied to clipboard')),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.copy_outlined,
                size: 18,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackingStep {
  final String title;
  final String description;
  final DateTime date;
  final bool isCompleted;
  final bool isCurrent;
  final bool isFuture;

  _TrackingStep({
    required this.title,
    required this.description,
    required this.date,
    required this.isCompleted,
    required this.isCurrent,
    required this.isFuture,
  });
}

class _TimelineStepWidget extends StatelessWidget {
  final _TrackingStep step;
  const _TimelineStepWidget({required this.step});

  @override
  Widget build(BuildContext context) {
    final titleColor =
        step.isFuture ? Colors.grey.shade400 : const Color(0xFF2D1B2E);
    final descColor =
        step.isFuture ? Colors.grey.shade300 : Colors.grey.shade600;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  step.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        step.isCurrent || step.isCompleted
                            ? FontWeight.w700
                            : FontWeight.w500,
                    color: titleColor,
                  ),
                ),
              ),
              if (step.isCurrent && !step.isCompleted) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE7F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Expected on ${step.date.month},${step.date.day}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF5B2E5A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ] else ...[
                Text(
                  '${step.date.month}.${step.date.day.toString().padLeft(2, '0')} '
                  '${step.date.hour.toString().padLeft(2, '0')}:${step.date.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        step.isFuture
                            ? Colors.grey.shade300
                            : Colors.grey.shade700,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            step.description,
            style: TextStyle(fontSize: 13, color: descColor, height: 1.4),
          ),
          if (step.title == 'Delivered' && step.isCompleted) ...[
            const SizedBox(height: 4),
            const Icon(Icons.check_circle, color: Color(0xFF5B2E5A), size: 20),
          ],
        ],
      ),
    );
  }
}

class _OrderItemsSection extends StatelessWidget {
  final Order order;
  const _OrderItemsSection({required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Items (${order.itemCount})',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D1B2E),
          ),
        ),
        const SizedBox(height: 12),
        ...order.orderItems.map((item) => _OrderItemTile(item: item)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D1B2E),
              ),
            ),
            Text(
              '\$${order.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5B2E5A),
              ),
            ),
          ],
        ),
        if (order.shippingFee != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shipping',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                Text(
                  '\$${order.shippingFee!.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _OrderItemTile extends StatelessWidget {
  final OrderItem item;
  const _OrderItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 56,
              height: 56,
              color: const Color(0xFFF5C6CB),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => const Center(
                      child: Icon(Icons.broken_image, color: Colors.white54),
                    ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF2D1B2E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 2),
                Text(
                  'Qty: ${item.quantity}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Color(0xFFE8E0E8),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF5B2E5A)),
      ),
    );
  }
}
