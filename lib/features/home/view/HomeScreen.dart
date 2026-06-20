import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../core/widgets/PageTitle.dart';
import '../../../core/widgets/ProductCard.dart';
import '../../../core/widgets/ProductSilverGrid.dart';
import '../../../core/widgets/StoreCard.dart';
import '../../../core/widgets/SearchBarWidget.dart';
import '../../../core/widgets/IconCircleWidget.dart';
import '../../../core/widgets/BadgeIconWidget.dart';
import '../../../core/widgets/OfflineFallbackWidget.dart';
import '../../../core/widgets/CategorySliderItem.dart';

import '../../../features/categories/Model/CategoryItemModel.dart';
import '../../../features/home/Model/AdModel.dart';
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

class _HomeScreenContent extends StatelessWidget {
  final bool isGuest;

  const _HomeScreenContent({required this.isGuest});

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
    // OfflineFallbackWidget();
  }

  Widget _buildLoadedContent(
    BuildContext context,
    HomeLoaded state,
    Color primaryColor,
  ) {
    return CustomScrollView(
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
                    isGuest == false
                        ? _buildNotificationsButton(context, primaryColor)
                        : _buildGuestSignUpButton(context, primaryColor),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 80),
                  child: SearchBarWidget(isFromHomePage: true),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 70,
                  child: _buildCategoriesSlider(context, state),
                ),
                const SizedBox(height: 20),
                _buildAdsSlider(state.ads),
                const SizedBox(height: 30),
                _buildProductSection(
                  context,
                  1,
                  'Trending',
                  state.trendingProducts,
                  primaryColor,
                ),
                const SizedBox(height: 30),
                _buildProductSection(
                  context,
                  2,
                  'On Sale',
                  state.onSaleProducts,
                  primaryColor,
                ),
                const SizedBox(height: 30),
                _buildProductSection(
                  context,
                  3,
                  'Most Bought',
                  state.mostBoughtProducts,
                  primaryColor,
                ),
                const SizedBox(height: 30),
                _buildProductSection(
                  context,
                  4,
                  'Newest',
                  state.newestProducts,
                  primaryColor,
                ),
                _buildStoresSection(
                  context,
                  5,
                  'Brands',
                  state.brandStores,
                  primaryColor,
                ),
                _buildStoresSection(
                  context,
                  6,
                  'Stores Nearby',
                  state.nearbyStores,
                  primaryColor,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        _buildBusinessTypeGrid('Just For You', primaryColor),
        ProductSilverGrid(products: state.justForYouProducts),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
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
          final url = validUrls[index];
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
                        isProduct: true,
                        isStore: false,
                        isSubCategory: false,
                        paginationTitle: businessType,
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
                        isProduct: false,
                        isStore: true,
                        isSubCategory: false,
                        paginationTitle: businessType,
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
                    width: 170,
                    onTap: () {
                      context.read<HomeBloc>().add(HomeStoreTapped(store.id));
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
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const Settings()));
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
          "Sign Up",
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
