import 'dart:convert';
import 'dart:io';

class AppService {
  static AppService? _instance;
  factory AppService() {
    if (_instance == null) {
      throw Exception("Initialise the Singleton Object");
    }
    return _instance!;
  }
  AppService._privateConstructor();
  static void init() {
    _instance ??= AppService._privateConstructor();
  }

  Future<void> saveTodoToFile(String path, Map<String, bool> todos) async {
    final file = File(path);
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    file.writeAsString(jsonEncode(todos));
  }

  Future<Map<String, bool>> getTodoFromFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      final todos = await file.readAsString();
      if (todos.isNotEmpty) {
        return Map<String, bool>.from(jsonDecode(todos));
      }
    }
    return {};
  }
}
