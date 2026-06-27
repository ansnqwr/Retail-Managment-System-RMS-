import '/features/pagination/Model/FiltersModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../categories/Model/CategoryItemModel.dart';
import '../../home/Model/ProductCardModel.dart';
import '../../home/Model/StoreCardItem.dart';
import 'pagination_event.dart';
import 'pagination_repository.dart';
import 'pagination_state.dart';

class PaginationBloc extends Bloc<PaginationEvent, PaginationState> {
  final PaginationRepository _paginationRepository;

  String? _businessType;
  late bool _isProduct;
  late bool _isStore;
  late bool _isSubCategory;
  bool? _hasSubCategories;
  int? _subCategoryId;
  late String _paginationTitle;
  List<String> _searchChips = [];
  Map<String, dynamic> _currentFilters = {};
  FiltersModel? filtersModel;
  int _currentPage = 1;
  static const int _limit = 10;
  static const int maxSearchChips = 5;

  PaginationBloc({required PaginationRepository paginationRepository})
    : _paginationRepository = paginationRepository,
      super(const PaginationInitial()) {
    on<PaginationLoadRequested>(_onLoadRequested);
    on<PaginationRefreshRequested>(_onRefreshRequested);
    on<PaginationLoadMoreRequested>(_onLoadMoreRequested);
    on<PaginationSearchSubmitted>(_onSearchSubmitted);
    on<PaginationSearchChipRemoved>(_onSearchChipRemoved);
    on<PaginationSearchChipsCleared>(_onSearchChipsCleared);
    on<PaginationFiltersApplied>(_onFiltersApplied);
    on<PaginationFilterChipRemoved>(_onFilterChipRemoved);
    on<PaginationFiltersCleared>(_onFiltersCleared);
    on<PaginationSubCategoryTapped>(_onSubCategoryTapped);
    on<PaginationProductTapped>(_onProductTapped);
    on<PaginationStoreTapped>(_onStoreTapped);
  }

  Future<void> _onLoadRequested(
    PaginationLoadRequested event,
    Emitter<PaginationState> emit,
  ) async {
    _businessType = event.businessType;
    _isProduct = event.isProduct;
    _isStore = event.isStore;
    _isSubCategory = event.isSubCategory;
    _hasSubCategories = event.hasSubCategories;
    _subCategoryId = event.subCategoryId;
    _paginationTitle = event.paginationTitle;
    _searchChips = _parsePaginationTitleToChips(event.paginationTitle);
    _currentFilters = {'inStockOnly': true};
    _currentPage = 1;
    filtersModel = null;
    await _loadData(emit, isRefresh: true);
  }

  Future<void> _onRefreshRequested(
    PaginationRefreshRequested event,
    Emitter<PaginationState> emit,
  ) async {
    _currentPage = 1;
    await _loadData(emit, isRefresh: true);
  }

  Future<void> _onLoadMoreRequested(
    PaginationLoadMoreRequested event,
    Emitter<PaginationState> emit,
  ) async {
    if (state is! PaginationLoaded) return;

    final currentState = state as PaginationLoaded;
    if (!currentState.hasMoreData || currentState.isLoadingMore) return;

    _currentPage = currentState.currentPage + 1;
    await _loadData(emit, isLoadMore: true);
  }

  Future<void> _onSearchSubmitted(
    PaginationSearchSubmitted event,
    Emitter<PaginationState> emit,
  ) async {
    final trimmedQuery = event.query.trim();
    if (trimmedQuery.isEmpty) return;

    // Check for duplicates
    if (_searchChips.any(
      (chip) => chip.toLowerCase() == trimmedQuery.toLowerCase(),
    )) {
      return;
    }

    if (_searchChips.length >= maxSearchChips) {
      emit(
        PaginationError(
          'You can only use $maxSearchChips search chips at a time. Remove one to add another.',
        ),
      );
      if (state is PaginationLoaded) {
        final lastState = state as PaginationLoaded;
        emit(lastState.copyWith());
      }
      return;
    }

    _searchChips = List<String>.from(_searchChips)..add(trimmedQuery);
    _currentPage = 1;
    await _loadData(emit, isRefresh: true);
  }

  Future<void> _onSearchChipRemoved(
    PaginationSearchChipRemoved event,
    Emitter<PaginationState> emit,
  ) async {
    if (event.chipIndex >= 0 && event.chipIndex < _searchChips.length) {
      _searchChips = List<String>.from(_searchChips)..removeAt(event.chipIndex);
      _currentPage = 1;
      await _loadData(emit, isRefresh: true);
    }
  }

  Future<void> _onSearchChipsCleared(
    PaginationSearchChipsCleared event,
    Emitter<PaginationState> emit,
  ) async {
    _searchChips = [];
    _currentPage = 1;
    await _loadData(emit, isRefresh: true);
  }

  Future<void> _onFiltersApplied(
    PaginationFiltersApplied event,
    Emitter<PaginationState> emit,
  ) async {
    _currentFilters = event.filters;
    _currentPage = 1;
    await _loadData(emit, isRefresh: true);
  }

  Future<void> _onFilterChipRemoved(
    PaginationFilterChipRemoved event,
    Emitter<PaginationState> emit,
  ) async {
    _currentFilters = Map<String, dynamic>.from(_currentFilters);
    _currentFilters.remove(event.filterKey);
    _currentPage = 1;
    await _loadData(emit, isRefresh: true);
  }

  Future<void> _onFiltersCleared(
    PaginationFiltersCleared event,
    Emitter<PaginationState> emit,
  ) async {
    _currentFilters = {};
    _currentPage = 1;
    await _loadData(emit, isRefresh: true);
  }

  Future<void> _onSubCategoryTapped(
    PaginationSubCategoryTapped event,
    Emitter<PaginationState> emit,
  ) async {
    _subCategoryId = event.subCategoryId;
    _paginationTitle = event.subCategoryTitle;
    _isSubCategory = true;
    _isProduct = true;
    _searchChips = _parsePaginationTitleToChips(event.subCategoryTitle);
    _currentPage = 1;
    await _loadData(emit, isRefresh: true);
  }

  void _onProductTapped(
    PaginationProductTapped event,
    Emitter<PaginationState> emit,
  ) {}

  void _onStoreTapped(
    PaginationStoreTapped event,
    Emitter<PaginationState> emit,
  ) {}

  List<String> _parsePaginationTitleToChips(String title) {
    return title
        .split('/')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  Map<String, dynamic>? _buildSearchQueryFromChips() {
    if (_searchChips.isEmpty) return null;

    final searchMap = <String, String>{};
    for (int i = 0; i < _searchChips.length; i++) {
      searchMap['chip${i + 1}'] = _searchChips[i];
    }
    return searchMap;
  }

  Future<void> _loadData(
    Emitter<PaginationState> emit, {
    bool isRefresh = false,
    bool isLoadMore = false,
  }) async {
    if (isRefresh) {
      emit(const PaginationLoading());
    } else if (isLoadMore && state is PaginationLoaded) {
      final currentState = state as PaginationLoaded;
      emit(currentState.copyWith(isLoadingMore: true));
    }

    try {
      final List<ProductCardModel> products;
      final List<StoreCardModel> stores;
      List<CategoryItemModel> subcategories = [];

      final searchQuery = _buildSearchQueryFromChips();
      bool newBatchHasMoreData = false;

      if (filtersModel == null && !isLoadMore) {
        try {
          filtersModel = await _paginationRepository.fetchFilters();
        } catch (e) {
          filtersModel = null;
        }
      }

      if (!isLoadMore && !_isSubCategory && _subCategoryId != null) {
        subcategories = await _paginationRepository.fetchSubCategories(
          _subCategoryId!,
        );
      } else if (state is PaginationLoaded && !isRefresh) {
        subcategories = (state as PaginationLoaded).subcategories;
      }

      final filtersWithModel = Map<String, dynamic>.from(_currentFilters);
      filtersWithModel['filtersModel'] = filtersModel;

      if (_isProduct || _isSubCategory) {
        final newProducts = await _paginationRepository.fetchProducts(
          businessType: _businessType,
          searchQuery: searchQuery,
          filters: filtersWithModel,
          subCategoryId: _subCategoryId,
          page: _currentPage,
          limit: _limit,
        );

        newBatchHasMoreData = newProducts.length >= _limit;

        if (isLoadMore && state is PaginationLoaded) {
          final currentState = state as PaginationLoaded;
          products = [...currentState.products, ...newProducts];
        } else {
          products = newProducts;
        }
        stores = [];
      } else if (_isStore) {
        final newStores = await _paginationRepository.fetchStores(
          businessType: _businessType,
          searchQuery: searchQuery,
          filters: filtersWithModel,
          subCategoryId: _subCategoryId,
          page: _currentPage,
          limit: _limit,
        );

        newBatchHasMoreData = newStores.length >= _limit;

        if (isLoadMore && state is PaginationLoaded) {
          final currentState = state as PaginationLoaded;
          stores = [...currentState.stores, ...newStores];
        } else {
          stores = newStores;
        }
        products = [];
      } else {
        final newProducts = await _paginationRepository.fetchProducts(
          businessType: _businessType,
          searchQuery: searchQuery,
          filters: filtersWithModel,
          subCategoryId: _subCategoryId,
          page: _currentPage,
          limit: _limit,
        );

        newBatchHasMoreData = newProducts.length >= _limit;

        if (isLoadMore && state is PaginationLoaded) {
          final currentState = state as PaginationLoaded;
          products = [...currentState.products, ...newProducts];
        } else {
          products = newProducts;
        }
        stores = [];
      }

      emit(
        PaginationLoaded(
          products: products,
          stores: stores,
          subcategories: subcategories,
          isProduct: _isProduct,
          isStore: _isStore,
          isSubCategory: _isSubCategory,
          hasSubCategories: _hasSubCategories,
          subCategoryId: _subCategoryId,
          paginationTitle: _paginationTitle,
          activeFilters: _currentFilters,
          filtersModel: filtersModel,
          searchQuery:
              searchQuery is String ? searchQuery : _searchChips.join(' '),
          searchChips: List<String>.from(_searchChips),
          hasMoreData: newBatchHasMoreData,
          currentPage: _currentPage,
          isLoadingMore: false,
        ),
      );
    } on PaginationRepositoryException catch (e) {
      emit(PaginationError(e.message));
    } catch (e) {
      emit(PaginationError('Unexpected error: $e'));
    }
  }
}
