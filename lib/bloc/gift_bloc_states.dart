import 'package:equatable/equatable.dart';

abstract class GiftState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GiftInitial extends GiftState {}

class GiftsLoading extends GiftState {}

class GiftsLoaded extends GiftState {
  final List<dynamic> gifts;

  GiftsLoaded({required this.gifts});

  @override
  List<Object?> get props => [gifts];
}
