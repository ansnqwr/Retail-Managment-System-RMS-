// lib/features/orders/view/qr_scanner_screen.dart

import 'package:delni_rms/features/orders/model/orderModel.dart';
import 'package:delni_rms/features/orders/view%20model/orderBloc.dart';
import 'package:delni_rms/features/orders/view%20model/orderEvent.dart';
import 'package:delni_rms/features/orders/view%20model/orderState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  final String orderId;
  final String orderNumber;

  const QrScannerScreen({
    super.key,
    required this.orderId,
    required this.orderNumber,
  });

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _hasScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<OrdersBloc, OrdersState>(
        listener: (context, state) {
          if (state is OrdersError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade700,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
            setState(() => _hasScanned = false);
          }
          if (state is OrderDetailsLoaded) {
            if (state.order.status == OrderStatus.Confirmed) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order confirmed successfully!'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.of(context).pop(true);
            }
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(
              fit: BoxFit.cover,
              onDetect: (capture) {
                if (_hasScanned) return;
                final barcodes = capture.barcodes;
                if (barcodes.isEmpty) return;

                final code = barcodes.first.rawValue;
                if (code == null || code.isEmpty) return;

                setState(() => _hasScanned = true);

                context.read<OrdersBloc>().add(
                  ConfirmOrderViaQr(widget.orderId, widget.orderNumber, code),
                );
              },
            ),
            CustomPaint(
              size: MediaQuery.of(context).size,
              painter: _ScannerOverlayPainter(),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _IconButton(
                      icon: Icons.close,
                      onTap: () => Navigator.of(context).pop(false),
                    ),
                    const Text(
                      'Scan QR Code',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_hasScanned)
                        const SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      else ...[
                        const Icon(
                          Icons.qr_code_scanner,
                          color: Colors.white70,
                          size: 32,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Align QR code within the frame',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Order: ${widget.orderNumber}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scanAreaSize = size.width * 0.7;
    final left = (size.width - scanAreaSize) / 2;
    final top = (size.height - scanAreaSize) / 2;
    final scanRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, scanAreaSize, scanAreaSize),
      const Radius.circular(20),
    );

    final backgroundPath =
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cutoutPath = Path()..addRRect(scanRect);

    final path = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final paint =
        Paint()
          ..color = Colors.black.withOpacity(0.65)
          ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);

    final borderPaint =
        Paint()
          ..color = const Color(0xFF5B2E5A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;

    canvas.drawRRect(scanRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
