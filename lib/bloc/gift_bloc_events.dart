import 'package:hedeyati/models/gift.dart';

abstract class GiftEvent {}

class LoadGiftsEvent extends GiftEvent {}

class AddGiftEvent extends GiftEvent {
  final Gift newGift;

  AddGiftEvent(this.newGift);
}

class EditGiftEvent extends GiftEvent {
  final String giftId;
  final Gift updatedGift;

  EditGiftEvent(this.giftId, this.updatedGift);
}

class DeleteGiftEvent extends GiftEvent {
  final String giftId;

  DeleteGiftEvent(this.giftId);
}

class PledgeGiftEvent extends GiftEvent {
  final String giftId;

  PledgeGiftEvent(this.giftId);
}
