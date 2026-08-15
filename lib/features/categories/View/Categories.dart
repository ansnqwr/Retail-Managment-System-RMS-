import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/CategoryCard.dart';
import '../../../core/widgets/PageTitle.dart';
import '../../../core/widgets/SubCategoryCard.dart';
import '../../pagination/View/PaginationScreen.dart';
import '../Model/CategoryItemModel.dart';
import '../ViewModel/Categories_bloc.dart';
import '../ViewModel/Categories_event.dart';
import '../ViewModel/Categories_repository.dart';
import '../ViewModel/Categories_state.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              CategoriesBloc(categoryRepository: CategoryRepository())
                ..add(const CategoriesLoadEvent()),
      child: const _CategoriesContent(),
    );
  }
}

class _CategoriesContent extends StatelessWidget {
  const _CategoriesContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<CategoriesBloc, CategoriesState>(
        listener: (context, state) {
          if (state is CategoriesErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: () {
                    context.read<CategoriesBloc>().add(
                      const CategoriesRefreshRequested(),
                    );
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CategoriesInitialState ||
              state is CategoriesLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CategoriesErrorState) {
            return _buildErrorState(context, state.message);
          }

          if (state is CategoriesLoadedState) {
            return _buildLoadedContent(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B2D5C),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<CategoriesBloc>().add(
                  const CategoriesRefreshRequested(),
                );
              },
              icon: const Icon(Icons.refresh),
              label: Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B2D5C),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedContent(
    BuildContext context,
    CategoriesLoadedState state,
  ) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18),
                child: Row(
                  children: [
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
        _buildCategoriesSliverList(state),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  Widget _buildCategoriesSliverList(CategoriesLoadedState state) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final category = state.categoriesList[index];
          final isExpanded = state.expandedCategoryId == category.id;
          final subCategories = category.subCategories ?? [];

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CategoryCard(
                imageUrl: category.imageUrl,
                title: category.title,
                isExpanded: isExpanded,
                width: double.infinity,
                onTap: () {
                  context.read<CategoriesBloc>().add(
                    CategoriesCategoryTapped(
                      categoryIndex: index,
                      categoryId: category.id,
                    ),
                  );
                },
              ),
              if (isExpanded && subCategories.isNotEmpty)
                _buildSubCategoriesGrid(context, subCategories, category.title),
            ],
          );
        }, childCount: state.categoriesList.length),
      ),
    );
  }

  Widget _buildSubCategoriesGrid(
    BuildContext context,
    List<CategoryItemModel> subCategories,
    String parentCategoryTitle,
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
            title: sub.title,
            width: double.infinity,
            onTap: () {
              context.read<CategoriesBloc>().add(
                CategoriesSubcategoryTapped(
                  subcategoryId: sub.id,
                  pageTitle: "$parentCategoryTitle / ${sub.title}",
                ),
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => PaginationScreen(
                        isProduct: false,
                        isStore: false,
                        isSubCategory: true,
                        subCategoryId: sub.id,
                        paginationTitle: "$parentCategoryTitle / ${sub.title}",
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
