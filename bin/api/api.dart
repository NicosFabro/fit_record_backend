import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../exercise/exercise.dart';
import '../profile/profile.dart';

class Api {
  Handler get handler {
    final router = Router();

    router.mount('/exercises', ExerciseRoute().router);

    router.all('/<ignored|.*>', (Request request) {
      return Response.notFound('Page not found');
    });

    return router;
  }
}
