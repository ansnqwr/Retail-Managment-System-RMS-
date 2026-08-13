import 'package:delni_rms/features/settings/view%20model/settingsBloc.dart';
import 'package:delni_rms/features/settings/view%20model/settingsEvent.dart';
import 'package:delni_rms/features/settings/view/settingsScreen.dart';
import 'package:delni_rms/features/stores/view%20model/store_details_bloc.dart';
import 'package:delni_rms/features/stores/view%20model/store_details_event.dart';
import 'package:delni_rms/features/stores/view%20model/store_details_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

import '../../../core/widgets/ImageHelper.dart';
import '../../../core/widgets/PageTitle.dart';
import '../../../core/widgets/ProductCard.dart';
import '../../../core/widgets/ProductSilverGrid.dart';
import '../../../core/widgets/StoreCard.dart';
import '../../../core/widgets/SearchBarWidget.dart';
import '../../../core/widgets/IconCircleWidget.dart';
import '../../../core/widgets/BadgeIconWidget.dart';
import '../../../core/widgets/CategorySliderItem.dart';
import '../../../features/home/Model/AdModel.dart';
import '../../products/view/ProductDetailsScreen.dart';
import '../../settings/view model/settingsRepository.dart';
import '../../stores/view/store_details_screen.dart';
import '../Model/ProductCardModel.dart';
import '../Model/StoreCardItem.dart';
import '../../../features/pagination/View/PaginationScreen.dart';
import '../../../features/auth/view/WelcomeLogin.dart';
import '../../../features/home/view/Settings.dart';
import '../view model/HomePage_bloc.dart';
import '../view model/HomePage_event.dart';
import '../view model/HomePage_repository.dart';
import '../view model/HomePage_state.dart';

class HomeScreen extends StatelessWidget {
  final bool isGuest;

  const HomeScreen({super.key, required this.isGuest});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              HomeBloc(homeRepository: HomeRepository())
                ..add(HomeLoadRequested(isGuest)),
      child: _HomeScreenContent(isGuest: isGuest),
    );
  }
}

class _HomeScreenContent extends StatefulWidget {
  final bool isGuest;

  const _HomeScreenContent({required this.isGuest});

  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<HomeBloc>().add(const HomeLoadMoreJustForYouRequested());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  final client = http.Client();

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
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(milliseconds: 2000),
                content: Text(state.message),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: () {
                    context.read<HomeBloc>().add(const HomeRefreshRequested());
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is HomeInitial || state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeError) {
            return _buildErrorState(context, state.message);
          }

          if (state is HomeLoaded) {
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
                context.read<HomeBloc>().add(const HomeRefreshRequested());
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
    HomeLoaded state,
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
                    PageTitle(title: 'Hello, User!', color: primaryColor),
                    const Spacer(),
                    _buildSettingsButton(context, primaryColor),
                    const SizedBox(width: 12),
                    widget.isGuest == false
                        ? _buildNotificationsButton(context, primaryColor)
                        : _buildGuestSignUpButton(context, primaryColor),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 30),

                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: [
                      SearchBarWidget(
                        isFromHomePage: true,
                        onSearch: (query) {
                          context.read<HomeBloc>().add(
                            HomeSearchSubmitted(
                              query: query,
                              isSearchingProducts: state.isSearchingProducts,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildToggleButton(
                            label: 'Products',
                            isSelected: state.isSearchingProducts,
                            onTap: () {
                              if (!state.isSearchingProducts) {
                                context.read<HomeBloc>().add(
                                  const HomeSearchToggleChanged(
                                    isSearchingProducts: true,
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 12),
                          _buildToggleButton(
                            label: 'Stores',
                            isSelected: !state.isSearchingProducts,
                            onTap: () {
                              if (state.isSearchingProducts) {
                                context.read<HomeBloc>().add(
                                  const HomeSearchToggleChanged(
                                    isSearchingProducts: false,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  height: 70,
                  child: _buildCategoriesSlider(context, state),
                ),
                const SizedBox(height: 20),
                if (state.ads.isNotEmpty) _buildAdsSlider(state.ads),
                const SizedBox(height: 30),

                _buildProductSection(
                  context,
                  1,
                  'Trending',
                  state.trendingProducts,
                  primaryColor,
                  state.selectedCategoryId,
                ),
                const SizedBox(height: 30),
                _buildProductSection(
                  context,
                  2,
                  'On Sale',
                  state.onSaleProducts,
                  primaryColor,
                  state.selectedCategoryId,
                ),
                const SizedBox(height: 30),
                // _buildProductSection(
                //   context,
                //   3,
                //   'Most Bought',
                //   state.mostBoughtProducts,
                //   primaryColor,
                // ),
                const SizedBox(height: 30),
                _buildProductSection(
                  context,
                  4,
                  'Newest',
                  state.newestProducts,
                  primaryColor,
                  state.selectedCategoryId,
                ),
                _buildStoresSection(
                  context,
                  5,
                  'Brands',
                  state.brandStores,
                  primaryColor,
                  client,
                  state.selectedCategoryId,
                ),
                _buildStoresSection(
                  context,
                  6,
                  'Stores Nearby',
                  state.nearbyStores,
                  primaryColor,
                  client,
                  state.selectedCategoryId,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        _buildBusinessTypeGrid('Just For You', primaryColor),
        ProductSilverGrid(products: state.justForYouProducts),

        if (state.isLoadingMoreJustForYou)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),

        if (!state.justForYouHasMoreData && !state.isLoadingMoreJustForYou)
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

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6B2D5C) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF6B2D5C),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSlider(BuildContext context, HomeLoaded state) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      itemCount: state.categories.length,
      itemBuilder: (context, index) {
        final cat = state.categories[index];
        final isSelected = state.selectedCategoryIndex == index;
        return CategorySliderItem(
          label: cat.title,
          categoryId: cat.id,
          isSelected: isSelected,
          onTap: () {
            context.read<HomeBloc>().add(
              HomeCategorySelected(categoryIndex: index, categoryId: cat.id),
            );
          },
        );
      },
    );
  }

  Widget _buildAdsSlider(List<AdModel> ads) {
    final validUrls =
        ads
            .where((a) => a.url.trim().isNotEmpty)
            .map((a) => a.url.trim())
            .toList();

    if (validUrls.isEmpty) {
      return SizedBox(
        height: 160,
        child: Center(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            height: 140,
            alignment: Alignment.center,
            child: const Text(
              'No ads available',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 160,
      child: CarouselSlider.builder(
        itemCount: validUrls.length,
        itemBuilder: (context, index, realIndex) {
          final url = getImageUrl(validUrls[index]);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                url,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
              ),
            ),
          );
        },
        options: CarouselOptions(
          height: 160,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.9,
        ),
      ),
    );
  }

  Widget _buildProductSection(
    BuildContext context,
    int sectionId,
    String businessType,
    List<ProductCardModel> products,
    Color primaryColor,
    int? selectedCategoryId,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              context.read<HomeBloc>().add(
                HomeSectionSeeAllTapped(businessType, sectionId),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => PaginationScreen(
                        businessType: businessType,
                        isProduct: true,
                        isStore: false,
                        isSubCategory: false,
                        paginationTitle: businessType,
                        initialCategoryId: selectedCategoryId,
                      ),
                ),
              );
            },
            child: Row(
              children: [
                Text(
                  businessType,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: primaryColor,
                  ),
                ),
                const Spacer(),
                Text(
                  "See all",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(width: 10),
                IconCircleWidget(
                  icon: Icons.arrow_forward,
                  color: primaryColor,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 230,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: ProductCard(
                    imageUrl: product.imageUrl,
                    title: product.title,
                    price: product.price,
                    isNew: product.isNew,
                    hasDiscount: product.hasDiscount,
                    width: 170,
                    onTap: () {
                      context.read<HomeBloc>().add(
                        HomeProductTapped(product.id),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) =>
                                  ProductDetailsScreen(productId: product.id),
                        ),
                      );
                    },
                    discountPercentage: product.discountPercentage,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoresSection(
    BuildContext context,
    int sectionId,
    String businessType,
    List<StoreCardModel> stores,
    Color primaryColor,
    http.Client client,
    int? selectedCategoryId,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => PaginationScreen(
                        businessType: businessType,
                        isProduct: false,
                        isStore: true,
                        isSubCategory: false,
                        paginationTitle: businessType,
                        initialCategoryId: selectedCategoryId,
                      ),
                ),
              );
            },
            child: Row(
              children: [
                Text(
                  businessType,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: primaryColor,
                  ),
                ),
                const Spacer(),
                Text(
                  "See all",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(width: 10),
                IconCircleWidget(
                  icon: Icons.arrow_forward,
                  color: primaryColor,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 230,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: stores.length,
              itemBuilder: (context, index) {
                final store = stores[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: StoreCard(
                    imageUrl: store.imageUrl,
                    title: store.title,
                    isNew: store.isNew,
                    branchesCount: store.branches.length,
                    width: 170,
                    onTap: () {
                      context.read<HomeBloc>().add(HomeStoreTapped(store.id));

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => BlocProvider(
                                create:
                                    (_) => StoreDetailsBloc(
                                      StoreDetailsRepository(client),
                                    )..add(LoadStoreDetails(store.id)),
                                child: StoreDetailsScreen(storeId: store.id),
                              ),
                        ),
                      );
                    },
                    governorate: store.governorate,
                    city: store.city,
                    isVerified: store.isVerified,
                    isBrand: store.isBrand,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessTypeGrid(String businessType, Color primaryColor) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Text(
            businessType,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }

  Widget _buildSettingsButton(BuildContext context, Color color) {
    return InkWell(
      onTap: () {
        context.read<HomeBloc>().add(const HomeSettingsTapped());
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (routeContext) => BlocProvider(
                  create:
                      (blocContext) =>
                          SettingsBloc(repository: SettingsRepositoryImpl())
                            ..add(LoadSettings()),
                  child: const SettingsScreen(),
                ),
          ),
        );
      },
      child: IconCircleWidget(icon: Icons.settings, color: color),
    );
  }

  Widget _buildNotificationsButton(BuildContext context, Color color) {
    return InkWell(
      onTap: () {
        context.read<HomeBloc>().add(const HomeNotificationsTapped());
      },
      child: BadgeIconWidget(
        context: context,
        label: '3',
        icon: Icons.notifications_outlined,
        color: color,
      ),
    );
  }

  Widget _buildGuestSignUpButton(BuildContext context, Color color) {
    return InkWell(
      onTap: () {
        context.read<HomeBloc>().add(const HomeSignUpTapped());
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeLoginScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          shape: BoxShape.rectangle,
          border: Border.all(color: Colors.grey.shade500),
          color: Colors.grey.shade300,
        ),
        child: Text(
          "Sign up",
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
