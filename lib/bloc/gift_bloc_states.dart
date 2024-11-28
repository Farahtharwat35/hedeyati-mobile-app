import 'package:hedeyati/models/gift.dart';

abstract class GiftState {}

class GiftInitialState extends GiftState {}

class GiftLoadingState extends GiftState {}

class GiftLoadedState extends GiftState {
  final List<Gift> gifts;

  GiftLoadedState(this.gifts);
}

class GiftErrorState extends GiftState {
  final String error;

  GiftErrorState(this.error);
}
