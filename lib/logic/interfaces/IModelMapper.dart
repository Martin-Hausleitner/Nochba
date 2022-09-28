import 'package:locoo/logic/interfaces/IModel.dart';

abstract class IModelMapper {
  Map<String, dynamic> getJsonFromModel<T extends IModel>(T model);
  T getModelFromJson<T extends IModel>(Map<String, dynamic> json);
}