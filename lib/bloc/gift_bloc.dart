import 'package:bloc/bloc.dart';
import 'package:hedeyati/models/gift.dart';
import 'gift_bloc_events.dart';
import 'gift_bloc_states.dart';

class GiftBloc extends Bloc<GiftEvent, GiftState> {
  final List<Gift> _gifts = []; // Temporary in-memory storage.

  GiftBloc() : super(GiftInitialState()) {
    on<LoadGiftsEvent>(_onLoadGifts);
    on<AddGiftEvent>(_onAddGift);
    on<EditGiftEvent>(_onEditGift);
    on<DeleteGiftEvent>(_onDeleteGift);
    on<PledgeGiftEvent>(_onPledgeGift);
  }

  void _onLoadGifts(LoadGiftsEvent event, Emitter<GiftState> emit) {
    emit(GiftLoadingState());
    // Simulate data fetching or load from database
    emit(GiftLoadedState(List.from(_gifts)));
  }

  void _onAddGift(AddGiftEvent event, Emitter<GiftState> emit) {
    _gifts.add(event.newGift);
    emit(GiftLoadedState(List.from(_gifts)));
  }

  void _onEditGift(EditGiftEvent event, Emitter<GiftState> emit) {
    final index = _gifts.indexWhere((gift) => gift.id == event.giftId);
    if (index != -1) {
      _gifts[index] = event.updatedGift;
      emit(GiftLoadedState(List.from(_gifts)));
    }
  }

  void _onDeleteGift(DeleteGiftEvent event, Emitter<GiftState> emit) {
    _gifts.removeWhere((gift) => gift.id == event.giftId);
    emit(GiftLoadedState(List.from(_gifts)));
  }

  void _onPledgeGift(PledgeGiftEvent event, Emitter<GiftState> emit) {
    final index = _gifts.indexWhere((gift) => gift.id == event.giftId);
    if (index != -1) {
      _gifts[index] = _gifts[index].copyWith(isPledged: true);
      emit(GiftLoadedState(List.from(_gifts)));
    }
  }
}