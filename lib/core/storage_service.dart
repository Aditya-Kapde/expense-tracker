import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const String _boxName = 'finance_box';

  /// Initialize Hive and open the app box (safe to call multiple times)
  static Future<void> init() async {
    try {
      await Hive.initFlutter();
    } catch (_) {
      // Hive.initFlutter may be a no-op if already initialized; ignore errors here
    }

    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
  }

  static Box<dynamic> _box() {
    if (!Hive.isBoxOpen(_boxName)) {
      throw StateError('Hive box "$_boxName" is not open. Call StorageService.init() first.');
    }
    return Hive.box(_boxName);
  }

  // Helpers
  static Map<String, dynamic> _normalizeMap(dynamic item) {
    final Map<String, dynamic> result = {};
    if (item is Map) {
      item.forEach((k, v) {
        final key = k?.toString() ?? '';
        // Normalize Date strings back to DateTime if necessary
        if (v is String) {
          // Try to parse ISO8601 dates
          final parsed = DateTime.tryParse(v);
          if (parsed != null) {
            result[key] = parsed;
            return;
          }
        }
        result[key] = v;
      });
    }
    return result;
  }

  // Incomes
  static List<Map<String, dynamic>> getIncomes() {
    final raw = _box().get('incomes');
    if (raw is List) {
      try {
        return raw.map<Map<String, dynamic>>((e) => _normalizeMap(e)).toList();
      } catch (_) {
        return [];
      }
    }
    return [];
  }

  static Future<void> saveIncomes(List<Map<String, dynamic>> incomes) async {
    await _box().put('incomes', incomes);
  }

  static Future<void> addIncome(Map<String, dynamic> income) async {
    final list = getIncomes();
    list.insert(0, income);
    await saveIncomes(list);
  }

  // Expenses
  static List<Map<String, dynamic>> getExpenses() {
    final raw = _box().get('expenses');
    if (raw is List) {
      try {
        return raw.map<Map<String, dynamic>>((e) => _normalizeMap(e)).toList();
      } catch (_) {
        return [];
      }
    }
    return [];
  }

  static Future<void> saveExpenses(List<Map<String, dynamic>> expenses) async {
    await _box().put('expenses', expenses);
  }

  static Future<void> addExpense(Map<String, dynamic> expense) async {
    final list = getExpenses();
    list.insert(0, expense);
    await saveExpenses(list);
  }

  // Utility
  static Future<void> clearAll() async {
    await _box().clear();
  }
}
