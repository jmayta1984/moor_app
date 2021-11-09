import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

part 'database.g.dart';

class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 6, max: 32)();
  TextColumn get content => text().named('body')();
  IntColumn get category => integer().nullable()();
}

@DataClassName("Category")
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get description => text()();
}

@DriftDatabase(tables: [Todos, Categories])
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Get all todos
  Future<List> fetchTodos() => select(todos).get();

  // Add todo
  Future<int> insertTodo(TodosCompanion todo) => into(todos).insert(todo);

  // Update todo
  Future updateTodo(Todo todo) => update(todos).replace(todo);

  // Delete todo
  Future deleteTodo(Todo todo) => delete(todos).delete(todo);

  // Get all categories
  Future<List> fetchCategories() => select(categories).get();

  // Add category
  Future<int> insertCategory(CategoriesCompanion category) =>
      into(categories).insert(category);

  // Update category
  Future updateCategory(Category category) =>
      update(categories).replace(category);

  // Delete category
  Future deleteCategory(Category category) =>
      delete(categories).delete(category);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'todos.db'));
    return NativeDatabase(file);
  });
}
