import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/app/home/home_page.dart';
import 'package:hedeyati/app/login-signup/login_page.dart';
import 'package:hedeyati/app/reusable_components/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hedeyati/bloc/gift_category/gift_category_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'app/home/tab_bar.dart';
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
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'Hedeyati',
        theme: myTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
          '/home': (context) => HomePage(),
        },
      ),
    );
  }
}
