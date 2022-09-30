import 'package:locoo/logic/models/bookmark.dart';
import 'package:locoo/logic/repositories/GenericRepository.dart';

class BookMarkRepository extends GenericRepository<BookMark> {
  BookMarkRepository(super.resourceContext);

  Stream<BookMark?> getBookMarkOfCurrentUser() {
    return resource.getAsStream(resourceContext.uid, nexus: [resourceContext.uid]);
  }
}