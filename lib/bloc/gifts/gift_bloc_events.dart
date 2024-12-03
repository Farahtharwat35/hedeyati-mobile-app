import '../../models/gift.dart';
import 'package:hedeyati/bloc/generic_bloc_event.dart';

class GiftEvent extends BlocEvent {
  @override
  List<Object?> get props => [];
}

class AddGiftEvent extends GiftEvent  {
  final Gift gift;
  AddGiftEvent(this.gift);

  @override
  List<Object?> get props => [gift];
}

class UpdateGiftEvent extends GiftEvent {
  final Gift updatedGift;
  UpdateGiftEvent(this.updatedGift);

  @override
  List<Object?> get props => [updatedGift];
}

class PledgeGiftEvent extends GiftEvent {
  final Gift gift;
  PledgeGiftEvent(this.gift);

  @override
  List<Object?> get props => [gift];
}

class UnpledgeGiftEvent extends GiftEvent {
  final Gift gift;
  UnpledgeGiftEvent(this.gift);

  @override
  List<Object?> get props => [gift];
}

class DeleteGiftEvent extends GiftEvent {
  final Gift gift;
  DeleteGiftEvent(this.gift);

  @override
  List<Object?> get props => [gift];
}

class LoadGiftsEvent extends GiftEvent {
  final int id;
  LoadGiftsEvent(this.id);

  @override
  List<Object?> get props => [id];
}



