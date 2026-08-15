// lib/features/orders/screens/orders_screen.dart

import 'package:delni_rms/features/orders/model/orderModel.dart';
import 'package:delni_rms/features/orders/view%20model/orderBloc.dart';
import 'package:delni_rms/features/orders/view%20model/orderEvent.dart';
import 'package:delni_rms/features/orders/view%20model/orderState.dart';
import 'package:delni_rms/features/orders/view/orderTrackingScreen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view model/ordersRepository.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<OrdersBloc, OrdersState>(
                builder: (context, state) {
                  if (state is OrdersLoading) {
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
                                  LoadOrders(),
                                ),
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is OrdersLoaded) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.orders.length,
                      itemBuilder: (context, index) {
                        return _OrderCard(order: state.orders[index]);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My order',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w300,
              color: Color(0xFF2D1B2E),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 80,
              height: 80,
              color: Colors.grey.shade100,
              child:
                  order.orderItems.length == 1
                      ? _buildSingleImage(order.orderItems.first)
                      : _buildImageGrid(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.orderNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${order.itemCount} items',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  order.displayDeliveryType,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          order.status.label,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xFF5B2E5A),
                          ),
                        ),
                        if (order.status.isDelivered) ...[
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF5B2E5A),
                            size: 18,
                          ),
                        ],
                      ],
                    ),
                    _ActionButton(
                      label: order.status.showTrackButton ? 'Track' : 'Review',
                      onTap: () {
                        if (order.status.showTrackButton) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (_) => BlocProvider(
                                    create:
                                        (context) => OrdersBloc(
                                          repository:
                                              context.read<OrdersRepository>(),
                                        ),
                                    child: OrderTrackingScreen(
                                      orderId: order.id,
                                    ),
                                  ),
                            ),
                          );
                        } else {
                          context.read<OrdersBloc>().add(ReviewOrder(order.id));
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleImage(OrderItem item) {
    return Container(
      color: const Color(0xFFB76EAA),
      child: Image.network(
        item.imageUrl,
        fit: BoxFit.cover,
        errorBuilder:
            (_, __, ___) => const Center(
              child: Icon(Icons.broken_image, color: Colors.white54),
            ),
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      padding: EdgeInsets.zero,
      children:
          order.orderItems.take(4).map((item) {
            return Container(
              margin: const EdgeInsets.all(1),
              color: const Color(0xFFF5C6CB),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => const Icon(
                      Icons.broken_image,
                      size: 16,
                      color: Colors.white54,
                    ),
              ),
            );
          }).toList(),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isTrack = label == 'Track';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: isTrack ? const Color(0xFF5B2E5A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isTrack ? null : Border.all(color: const Color(0xFF5B2E5A)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isTrack ? Colors.white : const Color(0xFF5B2E5A),
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
