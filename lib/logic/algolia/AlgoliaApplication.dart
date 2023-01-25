import 'package:algolia/algolia.dart';

class AlgoliaApplication {
  static const Algolia algolia = Algolia.init(
    applicationId: 'G9631HLL6J', //ApplicationID
    apiKey: '616deb1329d11d072c56484c277047c2', //search-only api key in flutter code
  );
}
