import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/database/firestore/crud.dart';
import '../models/event_category.dart';
import '../models/model.dart';
import '../bloc/generic_states.dart';
import 'generic_crud_events.dart';

class ModelBloc<GenericModel extends Model> extends Bloc<GenericCRUDEvents, ModelStates> {
  late GenericModel model;
  late CRUD<GenericModel> _CRUD;

  ModelBloc({required this.model}) : super(ModelInitState()) {
    _CRUD = CRUD<GenericModel>(model: model);
    on<LoadModel>(getWhere);
    on<AddModel>(addModel);
    on<UpdateModel>(update);
    on<DeleteModel>(delete);
  }


  static ModelBloc of(context) => BlocProvider.of(context);

  Future<void> addModel(AddModel event, Emitter<ModelStates> emit) async {
    emit(ModelLoadingState());
    try {
      await _CRUD.add(event.model as GenericModel);
      emit(ModelAddedState(event.model));
    } catch (e) {
      emit(ModelErrorState());
    }
  }

  Future<List<Model>> getWhere(LoadModel event, Emitter<ModelStates> emit) async {
    emit(ModelLoadingState());
    try {
      List<Model> models = await _CRUD.getWhere(event.where);
      emit(ModelChangeState(models));
      return models;
    } catch (e) {
      emit(ModelErrorState());
      return [];
    }
  }

  Future<void> update(UpdateModel event, Emitter<ModelStates> emit) async {
    emit(ModelLoadingState());
    try {
      await _CRUD.update(event.updatedModel as GenericModel);
      emit(ModelUpdatedState(event.updatedModel));
    } catch (e) {
      emit(ModelErrorState());
    }
  }

  Future<void> delete(DeleteModel event, Emitter<ModelStates> emit) async {
    emit(ModelLoadingState());
    try {
      await _CRUD.delete(event.deletedModel as GenericModel);
      emit(ModelDeletedState(event.deletedModel));
    } catch (e) {
      emit(ModelErrorState());
    }
  }
}

class CategoryCubit extends ModelBloc<EventCategory> {
  CategoryCubit({required super.model});
  static CategoryCubit of(context) => BlocProvider.of(context);
}
