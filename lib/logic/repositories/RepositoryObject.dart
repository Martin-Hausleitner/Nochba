import 'package:nochba/logic/interfaces/IModel.dart';
import 'package:nochba/logic/repositories/ResourceAccess.dart';
import 'package:nochba/logic/resources/Resource.dart';

class RepositoryObject<T extends IModel> extends ResourceAccess {
  RepositoryObject(super.resourceContext);

  Resource<T>? _resource;

  Resource<T> get resource {
    _resource ??= resourceContext.getResource<T>();
    return _resource!;
  }
}
