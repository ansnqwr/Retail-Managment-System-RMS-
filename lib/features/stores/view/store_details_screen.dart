import 'package:delni_rms/features/stores/model/StoreProfileModel.dart';
import 'package:delni_rms/features/stores/view%20model/store_details_bloc.dart';
import 'package:delni_rms/features/stores/view%20model/store_details_event.dart';
import 'package:delni_rms/features/stores/view%20model/store_details_repository.dart';
import 'package:delni_rms/features/stores/view%20model/store_details_state.dart';
import 'package:delni_rms/features/products/view/ProductDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/BranchModel.dart';

class StoreDetailsScreen extends StatefulWidget {
  final int storeId;
  final StoreBranchModel? selectedBranch;

  const StoreDetailsScreen({
    super.key,
    required this.storeId,
    this.selectedBranch,
  });

  static const Color primaryColor = Color(0xFF6B2D5C);
  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen>
    with SingleTickerProviderStateMixin {
  static const Color primaryColor = Color(0xFF6B2D5C);

  late final TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    if (_tabController.index != 1) {
      return;
    }

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<StoreDetailsBloc>().add(LoadMoreProducts());
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<StoreDetailsBloc, StoreDetailsState>(
        builder: (context, state) {
          if (state is StoreDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StoreDetailsError) {
            return _buildErrorState(state.message);
          }

          if (state is StoreDetailsLoaded) {
            return _buildLoadedPage(state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Main page
  // ---------------------------------------------------------------------------

  Widget _buildLoadedPage(StoreDetailsLoaded state) {
    final isBrand = state.overviewData['isBrand'] == true;
    final isVerified = state.overviewData['isVerified'] == true;

    /*
     * IMPORTANT:
     *
     * If a branch was selected:
     *     use that branch's location.
     *
     * Otherwise:
     *     use the store's main branch.
     */
    final branch = state.selectedBranch ?? widget.selectedBranch;

    final governorate =
        branch?.governorate ?? state.profileData.mainGovernorate;

    final city = branch?.city ?? state.profileData.mainCity;

    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          _buildAppBar(
            state: state,
            isBrand: isBrand,
            isVerified: isVerified,
            governorate: governorate,
            city: city,
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(state, branch),
          _buildProductsTab(context, state),
          _buildStoreProfileTab(context, state, branch),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // App bar
  // ---------------------------------------------------------------------------

  SliverAppBar _buildAppBar({
    required StoreDetailsLoaded state,
    required bool isBrand,
    required bool isVerified,
    required String governorate,
    required String city,
  }) {
    final imageUrl = state.overviewData['imageUrl'] as String? ?? '';

    final title = state.overviewData['title'] as String? ?? '';

    final rating = state.profileData.ratingSummary;

    return SliverAppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      pinned: true,

      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),

      title: Row(
        children: [
          _buildStoreAvatar(imageUrl, size: 40),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 6),

                    /*
                     * Brand / verified only controls
                     * the badge.
                     *
                     * It does NOT control whether
                     * location/info/reviews/etc. exist.
                     */
                    if (isBrand)
                      const Icon(
                        Icons.verified,
                        color: Colors.amberAccent,
                        size: 18,
                      )
                    else if (isVerified)
                      const Icon(
                        Icons.verified,
                        color: Colors.cyanAccent,
                        size: 18,
                      ),
                  ],
                ),

                if (governorate.isNotEmpty || city.isNotEmpty)
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),

                      const SizedBox(width: 3),

                      Expanded(
                        child: Text(
                          _formatLocation(governorate, city),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),

                if (rating != null && rating.totalCount > 0)
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 16,
                      ),

                      const SizedBox(width: 3),

                      Text(
                        rating.averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(width: 4),

                      Text(
                        '(${rating.totalCount})',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),

      bottom: TabBar(
        controller: _tabController,
        labelColor: primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorColor: primaryColor,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Products'),
          Tab(text: 'Store Profile'),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Overview
  // ---------------------------------------------------------------------------

  Widget _buildOverviewTab(
    StoreDetailsLoaded state,
    StoreBranchModel? selectedBranch,
  ) {
    final overview =
        state.overviewData['overview'] as Map<String, dynamic>? ?? {};

    final title = overview['title'] as String? ?? '';

    final description = overview['description'] as String? ?? '';

    final bannerUrl = overview['bannerUrl'] as String? ?? '';

    final rawSections = overview['sections'] as List<dynamic>? ?? [];

    final sections =
        rawSections
            .whereType<Map<String, dynamic>>()
            .where((section) => (section['title'] as String? ?? '').isNotEmpty)
            .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
          ],

          _buildBanner(bannerUrl),

          if (description.isNotEmpty) ...[
            const SizedBox(height: 16),

            Text(
              description,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ],

          const SizedBox(height: 20),

          /*
           * Store information is available for:
           *
           * - brands
           * - verified stores
           * - regular stores
           *
           * It must NOT depend on isBrand.
           */
          _buildStoreInfoCard(state, selectedBranch),

          if (sections.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildCategories(sections),
          ],
        ],
      ),
    );
  }

  Widget _buildBanner(String bannerUrl) {
    if (bannerUrl.isEmpty) {
      return _bannerPlaceholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        bannerUrl,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return _bannerPlaceholder();
        },
      ),
    );
  }

  Widget _bannerPlaceholder() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store_mall_directory_rounded,
            size: 52,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            'No Banner Available',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(List<Map<String, dynamic>> sections) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),

        const SizedBox(height: 12),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sections.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final section = sections[index];

            final title = section['title'] as String? ?? '';

            final imageUrl = section['imageUrl'] as String? ?? '';

            return _buildCategoryCard(title, imageUrl);
          },
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String title, String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imageUrl.isNotEmpty)
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return _categoryPlaceholder();
              },
            )
          else
            _categoryPlaceholder(),

          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.55)],
              ),
            ),
          ),

          Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryPlaceholder() {
    return Container(
      color: primaryColor.withOpacity(0.08),
      child: const Icon(Icons.category_outlined, color: primaryColor, size: 35),
    );
  }

  // ---------------------------------------------------------------------------
  // Store information
  // ---------------------------------------------------------------------------

  Widget _buildStoreInfoCard(
    StoreDetailsLoaded state,
    StoreBranchModel? selectedBranch,
  ) {
    final rating = state.profileData.ratingSummary;

    final governorate =
        selectedBranch?.governorate ?? state.profileData.mainGovernorate;

    final city = selectedBranch?.city ?? state.profileData.mainCity;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Store Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),

          const SizedBox(height: 14),

          if (governorate.isNotEmpty || city.isNotEmpty)
            _buildInfoRow(
              Icons.location_on_outlined,
              'Location',
              _formatLocation(governorate, city),
            ),

          if (rating != null) ...[
            const SizedBox(height: 12),

            _buildInfoRow(
              Icons.star_outline_rounded,
              'Rating',
              rating.totalCount > 0
                  ? '${rating.averageRating.toStringAsFixed(1)} '
                      '(${rating.totalCount} reviews)'
                  : 'No ratings yet',
            ),
          ],

          if (state.profileData.branches.isNotEmpty) ...[
            const SizedBox(height: 12),

            _buildInfoRow(
              Icons.store_outlined,
              'Branches',
              '${state.profileData.branches.length}',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: primaryColor),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),

              const SizedBox(height: 2),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Products
  // ---------------------------------------------------------------------------

  Widget _buildProductsTab(BuildContext context, StoreDetailsLoaded state) {
    return Column(
      children: [
        _buildSortBar(context, state),

        Expanded(
          child:
              state.products.isEmpty
                  ? _buildEmptyProducts()
                  : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount:
                        state.products.length + (state.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.products.length) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return _buildProductCard(context, state.products[index]);
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildSortBar(BuildContext context, StoreDetailsLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Sort By:', style: TextStyle(color: Colors.grey)),

          DropdownButton<String>(
            value: state.currentSort,
            underline: const SizedBox.shrink(),
            items: const [
              DropdownMenuItem(value: 'popularity', child: Text('Popularity')),
              DropdownMenuItem(value: 'cheapest', child: Text('Lowest Price')),
              DropdownMenuItem(
                value: 'expensive',
                child: Text('Highest Price'),
              ),
            ],
            onChanged: (value) {
              if (value == null || value == state.currentSort) {
                return;
              }

              context.read<StoreDetailsBloc>().add(SortProducts(value));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, dynamic product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(productId: product.id),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                child:
                    product.imageUrl.isNotEmpty
                        ? Image.network(
                          product.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return _noImagePlaceholder();
                          },
                        )
                        : _noImagePlaceholder(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '${product.price.toStringAsFixed(0)} SYP',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      fontSize: 14,
                    ),
                  ),

                  if (product.hasDiscount) ...[
                    const SizedBox(height: 4),

                    Text(
                      'Discount: '
                      '${product.discountPercentage}%',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyProducts() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 52,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 12),

            Text(
              'No products available',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _noImagePlaceholder() {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_rounded,
            size: 40,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 4),

          Text(
            'No Image',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Store profile
  // ---------------------------------------------------------------------------

  Widget _buildStoreProfileTab(
    BuildContext context,
    StoreDetailsLoaded state,
    StoreBranchModel? selectedBranch,
  ) {
    final profile = state.profileData;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocationCard(profile, selectedBranch),

          const SizedBox(height: 20),

          _buildBranchesSection(context, profile),

          const SizedBox(height: 20),

          _buildRatingsSection(profile.ratingSummary),

          const SizedBox(height: 24),

          _buildReviewsSection(profile.reviews),
        ],
      ),
    );
  }

  Widget _buildLocationCard(
    StoreProfileModel profile,
    StoreBranchModel? selectedBranch,
  ) {
    final governorate = selectedBranch?.governorate ?? profile.mainGovernorate;

    final city = selectedBranch?.city ?? profile.mainCity;

    if (governorate.isEmpty && city.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 20,
                color: primaryColor,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  _formatLocation(governorate, city),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBranchesSection(
    BuildContext context,
    StoreProfileModel profile,
  ) {
    if (profile.branches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'All Branches',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),

        const SizedBox(height: 10),

        ...profile.branches.map((branch) => _buildBranchTile(context, branch)),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Branch navigation
  // ---------------------------------------------------------------------------

  Widget _buildBranchTile(BuildContext context, StoreBranchModel branch) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          final repository = context.read<StoreDetailsRepository>();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider(
                    create:
                        (_) => StoreDetailsBloc(repository)..add(
                          LoadStoreDetails(
                            /*
                         * VERY IMPORTANT:
                         *
                         * branch.id is NOT the store ID.
                         *
                         * branch.storeId is the
                         * actual parent store ID.
                         */
                            branch.storeId,
                            selectedBranch: branch,
                          ),
                        ),

                    /*
                 * Also pass the branch to the
                 * screen itself.
                 *
                 * This gives us a fallback even
                 * before/while the BLoC state loads.
                 */
                    child: StoreDetailsScreen(
                      storeId: branch.storeId,
                      selectedBranch: branch,
                    ),
                  ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.store_outlined,
                  color: primaryColor,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      branch.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: Colors.grey,
                        ),

                        const SizedBox(width: 4),

                        Expanded(
                          child: Text(
                            _formatLocation(branch.governorate, branch.city),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Ratings
  // ---------------------------------------------------------------------------

  Widget _buildRatingsSection(RatingSummary? rating) {
    if (rating == null) {
      return _buildEmptySection(
        title: 'Ratings & Reviews',
        message: 'No ratings yet',
        icon: Icons.star_border_rounded,
      );
    }

    if (rating.totalCount == 0) {
      return _buildEmptySection(
        title: 'Ratings & Reviews',
        message: 'No ratings yet',
        icon: Icons.star_border_rounded,
      );
    }

    return RatingBarChart(
      starsBreakdown: rating.starsBreakdown,
      totalCount: rating.totalCount,
      averageRating: rating.averageRating,
      barColor: primaryColor,
    );
  }

  // ---------------------------------------------------------------------------
  // Reviews
  // ---------------------------------------------------------------------------

  Widget _buildReviewsSection(List<Review>? reviews) {
    final reviewList = reviews ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customer Reviews',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),

        const SizedBox(height: 16),

        if (reviewList.isEmpty)
          _buildEmptySection(
            title: null,
            message: 'No reviews yet',
            icon: Icons.rate_review_outlined,
          )
        else
          ...reviewList.map((review) => ReviewCard(review: review)),
      ],
    );
  }

  Widget _buildEmptySection({
    String? title,
    required String message,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          if (title != null) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          Icon(icon, size: 38, color: Colors.grey.shade400),

          const SizedBox(height: 8),

          Text(
            message,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // General helpers
  // ---------------------------------------------------------------------------

  Widget _buildStoreAvatar(String imageUrl, {required double size}) {
    final placeholder = Container(
      width: size,
      height: size,
      color: primaryColor.withOpacity(0.1),
      child: Icon(Icons.store_rounded, color: primaryColor, size: size * 0.6),
    );

    if (imageUrl.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: placeholder,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return placeholder;
        },
      ),
    );
  }

  String _formatLocation(String governorate, String city) {
    return [
      if (governorate.isNotEmpty) governorate,
      if (city.isNotEmpty) city,
    ].join(' • ');
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 50, color: Colors.red.shade300),

            const SizedBox(height: 12),

            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Rating chart
// ============================================================================

class RatingBarChart extends StatelessWidget {
  final Map<int, int> starsBreakdown;
  final int totalCount;
  final double averageRating;
  final Color? barColor;
  final Color? backgroundColor;

  const RatingBarChart({
    super.key,
    required this.starsBreakdown,
    required this.totalCount,
    required this.averageRating,
    this.barColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final chartColor = barColor ?? StoreDetailsScreen.primaryColor;

    final bgColor = backgroundColor ?? Colors.grey.shade200;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Ratings & Reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: StoreDetailsScreen.primaryColor,
              ),
            ),

            const Spacer(),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: StoreDetailsScreen.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),

                  const SizedBox(width: 4),

                  Text(
                    averageRating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: StoreDetailsScreen.primaryColor,
                    ),
                  ),

                  const SizedBox(width: 4),

                  Text(
                    '($totalCount)',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        for (int star = 5; star >= 1; star--) ...[
          _buildRatingRow(
            star,
            starsBreakdown[star] ?? 0,
            totalCount,
            chartColor,
            bgColor,
          ),

          if (star != 1) const SizedBox(height: 8),
        ],
      ],
    );
  }

  Widget _buildRatingRow(
    int star,
    int count,
    int total,
    Color barColor,
    Color backgroundColor,
  ) {
    final percentage = total > 0 ? count / total : 0.0;

    return Row(
      children: [
        SizedBox(
          width: 30,
          child: Row(
            children: [
              Text(
                '$star',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(width: 2),

              const Icon(Icons.star, color: Colors.amber, size: 14),
            ],
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 8,
            backgroundColor: backgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(
              count > 0 ? barColor : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),

        const SizedBox(width: 12),

        SizedBox(
          width: 30,
          child: Text(
            '$count',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: count > 0 ? Colors.black87 : Colors.grey.shade400,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// Review card
// ============================================================================

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: StoreDetailsScreen.primaryColor.withOpacity(
                  0.1,
                ),
                child: Text(
                  review.userName.isNotEmpty
                      ? review.userName[0].toUpperCase()
                      : 'U',
                  style: TextStyle(
                    color: StoreDetailsScreen.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (index) => Icon(
                            index < review.rating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 16,
                          ),
                        ),

                        const SizedBox(width: 8),

                        Text(
                          review.createdAt,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: 10),

            Text(
              review.comment,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
