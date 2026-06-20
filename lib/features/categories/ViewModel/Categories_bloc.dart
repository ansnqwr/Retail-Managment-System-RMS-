import 'package:flutter_bloc/flutter_bloc.dart';
import 'Categories_event.dart';
import 'Categories_repository.dart';
import 'Categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final CategoryRepository _categoryRepository;

  CategoriesBloc({required CategoryRepository categoryRepository})
    : _categoryRepository = categoryRepository,
      super(const CategoriesInitialState()) {
    on<CategoriesLoadEvent>(_onLoadRequested);
    on<CategoriesRefreshRequested>(_onRefreshRequested);
    on<CategoriesCategoryTapped>(_onCategoryTapped);
    on<CategoriesSubcategoryTapped>(_onSubcategoryTapped);
  }

  Future<void> _onLoadRequested(
    CategoriesLoadEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(const CategoriesLoadingState());

    try {
      final data = await _categoryRepository.fetchCategories();
      emit(CategoriesLoadedState(categoriesList: data));
    } on CategoriesRepositoryException catch (e) {
      emit(CategoriesErrorState(e.message));
    } catch (e) {
      emit(CategoriesErrorState('Unexpected error: $e'));
    }
  }

  Future<void> _onRefreshRequested(
    CategoriesRefreshRequested event,
    Emitter<CategoriesState> emit,
  ) async {
    add(const CategoriesLoadEvent());
  }

  void _onCategoryTapped(
    CategoriesCategoryTapped event,
    Emitter<CategoriesState> emit,
  ) {
    if (state is! CategoriesLoadedState) return;

    final current = state as CategoriesLoadedState;

    final newExpandedId =
        (current.expandedCategoryId == event.categoryId)
            ? null
            : event.categoryId;

    emit(current.copyWith(expandedCategoryId: newExpandedId));
  }

  void _onSubcategoryTapped(
    CategoriesSubcategoryTapped event,
    Emitter<CategoriesState> emit,
  ) {}
}
