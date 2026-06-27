import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/FilterChipWidget.dart';
import '../../../core/widgets/PageTitle.dart';
import '../../../core/widgets/ProductSilverGrid.dart';
import '../../../core/widgets/SearchBarWidget.dart';
import '../../../core/widgets/StoreSilverGrid.dart';
import '../../../core/widgets/SubCategoryCircleWidget.dart';
import '../../../core/widgets/FilterDropdownWidget.dart';
import '../ViewModel/pagination_bloc.dart';
import '../ViewModel/pagination_event.dart';
import '../ViewModel/pagination_repository.dart';
import '../ViewModel/pagination_state.dart';

class PaginationScreen extends StatelessWidget {
  final String? businessType;
  final bool isProduct;
  final bool isStore;
  final bool isSubCategory;
  final bool? hasSubCategories;
  final int? subCategoryId;
  final String paginationTitle;

  const PaginationScreen({
    super.key,
    this.businessType,
    required this.isProduct,
    required this.isStore,
    required this.isSubCategory,
    required this.paginationTitle,
    this.hasSubCategories,
    this.subCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              PaginationBloc(paginationRepository: PaginationRepository())..add(
                PaginationLoadRequested(
                  businessType: businessType,
                  isProduct: isProduct,
                  isStore: isStore,
                  isSubCategory: isSubCategory,
                  hasSubCategories: hasSubCategories,
                  subCategoryId: subCategoryId,
                  paginationTitle: paginationTitle,
                ),
              ),
      child: _PaginationContent(hasSubCategories: hasSubCategories),
    );
  }
}

class _PaginationContent extends StatefulWidget {
  final bool? hasSubCategories;

  const _PaginationContent({this.hasSubCategories});

  @override
  State<_PaginationContent> createState() => _PaginationContentState();
}

class _PaginationContentState extends State<_PaginationContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PaginationBloc>().add(const PaginationLoadMoreRequested());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF6B2D5C);

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<PaginationBloc, PaginationState>(
        listener: (context, state) {
          if (state is PaginationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor:
                    state.message.contains('only use')
                        ? Colors.orange.shade700
                        : Colors.red,
                duration:
                    state.message.contains('only use')
                        ? const Duration(seconds: 3)
                        : const Duration(seconds: 4),
                action:
                    state.message.contains('only use')
                        ? null
                        : SnackBarAction(
                          label: 'Retry',
                          onPressed: () {
                            context.read<PaginationBloc>().add(
                              const PaginationRefreshRequested(),
                            );
                          },
                        ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PaginationInitial || state is PaginationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PaginationError) {
            return _buildErrorState(context, state.message);
          }

          if (state is PaginationLoaded) {
            return _buildLoadedContent(context, state, primaryColor);
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
            const Text(
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
                context.read<PaginationBloc>().add(
                  const PaginationRefreshRequested(),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
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
    PaginationLoaded state,
    Color primaryColor,
  ) {
    return CustomScrollView(
      controller: _scrollController,
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
                      title: state.paginationTitle,
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
                          isFromHomePage: false,
                          prefillSearchText:
                              state.isSubCategory
                                  ? state.paginationTitle
                                  : null,
                          searchChips: state.searchChips,
                          onSearch: (searchTerm) {
                            context.read<PaginationBloc>().add(
                              PaginationSearchSubmitted(query: searchTerm),
                            );
                          },
                          onChipRemoved: (index) {
                            context.read<PaginationBloc>().add(
                              PaginationSearchChipRemoved(chipIndex: index),
                            );
                          },
                          onClearAllChips: () {
                            context.read<PaginationBloc>().add(
                              const PaginationSearchChipsCleared(),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap:
                                  () => _showFilterBottomSheet(context, state),
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
                const SizedBox(height: 12),

                FilterChipsWidget(
                  filters: state.activeFilters,
                  onRemoveFilter: (filterKey) {
                    context.read<PaginationBloc>().add(
                      PaginationFilterChipRemoved(filterKey: filterKey),
                    );
                  },
                  onClearAllFilters:
                      state.activeFilters.isNotEmpty
                          ? () {
                            context.read<PaginationBloc>().add(
                              const PaginationFiltersCleared(),
                            );
                          }
                          : null,
                ),
                const SizedBox(height: 30),

                (widget.hasSubCategories == true && !state.isSubCategory)
                    ? _buildSubCategoriesCircles(context, state)
                    : const SizedBox(),
              ],
            ),
          ),
        ),

        (state.isProduct || state.isSubCategory)
            ? ProductSilverGrid(products: state.products)
            : StoreSilverGrid(stores: state.stores),

        if (state.isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),

        if (!state.hasMoreData && !state.isLoadingMore)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'No more items',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                ),
              ),
            ),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  Widget _buildSubCategoriesCircles(
    BuildContext context,
    PaginationLoaded state,
  ) {
    if (state.subcategories.isEmpty) return const SizedBox.shrink();

    const double totalItemHeight = 97.0;
    const double itemWidth = 70.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: totalItemHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: state.subcategories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final sub = state.subcategories[index];
            return SizedBox(
              width: itemWidth,
              height: totalItemHeight,
              child: SubCategoryCircleWidget(
                title: sub.title,
                width: itemWidth,
                onTap: () {
                  context.read<PaginationBloc>().add(
                    PaginationSubCategoryTapped(
                      subCategoryId: sub.id,
                      subCategoryTitle:
                          "${state.paginationTitle} / ${sub.title}",
                    ),
                  );
                },
                imageUrl: sub.imageUrl,
              ),
            );
          },
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, PaginationLoaded state) {
    final bloc = context.read<PaginationBloc>();
    final options = state.filtersModel;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: bloc,
          child: DraggableScrollableSheet(
            initialChildSize: 0.85,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) {
              return FilterDropdownWidget(
                isStore: state.isStore,
                minPrice: options?.minPrice ?? 0,
                maxPrice: options?.maxPrice ?? 1000,
                isSubCategory: state.isSubCategory,
                initialFilters: state.activeFilters,
                categories:
                    options?.categoryNames ??
                    ['Clothing', 'Electronics', 'Sports', 'Home', 'Jewelry'],
                subcategories:
                    options?.subcategoryNamesByCategory ??
                    {
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
                      'Electronics': ['Phones', 'Laptops', 'Accessories'],
                      'Sports': ['Shoes', 'Equipment', 'Wear'],
                    },
                governorates:
                    options?.governorateNames ??
                    ['Damascus', 'Aleppo', 'Homs', 'Hama', 'Daraa'],
                cities:
                    options?.cityNamesByGovernorate ??
                    {
                      'Damascus': ['Jaramana', 'Meedan', 'Bab Touma'],
                      'Aleppo': ['Meedan', 'Khaldieh', 'Ashrafieh'],
                    },
                brands:
                    options?.brandNames ??
                    [
                      'Nike',
                      'Adidas',
                      'Puma',
                      'Zara',
                      'H&M',
                      'Apple',
                      'Samsung',
                    ],
                colors: options?.colors ?? [],
                onApplyFilters: (filters) {
                  Navigator.pop(context);
                  bloc.add(PaginationFiltersApplied(filters: filters));
                },
              );
            },
          ),
        );
      },
    );
  }
}
