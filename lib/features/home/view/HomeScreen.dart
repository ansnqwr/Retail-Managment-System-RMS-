import 'package:carousel_slider/carousel_slider.dart';
import 'package:delni_rms/core/widgets/ProductCard.dart';
import 'package:delni_rms/features/home/Model/AdModel.dart';
import 'package:delni_rms/features/home/Model/ProductCardModel.dart';

import '/features/categories/Model/CategoryItemModel.dart';
import '/features/home/view/Settings.dart';

import '/core/widgets/CategorySliderItem.dart';
import '/features/auth/view/WelcomeLogin.dart';
import '/core/widgets/OfflineFallbackWidget.dart';
import 'package:flutter/material.dart';
import '/core/widgets/IconCircleWidget.dart';
import '/core/widgets/BadgeIconWidget.dart';

class HomeScreen extends StatefulWidget {
  final bool isGuest;
  const HomeScreen({super.key, required this.isGuest});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF6B2D5C);

    List<AdModel> imageURLs = [
      AdModel(url: '', businessType: ''),
      AdModel(url: '', businessType: ''),
      AdModel(url: '', businessType: ''),
      AdModel(url: '', businessType: ''),
    ];

    List<CategoryItemModel> categories = [
      CategoryItemModel(id: 1, title: 'All'),
      CategoryItemModel(id: 2, title: 'Clothing'),
      CategoryItemModel(id: 3, title: 'Electronics'),
      CategoryItemModel(id: 4, title: 'Sports'),
      CategoryItemModel(id: 5, title: 'Home'),
      CategoryItemModel(id: 6, title: 'Jewelry'),
    ];

    String businessType = "Trending";

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Top area: greeting, search, categories, ads, horizontal sliders
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
                      _buildGreetingText('Hello, User!', primaryColor),
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
                  _buildSearchBar(),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 70,
                    child: _buildCategoriesSlider(categories),
                  ),
                  const SizedBox(height: 20),
                  _buildAdsSlider(imageURLs),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: _buildProductCardsSlider(products, businessType),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: _buildProductCardsSlider(products, businessType),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: _buildProductCardsSlider(products, businessType),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          _buildProductCardsGrid(products, businessType),
          _productGridSliver(products),

          SliverToBoxAdapter(child: const SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildGreetingText(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  Widget _buildSettingsButton(BuildContext context, Color color) {
    return InkWell(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const Settings()));
      },
      child: IconCircleWidget(icon: Icons.settings, color: color),
    );
  }

  Widget _buildNotificationsButton(BuildContext context, Color color) {
    return InkWell(
      onTap: () {},
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeLoginScreen()),
        );
      },
      child: Container(
        padding: EdgeInsets.all(6),
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

  Widget _buildCategoriesSlider(List<CategoryItemModel> categories) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(8),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final isSelected = _selectedCategoryIndex == index;
        return CategorySliderItem(
          label: cat.title,
          categoryId: cat.id,
          isSelected: isSelected,
          onTap: () => setState(() => _selectedCategoryIndex = index),

          //  image: categories[index]['image']!,
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 80),
      child: SearchBar(
        hintText: 'Search for products and stores',
        hintStyle: WidgetStateProperty.all(
          TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        ),
        enabled: true,
        keyboardType: TextInputType.name,
        leading: Icon(Icons.search),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(width: 1, color: Colors.grey.shade500),
          ),
        ),
        padding: WidgetStateProperty.all(EdgeInsets.only(left: 10, right: 10)),
        backgroundColor: WidgetStateProperty.all(Colors.white),
        elevation: WidgetStatePropertyAll(0),
      ),
    );
  }

  Widget _buildAdsSlider(List<AdModel> imageUrls) {
    final validUrls =
        imageUrls
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
                  // fallback on load error
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

  Widget _buildProductCardsSlider(
    List<ProductCardModel> products,
    String businessType,
  ) {
    final primaryColor = const Color(0xFF6B2D5C);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: InkWell(
            onTap: () {},
            child: Row(
              children: [
                Text(
                  businessType,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.start,
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
                SizedBox(width: 10),
                IconCircleWidget(
                  icon: Icons.arrow_forward,
                  color: primaryColor,
                ),
              ],
            ),
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
                  onTap: () {},
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCardsGrid(
    List<ProductCardModel> products,
    String businessType,
  ) {
    final primaryColor = const Color(0xFF6B2D5C);

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Text(
              businessType,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ]),
      ),
    );
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
            onTap: () {},
          );
        }, childCount: products.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.68,
        ),
      ),
    );
  }
}
