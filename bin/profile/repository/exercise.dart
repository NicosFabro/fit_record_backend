import 'dart:convert';

import 'dart:io';

class ExerciseRepository {
  Map<String, dynamic> getAllExercises() {
    try {
      final file = File('bin/static/exercises_data.json');
      final Map<String, dynamic> result = jsonDecode(file.readAsStringSync());
      return result;
    } on Exception catch (e) {
      if (e is FormatException) {
        throw FormatException('Error fetching data from database');
      } else {
        rethrow;
      }
    }
  }
}
