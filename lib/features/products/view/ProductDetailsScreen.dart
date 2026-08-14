import 'package:carousel_slider/carousel_slider.dart';
import 'package:delni_rms/features/cart/model/CartItemModel.dart';
import 'package:delni_rms/features/products/model/ProductDetailModel.dart';
import 'package:delni_rms/features/products/model/ProductReviewModel.dart';
import 'package:delni_rms/features/cart/view%20model/CartBloc.dart';
import 'package:delni_rms/features/cart/view%20model/CartEvent.dart';
import 'package:delni_rms/features/cart/view%20model/CartState.dart';
import 'package:delni_rms/features/favorites/view%20model/favorites_event.dart';
import 'package:delni_rms/features/products/view%20model/ProductDetailsBloc.dart';
import 'package:delni_rms/features/products/view%20model/ProductDetailsEvent.dart';
import 'package:delni_rms/features/products/view%20model/ProductDetailsRepository.dart';
import 'package:delni_rms/features/products/view%20model/ProductDetailsState.dart';
import 'package:delni_rms/features/favorites/view%20model/favorites_bloc.dart';
import 'package:delni_rms/features/favorites/view%20model/favorites_state.dart';
import 'package:delni_rms/features/cart/view/Cart.dart';
import 'package:delni_rms/features/favorites/view/Favorites.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../cart/view model/CartRepository.dart';
import '../../favorites/view model/FavoritesRepository.dart';

const _primaryColor = Color(0xFF6B2D5C);
const _lowStockThreshold = 5;

class ProductDetailsScreen extends StatelessWidget {
  final int productId;
  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) =>
                  ProductDetailsBloc(ProductDetailsRepository(http.Client()))
                    ..add(LoadProductDetails(productId)),
        ),
        BlocProvider(
          create: (_) => FavoritesBloc(FavoritesRepository(http.Client())),
        ),
        BlocProvider(create: (_) => CartBloc(CartRepository(http.Client()))),
      ],
      child: const _ProductDetailsView(),
    );
  }
}

class _ProductDetailsView extends StatefulWidget {
  const _ProductDetailsView();

  @override
  State<_ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<_ProductDetailsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.95) {
        context.read<ProductDetailsBloc>().add(const LoadMoreReviews());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is ProductDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProductDetailsError) {
              return _buildError(context, state.message);
            }
            if (state is ProductDetailsLoaded) {
              return _buildLoaded(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 56, color: Colors.grey),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed:
                  () => context.read<ProductDetailsBloc>().add(
                    const RefreshProductDetails(),
                  ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, ProductDetailsLoaded state) {
    final product = state.product;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(child: _buildTopBar(context, product)),
        SliverToBoxAdapter(
          child: ProductImageGallery(
            imageUrls: product.images.map((e) => e.imageUrl).toList(),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildHeader(product),
              const SizedBox(height: 16),
              ColorSelector(
                colors: product.colors,
                selectedColorId: state.selectedColorId,
                onColorSelected:
                    (id) => context.read<ProductDetailsBloc>().add(
                      ColorSelected(id),
                    ),
              ),
              if (product.colors.isNotEmpty) const SizedBox(height: 16),
              SizeSelector(
                sizes: product.sizes,
                selectedSize: state.selectedSize,
                onSizeSelected:
                    (size) => context.read<ProductDetailsBloc>().add(
                      SizeSelected(size),
                    ),
                onSizeChartTap: () => _showSizeChart(context),
              ),
              if (product.sizes.isNotEmpty) const SizedBox(height: 12),
              if (product.isInStock && product.stockCount <= _lowStockThreshold)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${product.stockCount} piece${product.stockCount == 1 ? '' : 's'} left only',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              QuantitySelector(
                quantity: state.quantity,
                maxQuantity: product.stockCount == 0 ? 1 : product.stockCount,
                onChanged:
                    (q) => context.read<ProductDetailsBloc>().add(
                      QuantityChanged(q),
                    ),
              ),
              const SizedBox(height: 16),
              _buildActionButtons(context, state),
              const SizedBox(height: 24),
              ExpandableSection(
                title: 'Product Details',
                initiallyExpanded: true,
                child: Text(
                  product.description.isNotEmpty
                      ? product.description
                      : 'No description available.',
                  style: TextStyle(color: Colors.grey.shade700, height: 1.5),
                ),
              ),
              ExpandableSection(
                title: 'Specification',
                child: SpecificationTable(
                  specifications: product.specifications,
                ),
              ),
              const SizedBox(height: 8),
              ProductRatingSummary(
                averageRating: state.reviews.averageRating,
                verifiedBuyers: state.reviews.verifiedBuyers,
              ),
              VerifiedBuyersLabel(count: state.reviews.verifiedBuyers),
              const SizedBox(height: 16),
              if (state.reviews.reviews.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'No reviews yet',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                )
              else
                ...state.reviews.reviews.map(
                  (review) => ProductReviewCard(review: review),
                ),
              if (state.isLoadingMoreReviews)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(child: CircularProgressIndicator()),
                ),
              const SizedBox(height: 8),
              if (product.howItWasMade.isNotEmpty)
                ExpandableSection(
                  title: 'How this was made',
                  child: Text(
                    product.howItWasMade,
                    style: TextStyle(color: Colors.grey.shade700, height: 1.5),
                  ),
                ),
              if (product.manufacturingInformation.isNotEmpty)
                ExpandableSection(
                  title: 'Manufacturing Information',
                  child: Text(
                    product.manufacturingInformation,
                    style: TextStyle(color: Colors.grey.shade700, height: 1.5),
                  ),
                ),
              const SizedBox(height: 16),
              RelatedProductsSection(
                title: 'Similar Products',
                products: state.similarProducts,
                showSortBy: true,
              ),
              const SizedBox(height: 24),
              RelatedProductsSection(
                title: 'Customers also like',
                products: state.recommendedProducts,
              ),
              const SizedBox(height: 24),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context, ProductDetailModel product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),

          // IconButton(
          //   icon: const Icon(Icons.favorite_border, color: Colors.black),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (_) => const Favorites()),
          //     );
          //   },
          // ),
          // const CartIconBadge(),
        ],
      ),
    );
  }

  Widget _buildHeader(ProductDetailModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          product.brand.name,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (product.discountPercentage > 0)
              Text(
                '${product.currency} ${product.oldPrice.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade400,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            if (product.discountPercentage > 0) const SizedBox(width: 8),
            Text(
              '${product.currency} ${product.price.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
            if (product.discountPercentage > 0) ...[
              const SizedBox(width: 8),
              Text(
                '(${product.discountPercentage}% Off)',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, ProductDetailsLoaded state) {
    final product = state.product;
    final requiresSizeSelection =
        product.sizes.isNotEmpty && state.selectedSize == null;

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: BlocBuilder<FavoritesBloc, FavoritesState>(
            buildWhen:
                (previous, current) =>
                    previous.isFavorite(product.productId) !=
                    current.isFavorite(product.productId),
            builder: (context, favState) {
              final isFavorite = favState.isFavorite(product.productId);
              return OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: _primaryColor,
                  side: const BorderSide(color: _primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed:
                    () => context.read<FavoritesBloc>().add(
                      FavoriteToggled(product.productId, isFavorite),
                    ),
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                label: const Text('Wishlist'),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 6,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed:
                !product.isInStock
                    ? null
                    : () {
                      if (requiresSizeSelection) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select a size')),
                        );
                        return;
                      }
                      final selectedColor =
                          product.colors.isEmpty
                              ? null
                              : product.colors.firstWhere(
                                (c) => c.id == state.selectedColorId,
                                orElse: () => product.colors.first,
                              );
                      context.read<CartBloc>().add(
                        CartItemAdded(
                          CartItemModel(
                            productId: product.productId,
                            name: product.name,
                            imageUrl:
                                product.images.isNotEmpty
                                    ? product.images.first.imageUrl
                                    : '',
                            price: product.price,
                            currency: product.currency,
                            colorId: selectedColor?.id,
                            colorName: selectedColor?.name,
                            colorHex: selectedColor?.hex,
                            size: state.selectedSize,
                            quantity: state.quantity,
                          ),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to Cart')),
                      );
                    },
            icon: const Icon(Icons.shopping_cart_outlined),
            label: Text(product.isInStock ? 'Add to Cart' : 'Out of Stock'),
          ),
        ),
      ],
    );
  }

  void _showSizeChart(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => const Padding(
            padding: EdgeInsets.all(24),
            child: Text('Size chart coming soon.'),
          ),
    );
  }
}

enum RelatedProductsSort { none, priceLowToHigh, priceHighToLow, rating }

class RelatedProductsSection extends StatefulWidget {
  final String title;
  final List<SimilarProductModel> products;
  final bool showSortBy;

  const RelatedProductsSection({
    super.key,
    required this.title,
    required this.products,
    this.showSortBy = false,
  });

  @override
  State<RelatedProductsSection> createState() => _RelatedProductsSectionState();
}

class _RelatedProductsSectionState extends State<RelatedProductsSection> {
  RelatedProductsSort _sort = RelatedProductsSort.none;

  List<SimilarProductModel> get _sortedProducts {
    final list = List<SimilarProductModel>.from(widget.products);
    switch (_sort) {
      case RelatedProductsSort.priceLowToHigh:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case RelatedProductsSort.priceHighToLow:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case RelatedProductsSort.rating:
        list.sort((a, b) => b.averageRating.compareTo(a.averageRating));
        break;
      case RelatedProductsSort.none:
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B2D5C),
                ),
              ),
              if (widget.showSortBy)
                DropdownButton<RelatedProductsSort>(
                  value: _sort,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down, size: 18),
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                  items: const [
                    DropdownMenuItem(
                      value: RelatedProductsSort.none,
                      child: Text('Sort By'),
                    ),
                    DropdownMenuItem(
                      value: RelatedProductsSort.priceLowToHigh,
                      child: Text('Price: Low to High'),
                    ),
                    DropdownMenuItem(
                      value: RelatedProductsSort.priceHighToLow,
                      child: Text('Price: High to Low'),
                    ),
                    DropdownMenuItem(
                      value: RelatedProductsSort.rating,
                      child: Text('Top Rated'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _sort = value);
                  },
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _sortedProducts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final product = _sortedProducts[index];
              return RelatedProductCard(
                product: product,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ProductDetailsScreen(productId: product.id),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class ProductReviewCard extends StatefulWidget {
  final ProductReviewModel review;
  const ProductReviewCard({super.key, required this.review});

  @override
  State<ProductReviewCard> createState() => _ProductReviewCardState();
}

class _ProductReviewCardState extends State<ProductReviewCard> {
  bool _expanded = false;
  late final TapGestureRecognizer _readMoreRecognizer;

  @override
  void initState() {
    super.initState();
    _readMoreRecognizer =
        TapGestureRecognizer()
          ..onTap = () => setState(() => _expanded = !_expanded);
  }

  @override
  void dispose() {
    _readMoreRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final review = widget.review;
    final commentTooLong = review.comment.length > 140;
    final displayedComment =
        !_expanded && commentTooLong
            ? '${review.comment.substring(0, 140)}...'
            : review.comment;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (review.fitTag != null && review.fitTag!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                review.fitTag!,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 15),
              const SizedBox(width: 4),
              Text(
                review.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                review.userName,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              ),
              const SizedBox(width: 8),
              Text(
                review.createdAt,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (review.comment.isNotEmpty)
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 13,
                  height: 1.4,
                ),
                children: [
                  TextSpan(text: displayedComment),
                  if (commentTooLong)
                    TextSpan(
                      text: _expanded ? '  Show less' : '  Read More',
                      style: const TextStyle(
                        color: Color(0xFF6B2D5C),
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: _readMoreRecognizer,
                    ),
                ],
              ),
            ),
          if (review.images.isNotEmpty) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: review.images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      review.images[index],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.image,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ProductRatingSummary extends StatelessWidget {
  final double averageRating;
  final int verifiedBuyers;

  const ProductRatingSummary({
    super.key,
    required this.averageRating,
    required this.verifiedBuyers,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
        Text(
          averageRating.toStringAsFixed(1),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 4),
        ...List.generate(5, (index) {
          final filled = index < averageRating.round();
          return Icon(
            filled ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 18,
          );
        }),
      ],
    );
  }
}

class VerifiedBuyersLabel extends StatelessWidget {
  final int count;
  const VerifiedBuyersLabel({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$count Verified Buyers',
      style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
    );
  }
}

class SpecificationTable extends StatelessWidget {
  final Map<String, String> specifications;

  const SpecificationTable({super.key, required this.specifications});

  @override
  Widget build(BuildContext context) {
    if (specifications.isEmpty) {
      return Text(
        'No specifications available.',
        style: TextStyle(color: Colors.grey.shade500),
      );
    }
    final entries = specifications.entries.toList();

    return Wrap(
      runSpacing: 14,
      children: List.generate((entries.length / 2).ceil(), (rowIndex) {
        final first = entries[rowIndex * 2];
        final second =
            (rowIndex * 2 + 1) < entries.length
                ? entries[rowIndex * 2 + 1]
                : null;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _specCell(first.key, first.value)),
            const SizedBox(width: 16),
            Expanded(
              child:
                  second != null
                      ? _specCell(second.key, second.value)
                      : const SizedBox.shrink(),
            ),
          ],
        );
      }),
    );
  }

  Widget _specCell(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class ExpandableSection extends StatefulWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;

  const ExpandableSection({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
  });

  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6B2D5C),
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF6B2D5C),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState:
                _expanded
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: widget.child,
            ),
            secondChild: const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final int maxQuantity;
  final ValueChanged<int> onChanged;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.maxQuantity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Quantity',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              _stepButton(
                icon: Icons.remove,
                onTap: quantity > 1 ? () => onChanged(quantity - 1) : null,
              ),
              SizedBox(
                width: 32,
                child: Text(
                  '$quantity',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              _stepButton(
                icon: Icons.add,
                onTap:
                    quantity < maxQuantity
                        ? () => onChanged(quantity + 1)
                        : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepButton({required IconData icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          size: 16,
          color: onTap == null ? Colors.grey.shade300 : Colors.black87,
        ),
      ),
    );
  }
}

class SizeSelector extends StatelessWidget {
  final List<ProductSizeModel> sizes;
  final String? selectedSize;
  final ValueChanged<String> onSizeSelected;
  final VoidCallback? onSizeChartTap;

  const SizeSelector({
    super.key,
    required this.sizes,
    required this.selectedSize,
    required this.onSizeSelected,
    this.onSizeChartTap,
  });

  @override
  Widget build(BuildContext context) {
    if (sizes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select Size',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            InkWell(
              onTap: onSizeChartTap,
              child: const Text(
                'Size Chart',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B2D5C),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children:
              sizes.map((size) {
                final isSelected = size.label == selectedSize;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap:
                        size.isAvailable
                            ? () => onSizeSelected(size.label)
                            : null,
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFF6B2D5C) : Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color:
                              isSelected
                                  ? const Color(0xFF6B2D5C)
                                  : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        size.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color:
                              !size.isAvailable
                                  ? Colors.grey.shade300
                                  : isSelected
                                  ? Colors.white
                                  : Colors.black87,
                          decoration:
                              !size.isAvailable
                                  ? TextDecoration.lineThrough
                                  : null,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}

class ColorSelector extends StatelessWidget {
  final List<ProductColorModel> colors;
  final int? selectedColorId;
  final ValueChanged<int> onColorSelected;

  const ColorSelector({
    super.key,
    required this.colors,
    required this.selectedColorId,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (colors.isEmpty) return const SizedBox.shrink();
    final selected = colors.firstWhere(
      (c) => c.id == selectedColorId,
      orElse: () => colors.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Color',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            Text(
              selected.name,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children:
              colors.map((color) {
                final isSelected = color.id == selectedColorId;
                final swatchColor = _parseHex(color.hex);
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: () => onColorSelected(color.id),
                    customBorder: const CircleBorder(),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              isSelected
                                  ? const Color(0xFF6B2D5C)
                                  : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: swatchColor,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Color _parseHex(String hex) {
    var value = hex.replaceAll('#', '');
    if (value.length == 6) value = 'FF$value';
    return Color(int.tryParse(value, radix: 16) ?? 0xFF000000);
  }
}

class ProductImageGallery extends StatefulWidget {
  final List<String> imageUrls;
  const ProductImageGallery({super.key, required this.imageUrls});

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.imageUrls.isEmpty ? [''] : widget.imageUrls;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider.builder(
          itemCount: images.length,
          itemBuilder: (context, index, realIndex) {
            final url = images[index];
            return url.isEmpty
                ? Container(
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 48,
                  ),
                )
                : Image.network(
                  url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        color: Colors.grey.shade200,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 48,
                        ),
                      ),
                );
          },
          options: CarouselOptions(
            height: 420,
            viewportFraction: 1,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
        ),
        if (images.length > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                final isActive = index == _currentIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isActive ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color:
                        isActive
                            ? const Color(0xFF6B2D5C)
                            : Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

class CartIconBadge extends StatelessWidget {
  final Color color;
  const CartIconBadge({super.key, this.color = const Color(0xFF6B2D5C)});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen:
          (previous, current) =>
              previous.totalItemsCount != current.totalItemsCount,
      builder: (context, state) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            );
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.1),
                ),
                child: Icon(Icons.shopping_bag_outlined, color: color),
              ),
              if (state.totalItemsCount > 0)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${state.totalItemsCount}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class FavoriteButton extends StatelessWidget {
  final int productId;
  final double size;
  final Color activeColor;
  final Color inactiveColor;

  const FavoriteButton({
    super.key,
    required this.productId,
    this.size = 22,
    this.activeColor = const Color(0xFF6B2D5C),
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      buildWhen:
          (previous, current) =>
              previous.isFavorite(productId) != current.isFavorite(productId),
      builder: (context, state) {
        final isFavorite = state.isFavorite(productId);
        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            context.read<FavoritesBloc>().add(
              FavoriteToggled(productId, isFavorite), // الآن يعرف الكلاس
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? activeColor : inactiveColor,
              size: size,
            ),
          ),
        );
      },
    );
  }
}

class RelatedProductCard extends StatelessWidget {
  final SimilarProductModel product;
  final VoidCallback onTap;

  const RelatedProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.imageUrl,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => Container(
                      height: 140,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported),
                    ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              '${product.currency} ${product.price.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B2D5C),
              ),
            ),
            if (product.averageRating > 0) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 2),
                  Text(
                    product.averageRating.toStringAsFixed(1),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
