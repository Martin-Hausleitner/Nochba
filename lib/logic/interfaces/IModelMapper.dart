import 'package:nochba/logic/interfaces/IModel.dart';

abstract class IModelMapper {
  Map<String, dynamic> getJsonFromModel<T extends IModel>(T model);
  T getModelFromJson<T extends IModel>(String id, Map<String, dynamic> json);
}
