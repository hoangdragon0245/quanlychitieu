import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';
import '../repositories/category_repository.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});

final expenseCategoriesProvider =
    FutureProvider<List<CategoryModel>>((ref) async {
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.getCategoriesByType('expense');
});

final incomeCategoriesProvider =
    FutureProvider<List<CategoryModel>>((ref) async {
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.getCategoriesByType('income');
});

final allCategoriesProvider =
    FutureProvider<List<CategoryModel>>((ref) async {
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.getAllCategories();
});
