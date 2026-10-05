import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const boxName = 'demo_notes';
  late final Box box;

  Future<void> init() async {
    await Hive.initFlutter();
    box = await Hive.openBox(boxName);
  }

  List<Map<String, dynamic>> readAll() {
    return box.keys.map((key) {
      final raw = box.get(key);
      final value = raw is Map
          ? Map<String, dynamic>.from(raw)
          : <String, dynamic>{'title': '$raw'};
      return {'key': key, ...value};
    }).toList();
  }

  Future<void> create(String title) async {
    await box.add({
      'title': title,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> update(dynamic key, String title) async {
    await box.put(key, {
      'title': title,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> delete(dynamic key) => box.delete(key);

  Future<void> clear() => box.clear();
}
