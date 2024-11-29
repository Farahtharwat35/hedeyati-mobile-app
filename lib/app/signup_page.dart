import 'package:flutter/material.dart';
import 'package:hedeyati/app/home_page.dart';
import 'package:hedeyati/authentication/signup_by_email_and_password.dart';
import '../tab_bar.dart';
import 'login_page.dart';


class SignupPage extends StatelessWidget {
  SignupPage({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Center( // Center the container vertically
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center content within the container
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
  }

  Widget _header(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 60.0),
        Text(
          "Sign up",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold , fontFamily: 'GreatVibes'),
        ),
        SizedBox(height: 10),
        Text("Create your account" , style: TextStyle(fontStyle: FontStyle.italic)),
        SizedBox(height:10)
      ],
    );
  }

  Widget _inputFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
            keyboardType: TextInputType.text,
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
            hintText: "EmailAddress",
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
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: "Phone number",
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
      onPressed: () async {
        final response = await SignUpByEmailAndPassword.signUp(emailController.text,passwordController.text);
        if (response.success) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyTabBar()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Theme.of(context).elevatedButtonTheme.style?.backgroundColor?.resolve({}) ?? Colors.pink,
      ),
      child: Text(
        "Sign up",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

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
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
        child: Text("Login", style: Theme.of(context).textTheme.bodyMedium),
      ),
    ],
  );
}