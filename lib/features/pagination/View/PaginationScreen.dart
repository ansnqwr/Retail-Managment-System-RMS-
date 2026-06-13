import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/PageTitle.dart';
import '../../../core/widgets/ProductSilverGrid.dart';
import '../../../core/widgets/SearchBarWidget.dart';
import '../../Filter/View/Filter.dart';
import '../Model/ProductCardModel.dart';

class PaginationScreen extends StatefulWidget {
  final bool isProduct;
  final bool isStore;
  final bool isSubCategory;
  final String paginationTitle;
  const PaginationScreen({
    super.key,
    required this.isProduct,
    required this.isStore,
    required this.isSubCategory,
    required this.paginationTitle,
  });

  @override
  State<PaginationScreen> createState() => _PaginationScreenState();
}

class _PaginationScreenState extends State<PaginationScreen> {
  final primaryColor = const Color(0xFF6B2D5C);

  List<ProductCardModel> products = [
    ProductCardModel(
      imageUrl: '',
      title: 'Lenovo 1R5IV10',
      price: 17.99,
      isNew: true,
      hasDiscount: true,
    ),
    ProductCardModel(
      imageUrl: '',
      title: 'Lenovo 1R5IV11',
      price: 17.99,
      isNew: false,
      hasDiscount: false,
    ),
    ProductCardModel(
      imageUrl: '',
      title: 'Lenovo 1R5IV12',
      price: 17.99,
      isNew: false,
      hasDiscount: false,
    ),
    ProductCardModel(
      imageUrl: '',
      title: 'Lenovo 1R5IV13',
      price: 17.99,
      isNew: false,
      hasDiscount: false,
    ),
    ProductCardModel(
      imageUrl: '',
      title: 'Lenovo 1R5IV14',
      price: 17.99,
      isNew: false,
      hasDiscount: false,
    ),
    ProductCardModel(
      imageUrl: '',
      title: 'Lenovo 1R5IV15',
      price: 17.99,
      isNew: false,
      hasDiscount: false,
    ),
    ProductCardModel(
      imageUrl: '',
      title: 'Lenovo 1R5IV16',
      price: 17.99,
      isNew: false,
      hasDiscount: false,
    ),
    ProductCardModel(
      imageUrl: '',
      title: 'Lenovo 1R5IV17',
      price: 17.99,
      isNew: false,
      hasDiscount: false,
    ),
    ProductCardModel(
      imageUrl: '',
      title: 'Lenovo 1R5IV18',
      price: 17.99,
      isNew: false,
      hasDiscount: false,
    ),
    ProductCardModel(
      imageUrl: '',
      title: 'Lenovo 1R5IV19',
      price: 17.99,
      isNew: false,
      hasDiscount: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      PageTitle(
                        title: widget.paginationTitle,
                        color: const Color(0xFF6B2D5C),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: const SearchBarWidget(),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.filter_alt,
                                    size: 30,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          ProductSilverGrid(products: products),

          SliverToBoxAdapter(child: const SizedBox(height: 40)),
        ],
      ),
    );
  }
}
