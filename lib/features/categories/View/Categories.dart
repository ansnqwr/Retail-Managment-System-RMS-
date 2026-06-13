import 'package:delni_rms/features/categories/Model/CategoryItemModel.dart';
import 'package:delni_rms/features/pagination/View/PaginationScreen.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/CategoryCard.dart';
import '../../../core/widgets/PageTitle.dart';
import '../../../core/widgets/SubCategoryCard.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  int? _expandedCategoryId;

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
      subCategories: [
        CategoryItemModel(
          id: 21,
          title: 'Shoes',
          subCategories: [],
          hasSubCategories: false,
          imageUrl: '',
        ),
        CategoryItemModel(
          id: 22,
          title: 'Hats',
          subCategories: [],
          hasSubCategories: false,
          imageUrl: '',
        ),
        CategoryItemModel(
          id: 23,
          title: 'Pants',
          subCategories: [],
          hasSubCategories: false,
          imageUrl: '',
        ),
        CategoryItemModel(
          id: 24,
          title: 'Shirts',
          subCategories: [],
          hasSubCategories: false,
          imageUrl: '',
        ),
      ],
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

  void _toggleCategoryExpansion(CategoryItemModel category) {
    final hasSubs = (category.subCategories ?? []).isNotEmpty;
    if (!hasSubs) {
      return;
    }
    setState(() {
      if (_expandedCategoryId == category.id) {
        _expandedCategoryId = null;
      } else {
        _expandedCategoryId = category.id;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 18,
                  ),
                  child: Row(
                    children: const [
                      SizedBox(width: 10),
                      PageTitle(title: "Categories", color: Color(0xFF6B2D5C)),
                      Spacer(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          _buildCategoriesSliverList(),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildCategoriesSliverList() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final category = categoriesList[index];
          final isExpanded = _expandedCategoryId == category.id;
          final subCategories = category.subCategories ?? [];

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CategoryCard(
                imageUrl: category.imageUrl ?? '',
                title: category.title ?? '',
                isExpanded: isExpanded,
                width: double.infinity,
                onTap: () => _toggleCategoryExpansion(category),
              ),
              if (isExpanded && subCategories.isNotEmpty)
                _buildSubCategoriesGrid(subCategories, category.title),
            ],
          );
        }, childCount: categoriesList.length),
      ),
    );
  }

  Widget _buildSubCategoriesGrid(
    List<CategoryItemModel> subCategories,
    String categoryTitle,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: subCategories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 4,
        ),
        itemBuilder: (context, index) {
          final sub = subCategories[index];
          return SubCategoryCard(
            title: sub.title ?? '',
            width: double.infinity,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => PaginationScreen(
                        isProduct: false,
                        isStore: false,
                        isSubCategory: true,
                        paginationTitle: "$categoryTitle / ${sub.title}",
                      ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
