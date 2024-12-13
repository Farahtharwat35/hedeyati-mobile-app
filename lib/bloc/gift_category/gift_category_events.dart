
import '../generic_bloc/generic_crud_events.dart';


abstract class GiftCategoryEvent extends GenericCRUDEvents {
  @override
  List<Object?> get props => [];
}

class LoadGiftCategoriesEventToLocalDatabase extends GiftCategoryEvent {}

