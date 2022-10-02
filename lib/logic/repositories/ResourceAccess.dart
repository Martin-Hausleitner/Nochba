import 'package:get/get.dart';
import 'package:nochba/logic/interfaces/IModel.dart';
import 'package:nochba/logic/resources/Resource.dart';
import 'package:nochba/logic/resources/ResourceContext.dart';

class ResourceAccess extends GetxService {
  ResourceAccess(this.resourceContext);

  ResourceContext resourceContext;

  Resource<R> loadResource<R extends IModel>() {
    return resourceContext.getResource<R>();
  }
}
