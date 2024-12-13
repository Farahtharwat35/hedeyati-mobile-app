import 'package:equatable/equatable.dart';
import '../../models/model.dart';


abstract class ModelStates extends Equatable {
  final List<Model>? models ;
  const  ModelStates({this.models});

  @override
  List<Object?> get props => [models];
}
class ModelInitState extends ModelStates {
  const ModelInitState() : super();
}

class ModelChangeState extends ModelStates {
  const ModelChangeState(List<Model> models) : super();
}

class ModelLoadingState extends ModelStates {
  const ModelLoadingState() : super();
}

class ModelLoadedState extends ModelStates {

  final List<Model> models;

  const ModelLoadedState(this.models) : super();

  @override
  List<Object?> get props => [models];
}

class ModelAddedState extends ModelStates {
  final Model addedModel;
  const ModelAddedState(this.addedModel) : super();

  @override
  List<Object?> get props => [addedModel];
}

class ModelUpdatedState extends ModelStates {
  final Model updatedModel;
  const ModelUpdatedState(this.updatedModel) : super();

  @override
  List<Object?> get props => [updatedModel];
}
class ModelDeletedState extends ModelStates {
  final Model deletedModel;
  const ModelDeletedState(this.deletedModel) : super();

  @override
  List<Object?> get props => [deletedModel];
}

class ModelSuccessState extends ModelStates {
  final String message;

  const ModelSuccessState({required this.message});

  @override
  List<Object?> get props => [message];
}

class ModelErrorState extends ModelStates {
  final String message;

  const ModelErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}