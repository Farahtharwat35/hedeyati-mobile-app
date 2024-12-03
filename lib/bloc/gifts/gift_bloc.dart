import 'package:bloc/bloc.dart';
import 'package:hedeyati/models/gift.dart';
import 'gift_bloc_events.dart';
import 'gift_bloc_states.dart';

class GiftBloc extends Bloc<GiftEvent, GiftState> {
  GiftBloc() : super(GiftInitial()) {
    on<LoadGiftsEvent>(_onLoadGifts);
    on<AddGiftEvent>(_onAddGift);
    on<UpdateGiftEvent>(_onEditGift);
    on<DeleteGiftEvent>(_onDeleteGift);
    on<PledgeGiftEvent>(_onPledgeGift);
  }

  Future<void> _onLoadGifts(LoadGiftsEvent event, Emitter<GiftState> emit) async {
    emit(GiftsLoading());
    try {
      final snapshot = await Gift.instance.get();
      final gifts = snapshot.docs.map((doc) => doc.data()).toList();
      emit(GiftsLoaded(gifts: gifts));
    } catch (e) {
      emit(GiftsError(message: 'Failed to load gifts: ${e.toString()}'));
    }
  }

  Future<void> _onAddGift(AddGiftEvent event, Emitter<GiftState> emit) async {
    try {
      await Gift.instance.add(event.gift);
      add(LoadGiftsEvent(0)); // Trigger reloading the gifts
    } catch (e) {
      emit(GiftsError(message: 'Failed to add gift: ${e.toString()}'));
    }
  }

  Future<void> _onEditGift(UpdateGiftEvent event, Emitter<GiftState> emit) async {
    try {
      await Gift.instance.update(event.updatedGift);
      add(LoadGiftsEvent(0)); // Trigger reloading the gifts
    } catch (e) {
      emit(GiftsError(message: 'Failed to update gift: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteGift(DeleteGiftEvent event, Emitter<GiftState> emit) async {
    try {
      await Gift.instance.delete(event.gift);
      add(LoadGiftsEvent(0)); // Trigger reloading the gifts
    } catch (e) {
      emit(GiftsError(message: 'Failed to delete gift: ${e.toString()}'));
    }
  }

  Future<void> _onPledgeGift(PledgeGiftEvent event, Emitter<GiftState> emit) async {
    try {
      final pledgedGift = event.gift.copyWith(isPledged: true);
      await Gift.instance.update(pledgedGift);
      add(LoadGiftsEvent(0)); // Trigger reloading the gifts
    } catch (e) {
      emit(GiftsError(message: 'Failed to pledge gift: ${e.toString()}'));
    }
  }
}
