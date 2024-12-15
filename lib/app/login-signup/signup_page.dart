import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_states.dart';
import 'package:hedeyati/bloc/signUp/signup_bloc.dart';
import '../../bloc/generic_bloc/generic_crud_events.dart';
import '../../bloc/signUp/signup_events.dart';
import '../../bloc/signUp/signup_states.dart';
import '../../models/user.dart';
import '../home/tab_bar.dart';
import 'login_page.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupBloc, ModelStates>(
      listener: (context, state) {
        if (state is UserCredentialsValidated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is ModelSuccessState) {
          const SnackBar(
            content: Text("Account created successfully , You can login now"),
            backgroundColor: Colors.pinkAccent,
          );
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyTabBar()),
            );
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else if (state is ModelErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _header(context),
                      _inputFields(context),
                      const SizedBox(height: 20),
                      _signupButton(context),
                      _loginPrompt(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _header(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 60.0),
        Text(
          "Sign up",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: 'GreatVibes'),
        ),
        SizedBox(height: 10),
        Text("Create your account", style: TextStyle(fontStyle: FontStyle.italic)),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _inputFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          keyboardType: TextInputType.name,
          controller: usernameController,
          decoration: InputDecoration(
            hintText: "Username",
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
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: "Email Address",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.pink[100],
            filled: true,
            prefixIcon: const Icon(Icons.email),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          keyboardType: TextInputType.phone,
          controller: phoneNumberController,
          decoration: InputDecoration(
            hintText: "Phone Number",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.pink[100],
            filled: true,
            prefixIcon: const Icon(Icons.phone),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          keyboardType: TextInputType.visiblePassword,
          controller: passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.pink[100],
            filled: true,
            prefixIcon: const Icon(Icons.lock),
          ),
          obscureText: true,
        ),
      ],
    );
  }

  Widget _signupButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        User user = User(
          username: usernameController.text,
          email: emailController.text,
          phoneNumber: phoneNumberController.text,
          password: passwordController.text,
        );
        SignupBloc.get(context).add(CreateUserAccount(user:user));
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: Text(
        "Sign up",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _loginPrompt(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?"),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          child: Text("Login", style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
