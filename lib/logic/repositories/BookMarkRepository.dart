import 'package:nochba/logic/models/bookmark.dart';
import 'package:nochba/logic/repositories/GenericRepository.dart';

class BookMarkRepository extends GenericRepository<BookMark> {
  BookMarkRepository(super.resourceContext);

  @override
  String get reference => 'record';

  Stream<BookMark?> getBookMarkOfCurrentUser() {
    return resource.getAsStream(reference, nexus: [resourceContext.uid]);
  }

  Future updateBookMarkOfCurrentUser(BookMark bookMark) {
    return update(bookMark, nexus: [resourceContext.uid]);
  }
}
