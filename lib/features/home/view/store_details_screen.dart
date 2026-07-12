import 'package:delni_rms/features/home/Model/StoreProfileModel.dart';
import 'package:delni_rms/features/home/view%20model/store_details_bloc.dart';
import 'package:delni_rms/features/home/view%20model/store_details_event.dart';
import 'package:delni_rms/features/home/view%20model/store_details_repository.dart';
import 'package:delni_rms/features/home/view%20model/store_details_state.dart';
import 'package:delni_rms/features/home/view/ProductDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


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
    final defaultBarColor = barColor ?? const Color(0xFF6B2D5C);
    final defaultBgColor = backgroundColor ?? Colors.grey.shade200;

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
                color: Color(0xFF6B2D5C),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF6B2D5C).withOpacity(0.1),
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
                      color: Color(0xFF6B2D5C),
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
        _buildRatingRow(
          5,
          starsBreakdown[5] ?? 0,
          totalCount,
          defaultBarColor,
          defaultBgColor,
        ),
        const SizedBox(height: 8),
        _buildRatingRow(
          4,
          starsBreakdown[4] ?? 0,
          totalCount,
          defaultBarColor,
          defaultBgColor,
        ),
        const SizedBox(height: 8),
        _buildRatingRow(
          3,
          starsBreakdown[3] ?? 0,
          totalCount,
          defaultBarColor,
          defaultBgColor,
        ),
        const SizedBox(height: 8),
        _buildRatingRow(
          2,
          starsBreakdown[2] ?? 0,
          totalCount,
          defaultBarColor,
          defaultBgColor,
        ),
        const SizedBox(height: 8),
        _buildRatingRow(
          1,
          starsBreakdown[1] ?? 0,
          totalCount,
          defaultBarColor,
          defaultBgColor,
        ),
      ],
    );
  }

  Widget _buildRatingRow(
    int starNumber,
    int count,
    int total,
    Color barColor,
    Color bgColor,
  ) {
    final percentage = total > 0 ? count / total : 0.0;

    return Row(
      children: [
        SizedBox(
          width: 30,
          child: Row(
            children: [
              Text(
                '$starNumber',
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
            backgroundColor: bgColor,
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
            count.toString(),
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

class ReviewCard extends StatelessWidget {
  final Review review; 
  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                backgroundColor: const Color(0xFF6B2D5C).withOpacity(0.1),
                child: Text(
                  review.userName.isNotEmpty
                      ? review.userName[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    color: Color(0xFF6B2D5C),
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
          const SizedBox(height: 10),
          if (review.comment.isNotEmpty)
            Text(
              review.comment,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
        ],
      ),
    );
  }
}

class StoreDetailsScreen extends StatefulWidget {
  final int storeId;
  const StoreDetailsScreen({super.key, required this.storeId});

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final Color _primaryColor = const Color(0xFF6B2D5C);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _scrollController.addListener(() {
      if (_tabController.index == 1 &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.9) {
        context.read<StoreDetailsBloc>().add(LoadMoreProducts());
      }
    });
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
            return Center(child: Text(state.message));
          }
          if (state is StoreDetailsLoaded) {
            return NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    pinned: true,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: Row(
                      children: [
                       ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child:
                              state.overviewData['imageUrl'] != null &&
                                      state.overviewData['imageUrl'].isNotEmpty
                                  ? Image.network(
                                    state.overviewData['imageUrl'],
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 40,
                                        height: 40,
                                        color: _primaryColor.withOpacity(0.1),
                                        child: Icon(
                                          Icons.store_rounded,
                                          color: _primaryColor,
                                          size: 24,
                                        ),
                                      );
                                    },
                                  )
                                  : Container(
                                    width: 40,
                                    height: 40,
                                    color: _primaryColor.withOpacity(0.1),
                                    child: Icon(
                                      Icons.store_rounded,
                                      color: _primaryColor,
                                      size: 24,
                                    ),
                                  ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            state.overviewData['title'] ?? '',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1, 
                            overflow:
                                TextOverflow.ellipsis, 
                          ),
                        ),
                        const SizedBox(width: 6),
                        state.overviewData['isVerified'] == true
                            ? const Icon(
                              Icons.verified,
                              color: Colors.blue,
                              size: 20,
                            )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    bottom: TabBar(
                      controller: _tabController,
                      labelColor: _primaryColor,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: _primaryColor,
                      tabs: const [
                        Tab(text: 'Overview'),
                        Tab(text: 'Products'),
                        Tab(text: 'Store Profile'),
                      ],
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildShopFrontTab(state.overviewData),
                  _buildProductsTab(context, state),
                  _buildStoreProfileTab(context, state.profileData ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildShopFrontTab(Map<String, dynamic> data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

                Text(
            data['overview']?['title'] ?? '',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B2D5C),
            ),
          ),
          Text(
            data['overview']?['description'] ?? 'No description available.',
            style: const TextStyle(fontSize: 16),
          ),
                    const SizedBox(height: 16),

          if (data['overview']?['bannerUrl'] != null &&
              data['overview']['bannerUrl'].isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                data['overview']['bannerUrl'],
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey.shade200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported_rounded,
                          size: 60,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No Banner Available',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
     
        ],
      ),
    );
  }

Widget _buildProductsTab(BuildContext context, StoreDetailsLoaded state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Sort By:', style: TextStyle(color: Colors.grey)),
              DropdownButton<String>(
                value: state.currentSort,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(
                    value: 'popularity',
                    child: Text('Popularity'),
                  ),
                  DropdownMenuItem(
                    value: 'cheapest',
                    child: Text('Lowest Price'),
                  ),
                  DropdownMenuItem(
                    value: 'expensive',
                    child: Text('Highest Price'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    context.read<StoreDetailsBloc>().add(SortProducts(val));
                  }
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.products.length + (state.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.products.length) {
                return const Center(child: CircularProgressIndicator());
              }
              final product = state.products[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ProductDetailsScreen(productId: product.id),
                    ),
                  );
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: double.infinity,
                                        color: Colors.grey.shade200,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.shopping_bag_rounded,
                                              size: 40,
                                              color: Colors.grey.shade400,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'No Image',
                                              style: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                  : Container(
                                    width: double.infinity,
                                    color: Colors.grey.shade200,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.shopping_bag_rounded,
                                          size: 40,
                                          color: Colors.grey.shade400,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'No Image',
                                          style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
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
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _primaryColor,
                                fontSize: 14,
                              ),
                            ),
                            if (product.hasDiscount) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Discount: ${product.discountPercentage}%',
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
            },
          ),
        ),
      ],
    );
  }

Widget _buildStoreProfileTab( BuildContext context,StoreProfileModel profile,) {
    final ratingSummary = profile.ratingSummary;
    final reviews = profile.reviews;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Text(
          //   'Main Branch Location',
          //   style: TextStyle(color: Colors.grey, fontSize: 14),
          // ),
          const SizedBox(height: 4),
       Row(
  children: [
    Expanded(
      child: Text(
        profile.mainGovernorate,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6B2D5C),
        ),
        textAlign: TextAlign.right, // 
      ),
    ),
    Expanded(child:     const SizedBox(width: 20)),
    Expanded(
      child: Text(
        profile.mainCity,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6B2D5C),
        ),
        textAlign: TextAlign.left, // 
      ),
    ),
  ],),
          const Divider(height: 33),

          const Text(
            'All Branches',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Color(0xFF6B2D5C)),
          ),
          const SizedBox(height: 10),
          ...profile.branches.map(
            (branch) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: Text(
                  branch.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text('${branch.governorate} - ${branch.city}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  final repo = context.read<StoreDetailsRepository>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => BlocProvider(
                            create:
                                (_) =>
                                    StoreDetailsBloc(repo)
                                      ..add(LoadStoreDetails(branch.storeId)),
                            child: StoreDetailsScreen(storeId: branch.storeId),
                          ),
                    ),
                  );
                },
              ),
            ),
          ),

          if (ratingSummary != null) ...[
            const Divider(height: 30),
            RatingBarChart(
              starsBreakdown: ratingSummary.starsBreakdown,
              totalCount: ratingSummary.totalCount,
              averageRating: ratingSummary.averageRating,
              barColor: const Color(0xFF6B2D5C),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            const Text(
              'Customer Reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B2D5C),
              ),
            ),
            const SizedBox(height: 16),

            if (reviews != null && reviews.isNotEmpty)
              ...reviews.map(
                (review) => ReviewCard(review: review), 
              )
            else
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'No reviews yet',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  ),
                ),
              ),
          ] else
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.grey.shade400,
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No ratings available',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}





