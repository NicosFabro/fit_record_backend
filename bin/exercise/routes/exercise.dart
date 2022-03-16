import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:shelf_plus/shelf_plus.dart';
import 'package:uuid/uuid.dart';

import '../../profile/repository/exercise.dart';
import '../exercise.dart';

class ExerciseRoute {
  final ExerciseRepository _repository = ExerciseRepository();

  Router get router {
    final router = Router();

    router.get('/', _getAllExercises);
    router.get('/<id>', _getExerciseById);
    router.post('/', _postExercise);
    router.post('/<id>', _updateExercise);
    router.delete('/<id>', _deleteExercise);

    router.all(
      '/<ignored|.*>',
      (Request request) => Response.notFound('Error Not Found'),
    );
    return router;
  }

  Future<Response> _getAllExercises(Request request) async {
    try {
      var result = _repository.getAllExercises();
      if (result['exercises'] == null) {
        return Response.internalServerError();
      }

      final List<Exercise> exercises = List.from(result['exercises']).map((e) {
        try {
          return Exercise.fromJson(e);
        } catch (e) {
          return Exercise.empty;
        }
      }).toList()
        ..removeWhere((exercise) => exercise.isEmpty);

      return Response.ok(
        jsonEncode({
          'exercises': exercises.map((e) => e.toJson()).toList(),
        }),
        headers: {'content-type': 'application/json'},
      );
    } on FormatException catch (e) {
      log(e.message);
      return Response.internalServerError();
    } on Exception catch (e) {
      log('${e.runtimeType}: ${e.toString()}');
      return Response.internalServerError();
    }
  }

  Future<Response> _getExerciseById(Request request) async {
    if (!request.params.containsKey('id')) {
      return Response(400);
    }

    final file = File('bin/static/exercises_data.json');
    final Map<String, dynamic> result = jsonDecode(file.readAsStringSync());

    if (result['exercises'] == null) {
      return Response.internalServerError();
    }

    final List<Exercise> exercises = List.from(result['exercises'])
        .map((e) => Exercise.fromJson(e))
        .toList();

    String requestedId = request.params['id']!;
    var exercise = exercises.firstWhere(
      (e) => e.id == requestedId,
      orElse: () => Exercise.empty,
    );

    if (exercise.isEmpty) {
      return Response.notFound('Exercise not found');
    }

    return Response.ok(
      jsonEncode(exercise.toJson()),
      headers: {'content-type': 'application/json'},
    );
  }

  Future<Response> _postExercise(Request request) async {
    var uuid = Uuid();
    try {
      final file = File('bin/static/exercises_data.json');
      final Map<String, dynamic> result = jsonDecode(file.readAsStringSync());

      if (result['exercises'] == null) {
        return Response.internalServerError();
      }

      final List<Exercise> exercises = List.from(result['exercises'])
          .map((e) => Exercise.fromJson(e))
          .toList();

      var exerciseReceived = await request.body.as(Exercise.fromJsonWithoutId);

      final currentDate = DateTime.now();

      var exercise = Exercise(
        id: uuid.v4(),
        name: exerciseReceived.name,
        description: exerciseReceived.description,
        image: exerciseReceived.image,
        dateCreated: currentDate,
        dateUpdated: currentDate,
      );

      if (exercises.any(
        (e) => e.id == exercise.id || e.name == exercise.name,
      )) {
        return Response.forbidden('Exercise already exists');
      }
      exercises.add(exercise);
      file.writeAsStringSync(jsonEncode({'exercises': exercises}));
      return Response.ok(
        jsonEncode(exercise.toJson()),
        headers: {'content-type': 'application/json'},
      );
    } on FormatException catch (e) {
      log(e.toString());
      return Response.forbidden('Bad request: ${e.message}');
    } catch (e) {
      log(e.toString());
      return Response.internalServerError();
    }
  }

  Future<Response> _updateExercise(Request request) async {
    if (!request.params.containsKey('id')) {
      return Response(400);
    }

    try {
      final file = File('bin/static/exercises_data.json');
      final Map<String, dynamic> result = jsonDecode(file.readAsStringSync());

      if (result['exercises'] == null) {
        return Response.internalServerError();
      }

      final List<Exercise> exercises = List.from(result['exercises'])
          .map((e) => Exercise.fromJson(e))
          .toList();

      final requestedId = request.params['id'];

      if (exercises.any((e) => e.id == requestedId)) {
        final newExercise = await request.body.as(Exercise.fromJsonWithoutId);
        var oldExercise = exercises.singleWhere((e) => e.id == requestedId);
        var exercise = oldExercise.copyWith(
          name: newExercise.name,
          description: newExercise.description,
          image: newExercise.image,
          dateUpdated: DateTime.now(),
        );

        exercises[exercises.indexWhere((e) => e.id == requestedId)] = exercise;
        file.writeAsStringSync(jsonEncode({'exercises': exercises}));

        return Response.ok(
          jsonEncode(exercise.toJson()),
          headers: {'content-type': 'application/json'},
        );
      } else {
        return Response.forbidden('Exercise not found');
      }
    } on FormatException catch (e) {
      return Response.forbidden('Bad request: ${e.message}');
    } catch (e) {
      return Response.internalServerError();
    }
  }

  Future<Response> _deleteExercise(Request request) async {
    if (!request.params.containsKey('id')) {
      return Response(400);
    }

    try {
      final file = File('bin/static/exercises_data.json');
      final Map<String, dynamic> result = jsonDecode(file.readAsStringSync());

      if (result['exercises'] == null) {
        return Response.internalServerError();
      }

      final List<Exercise> exercises = List.from(result['exercises'])
          .map((e) => Exercise.fromJson(e))
          .toList();
      String requestedId = request.params['id']!;
      exercises.removeWhere((exercise) => exercise.id == requestedId);
      file.writeAsStringSync(jsonEncode({'exercises': exercises}));
      return Response.ok('Exercise deleted');
    } catch (e) {
      return Response.internalServerError();
    }
  }
}
