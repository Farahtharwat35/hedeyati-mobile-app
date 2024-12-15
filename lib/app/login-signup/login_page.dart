import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/app/login-signup/signup_page.dart';
import 'package:hedeyati/authentication/signin_by_email_and_password.dart';
import '../../bloc/signUp/signup_bloc.dart';
import '../home/tab_bar.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center everything vertically
        children: [
          _header(context),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15), // Reduced padding for form
                child: Column(
                  children: [
                    _inputField(context),
                    const SizedBox(height: 10),
                    _forgotPassword(context),
                    _signup(context),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).elevatedButtonTheme.style?.backgroundColor?.resolve({}) ?? Colors.pink,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: InkWell(
                        child: Text(
                          "Login",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        onTap: () async {
                          final response = await SignInByEmailAndPassword.login(_emailController.text, _passwordController.text);
                          if (response.success) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const MyTabBar()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(response.message),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _header(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 170, left: 20, right: 20), // Padding from the top added here
      child: Column(
        children: [
          // Animated "Hedeyati" with letter-by-letter animation and a gift icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1000), // Faster reveal
                builder: (context, value, child) {
                  String text = "Hedeyati";
                  int length = (value * text.length).toInt();
                  return Text(
                    text.substring(0, length),
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'GreatVibes',
                      color: Colors.pinkAccent,
                    ),
                  );
                },
              ),
              const SizedBox(width: 10), // Space between icon and text
              Icon(Icons.card_giftcard, color: Colors.pinkAccent, size: 40), // Gift icon
            ],
          ),
          const SizedBox(height: 15), // Reduced space between the "Hedeyati" and "Welcome Back"
          Padding(
            padding: const EdgeInsets.all(20),
            child: const Text(
              "Welcome Back!",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: 'GreatVibes'),
            ),
          ),
          const Text("Enter your credentials to login", style: TextStyle(fontStyle: FontStyle.italic)),
          const SizedBox(height: 30), // Add extra padding to separate from form
        ],
      ),
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: "Email Address",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.pink[100],
            filled: true,
            prefixIcon: const Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.pink[100],
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
        ),
      ],
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {},
      child: Text("Forgot password?", style: Theme.of(context).textTheme.bodyMedium?.apply(fontStyle: FontStyle.italic)),
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BlocProvider(
                create: (context) => SignupBloc(),
                child: SignupPage(),
              )),
            );
          },
          child: Text("Sign Up", style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
