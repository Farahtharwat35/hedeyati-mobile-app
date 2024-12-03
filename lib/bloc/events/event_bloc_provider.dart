

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event_bloc.dart';

class EventBlocProvider extends StatelessWidget {
  final Widget child;
  final Bloc counterBloc;
  const EventBlocProvider({super.key, required this.child, required this.counterBloc});
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: counterBloc,
      child: child,
    );
  }
  static EventBloc of(BuildContext context) {
    return BlocProvider.of<EventBloc>(context);
  }
}