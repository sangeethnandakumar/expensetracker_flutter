import 'package:expences/bl/repos/records_repo.dart';

import '../../models/category_model.dart';
import '../abstractions.dart';
import '../local_storage.dart';

class CategoryRepository extends BaseRepository<CategoryModel> {
  final LocalStorage _localStorage = LocalStorage();
  final String _filename = 'categories.json';

  @override
  Future<void> create(CategoryModel category) async {
    final data = await _localStorage.readJson(_filename);
    data[category.id] = category; // Use category ID as the key
    await _localStorage.writeJson(_filename, data);
  }

  @override
  Future<CategoryModel?> getById(String id) async {
    final data = await _localStorage.readJson(_filename);
    return data.containsKey(id) ? CategoryModel.fromJson(data[id]) : null;
  }

  @override
  Future<List<CategoryModel>> getAll() async {
    final data = await _localStorage.readJson(_filename);
    return data.values.map((json) => CategoryModel.fromJson(json)).toList();
  }

  @override
  Future<void> update(CategoryModel category) async {
    final data = await _localStorage.readJson(_filename);
    if (data.containsKey(category.id)) {
      data[category.id] = category;
      await _localStorage.writeJson(_filename, data);
    }
  }

  @override
  Future<void> delete(String id) async {
    var recordsRepo = new RecordRepository();
    final data = await _localStorage.readJson(_filename);
    data.remove(id);
    recordsRepo.deleteByCategory(id);
    await _localStorage.writeJson(_filename, data);
  }
}