import 'package:shelf_plus/shelf_plus.dart';

import '../profile.dart';

class ProfileRoute {
  Router get router {
    final router = Router();

    // router.get('/', _getAllProfiles);
    // router.get('/<id>', _getProfileById);
    // router.post('/', _postProfile);
    // router.post('/<id>', _updateProfile);
    // router.delete('/<id>', _deleteProfile);

    router.all(
      '/<ignored|.*>',
      (Request request) => Response.notFound('Error Not Found'),
    );
    return router;
  }

  // Future<List<Profile>> _getAllProfiles() async {}
}
