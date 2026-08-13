import 'package:delni_rms/features/products/view%20model/ProductDetailsEvent.dart';
import 'package:delni_rms/features/products/view%20model/ProductDetailsRepository.dart';
import 'package:delni_rms/features/products/view%20model/ProductDetailsState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final ProductDetailsRepository repository;
  int? _currentProductId;
  int _reviewsPage = 1;
  static const _reviewsPageSize = 5;

  ProductDetailsBloc(this.repository) : super(const ProductDetailsLoading()) {
    on<LoadProductDetails>(_onLoad);
    on<RefreshProductDetails>(_onRefresh);
    on<LoadMoreReviews>(_onLoadMoreReviews);
    on<ColorSelected>(_onColorSelected);
    on<SizeSelected>(_onSizeSelected);
    on<QuantityChanged>(_onQuantityChanged);
  }

  Future<void> _onLoad(
    LoadProductDetails event,
    Emitter<ProductDetailsState> emit,
  ) async {
    _currentProductId = event.productId;
    _reviewsPage = 1;
    emit(const ProductDetailsLoading());
    await _fetchAll(emit, event.productId);
  }

  Future<void> _onRefresh(
    RefreshProductDetails event,
    Emitter<ProductDetailsState> emit,
  ) async {
    if (_currentProductId == null) return;
    _reviewsPage = 1;
    await _fetchAll(emit, _currentProductId!, silently: true);
  }

  Future<void> _fetchAll(
    Emitter<ProductDetailsState> emit,
    int productId, {
    bool silently = false,
  }) async {
    try {
      final productFuture = repository.getProductDetails(productId);
      final reviewsFuture = repository.getProductReviews(
        productId,
        page: 1,
        limit: _reviewsPageSize,
      );
      final similarFuture = repository.getSimilarProducts(productId);
      final recommendedFuture = repository.getRecommendedProducts(productId);

      final product = await productFuture;
      final reviews = await reviewsFuture;
      final similar = await similarFuture;
      final recommended = await recommendedFuture;

      emit(
        ProductDetailsLoaded(
          product: product,
          reviews: reviews,
          similarProducts: similar,
          recommendedProducts: recommended,
          selectedColorId:
              product.colors.isNotEmpty ? product.colors.first.id : null,
        ),
      );
    } catch (e) {
      emit(ProductDetailsError(e.toString()));
    }
  }

  Future<void> _onLoadMoreReviews(
    LoadMoreReviews event,
    Emitter<ProductDetailsState> emit,
  ) async {
    final state = this.state;
    if (state is! ProductDetailsLoaded) return;
    if (state.isLoadingMoreReviews || !state.reviews.hasMore) return;
    if (_currentProductId == null) return;

    emit(state.copyWith(isLoadingMoreReviews: true));
    try {
      final nextPage = _reviewsPage + 1;
      final moreReviews = await repository.getProductReviews(
        _currentProductId!,
        page: nextPage,
        limit: _reviewsPageSize,
      );
      _reviewsPage = nextPage;

      final mergedReviews = [...state.reviews.reviews, ...moreReviews.reviews];
      emit(
        state.copyWith(
          reviews: state.reviews.copyWith(
            reviews: mergedReviews,
            hasMore: moreReviews.hasMore,
          ),
          isLoadingMoreReviews: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingMoreReviews: false));
    }
  }

  void _onColorSelected(
    ColorSelected event,
    Emitter<ProductDetailsState> emit,
  ) {
    final state = this.state;
    if (state is! ProductDetailsLoaded) return;
    emit(state.copyWith(selectedColorId: event.colorId));
  }

  void _onSizeSelected(SizeSelected event, Emitter<ProductDetailsState> emit) {
    final state = this.state;
    if (state is! ProductDetailsLoaded) return;
    emit(state.copyWith(selectedSize: event.sizeLabel));
  }

  void _onQuantityChanged(
    QuantityChanged event,
    Emitter<ProductDetailsState> emit,
  ) {
    final state = this.state;
    if (state is! ProductDetailsLoaded) return;
    final clamped = event.quantity.clamp(
      1,
      state.product.stockCount == 0 ? 1 : state.product.stockCount,
    );
    emit(state.copyWith(quantity: clamped));
  }
}
