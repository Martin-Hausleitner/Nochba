import 'package:nochba/logic/models/bookmark.dart';
import 'package:nochba/logic/repositories/GenericRepository.dart';

class BookMarkRepository extends GenericRepository<BookMark> {
  BookMarkRepository(super.resourceContext);

  Stream<BookMark?> getBookMarkOfCurrentUser() {
    return resource
        .getAsStream(resourceContext.uid, nexus: [resourceContext.uid]);
  }
}
