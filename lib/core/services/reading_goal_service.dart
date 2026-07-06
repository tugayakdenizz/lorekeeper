import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ReadingGoalService {
  static const String _boxName = 'reading_goal_box';
  static const String _goalKey = 'yearly_goal';

  static final ValueNotifier<int> goalNotifier = ValueNotifier<int>(30);

  Future<void> init() async {
    await Hive.openBox<int>(_boxName);
    goalNotifier.value = getGoal();
  }

  Box<int> get _box => Hive.box<int>(_boxName);

  int getGoal() {
    return _box.get(_goalKey, defaultValue: 30) ?? 30;
  }

  Future<void> updateGoal(int goal) async {
    await _box.put(_goalKey, goal);
    goalNotifier.value = goal;
  }
}