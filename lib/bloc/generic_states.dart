import '../models/model.dart';

abstract class ModelStates {
  List<Model> models;
  ModelStates({required this.models});
}
class ModelInitState extends ModelStates {
  ModelInitState() : super(models: []);
}
class ModelChangeState extends ModelStates {
  ModelChangeState(List<Model> models) : super(models: models);
}
class ModelLoadingState extends ModelStates {
  ModelLoadingState() : super(models: []);
}
class ModelAddedState extends ModelStates {
  Model addedModel;
  ModelAddedState(this.addedModel) : super(models: []);
}
class ModelErrorState extends ModelStates {
  ModelErrorState() : super(models: []);
}
class ModelUpdatedState extends ModelStates {
  Model updatedModel;
  ModelUpdatedState(this.updatedModel) : super(models: []);
}
class ModelDeletedState extends ModelStates {
  Model deletedModel;
  ModelDeletedState(this.deletedModel) : super(models:[]);
}
