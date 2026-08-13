import 'package:delni_rms/features/home/view/ProductDetailsScreen.dart';
import 'package:flutter/material.dart';

import '../../features/home/Model/ProductCardModel.dart';
import 'ProductCard.dart';

class ProductSilverGrid extends StatefulWidget {
  final List<ProductCardModel> products;
  const ProductSilverGrid({super.key, required this.products});

  @override
  State<ProductSilverGrid> createState() => _ProductSilverGridState();
}

class _ProductSilverGridState extends State<ProductSilverGrid> {
  @override
  Widget build(BuildContext context) {
    return _productGridSliver(widget.products);
  }

  Widget _productGridSliver(List<ProductCardModel> products) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final product = products[index];
          return ProductCard(
            imageUrl: product.imageUrl,
            title: product.title,
            price: product.price,
            isNew: product.isNew,
            hasDiscount: product.hasDiscount,
            width: double.infinity,
            onTap: () {
              // context.read<HomeBloc>().add(HomeProductTapped(product.id));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailsScreen(productId: product.id),
                ),
              );
            },
            discountPercentage: product.discountPercentage,
          );
        }, childCount: products.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 0,
          crossAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
      ),
    );
  }
}
