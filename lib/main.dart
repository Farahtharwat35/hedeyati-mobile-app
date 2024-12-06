import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/app/login_page.dart';
import 'package:hedeyati/app/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'bloc/bloc_observer.dart';
import 'firebase_options.dart';


Future<void> main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Hedeyati());
}

class Hedeyati extends StatelessWidget {
  const Hedeyati({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedeyati',
      theme: myTheme,
      home: LoginPage(),
    );
  }
}
