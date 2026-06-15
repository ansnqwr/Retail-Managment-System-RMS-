import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/PageTitle.dart';
import '../../../core/widgets/ProductSilverGrid.dart';
import '../../../core/widgets/SearchBarWidget.dart';
import '../../../core/widgets/SubCategoryCard.dart';
import '../../../core/widgets/SubCategoryCircleWidget.dart';
import '../../Filter/View/FilterDropdownWidget.dart';
import '../../categories/Model/CategoryItemModel.dart';
import '../Model/ProductCardModel.dart';

class PaginationScreen extends StatefulWidget {
  final bool isProduct;
  final bool isStore;
  final bool isSubCategory;
  final bool? hasSubCategories;
  final String paginationTitle;
  const PaginationScreen({
    super.key,
    required this.isProduct,
    required this.isStore,
    required this.isSubCategory,
    required this.paginationTitle,
    this.hasSubCategories,
  });

  @override
  State<PaginationScreen> createState() => _PaginationScreenState();
}

class _PaginationScreenState extends State<PaginationScreen> {
  final primaryColor = const Color(0xFF6B2D5C);

  List<CategoryItemModel> categoriesList = [
    CategoryItemModel(
      id: 1,
      title: 'All',
      subCategories: [],
      hasSubCategories: false,
      imageUrl: '',
    ),
    CategoryItemModel(
      id: 2,
      title: 'Clothing',
      hasSubCategories: true,
      imageUrl: '',
      subCategories: [],
    ),
    CategoryItemModel(
      id: 3,
      title: 'Electronics',
      subCategories: [],
      hasSubCategories: false,
      imageUrl: '',
    ),
    CategoryItemModel(
      id: 4,
      title: 'Sports',
      subCategories: [],
      hasSubCategories: false,
      imageUrl: '',
    ),
    CategoryItemModel(
      id: 5,
      title: 'Home',
      subCategories: [],
      hasSubCategories: false,
      imageUrl: '',
    ),
    CategoryItemModel(
      id: 6,
      title: 'Jewelry',
      subCategories: [],
      hasSubCategories: false,
      imageUrl: '',
    ),
  ];

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
                        Expanded(
                          flex: 10,
                          child: SearchBarWidget(
                            prefillSearchText:
                                widget.isSubCategory
                                    ? widget.paginationTitle
                                    : null,
                            onSearch: (searchTerm) {
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(width: 12),

                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                // Replace the filter InkWell onTap with:
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    builder:
                                        (context) => DraggableScrollableSheet(
                                          initialChildSize: 0.85,
                                          minChildSize: 0.5,
                                          maxChildSize: 0.95,
                                          expand: false,
                                          builder:
                                              (
                                                context,
                                                scrollController,
                                              ) => FilterDropdownWidget(
                                                categories: [
                                                  'Clothing',
                                                  'Electronics',
                                                  'Sports',
                                                  'Home',
                                                  'Jewelry',
                                                ],
                                                subCategories: {
                                                  'Clothing': [
                                                    'Dresses',
                                                    'Pants',
                                                    'Skirts',
                                                    'Shorts',
                                                    'Jackets',
                                                    'Hoodies',
                                                    'Shirts',
                                                    'Polo',
                                                    'T-Shirts',
                                                    'Tunics',
                                                  ],
                                                  'Electronics': [
                                                    'Phones',
                                                    'Laptops',
                                                    'Accessories',
                                                  ],
                                                  'Sports': [
                                                    'Shoes',
                                                    'Equipment',
                                                    'Wear',
                                                  ],
                                                },
                                                brands: [
                                                  'Nike',
                                                  'Adidas',
                                                  'Puma',
                                                  'Zara',
                                                  'H&M',
                                                  'Apple',
                                                  'Samsung',
                                                ],
                                                onApplyFilters: (filters) {
                                                  Navigator.pop(context);
                                                  // Handle filters: filters['priceRange'], filters['category'], etc.
                                                  print(filters);
                                                },
                                              ),
                                        ),
                                  );
                                },
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

                  (widget.hasSubCategories == true)
                      ? _buildSubCategoriesCircles(
                        categoriesList,
                        widget.paginationTitle,
                      )
                      : const SizedBox(),
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

  Widget _buildSubCategoriesCircles(
    List<CategoryItemModel> subCategories,
    String categoryTitle,
  ) {
    if (subCategories.isEmpty) return const SizedBox.shrink();

    const double totalItemHeight = 97.0;
    const double itemWidth = 70.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: totalItemHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: subCategories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final sub = subCategories[index];
            return SizedBox(
              width: itemWidth,
              height: totalItemHeight,
              child: SubCategoryCircleWidget(
                title: sub.title ?? '',
                width: itemWidth,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PaginationScreen(
                            isProduct: false,
                            isStore: false,
                            isSubCategory: true,
                            hasSubCategories: sub.hasSubCategories,
                            paginationTitle: "$categoryTitle / ${sub.title}",
                          ),
                    ),
                  );
                },
                imageUrl: sub.imageUrl ?? '',
              ),
            );
          },
        ),
      ),
    );
  }
}
