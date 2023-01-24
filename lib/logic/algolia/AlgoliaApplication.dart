import 'package:algolia/algolia.dart';

class AlgoliaApplication {
  static const Algolia algolia = Algolia.init(
    applicationId: '', //ApplicationID
    apiKey: '', //search-only api key in flutter code
  );
}
