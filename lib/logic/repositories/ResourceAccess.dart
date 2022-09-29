import 'package:get/get.dart';
import 'package:locoo/logic/interfaces/IModel.dart';
import 'package:locoo/logic/resources/Resource.dart';
import 'package:locoo/logic/resources/ResourceContext.dart';

class ResourceAccess extends GetxService {
  ResourceAccess(this.resourceContext);

  ResourceContext resourceContext;

  Resource<R> loadResource<R extends IModel>() {
    return resourceContext.getResource<R>();
  }
}