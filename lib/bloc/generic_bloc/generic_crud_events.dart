import 'package:equatable/equatable.dart';
import 'package:hedeyati/models/event.dart';
import '../../helpers/query_arguments.dart';
import '../../models/model.dart';


abstract class GenericCRUDEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadModel extends GenericCRUDEvents {
  final List<Map<String, QueryArg>> where;

  LoadModel(this.where);

  @override
  List<Object?> get props => [where];
}

class AddModel extends GenericCRUDEvents {
  final Model model;

  AddModel(this.model);

  @override
  List<Object?> get props => [model];
}

class UpdateModel extends GenericCRUDEvents {
  final Model updatedModel;

  UpdateModel(this.updatedModel);

  @override
  List<Object?> get props => [updatedModel];
}

class DeleteModel extends GenericCRUDEvents {
  final Event deletedModel;

  DeleteModel(this.deletedModel);

  @override
  List<Object?> get props => [deletedModel];
}
