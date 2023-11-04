import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jct/screens/user/usefull/important_screen.dart';

import 'package:jct/screens/user/login/signup_screen.dart';
import 'forgot_password.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String errorMessage = '';
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool isPasswordType = true;
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      body: Padding(
        padding: EdgeInsets.only(
            left: screen.width * 0.075, right: screen.width * 0.075),
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sign In',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: screen.height * 0.05),
              TextFormField(
                validator: validateEmail,
                controller: email,
                decoration: const InputDecoration(
                  hintText: 'Enter Your E-Mail',
                  hintStyle: TextStyle(color: Colors.white),
                  labelText: 'E-Mail',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  errorStyle: TextStyle(fontSize: 18.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(
                      Radius.circular(9.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screen.height * 0.025),
              TextFormField(
                validator: validatePassword,
                controller: password,
                obscureText: isPasswordType,
                decoration: InputDecoration(
                  suffixIcon: togglePassword(true),
                  hintText: 'Enter Your Password',
                  hintStyle: const TextStyle(color: Colors.white),
                  labelText: 'Password',
                  labelStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  errorStyle: const TextStyle(fontSize: 18.0),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(
                      Radius.circular(9.0),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Forgot Password",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Text(
                errorMessage,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      try {
                        await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: email.text, password: password.text)
                            .then(
                          (value) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ImportantScreen(),
                              ),
                            );
                          },
                        );
                        errorMessage = '';
                      } on FirebaseAuthException catch (error) {
                        errorMessage = error.message!;
                        if (errorMessage ==
                            'An internal error has occurred. [ INVALID_LOGIN_CREDENTIALS ]') {
                          errorMessage = 'Invalid E-Mail or Password';
                        }
                      }
                      setState(() {});
                    }
                  },
                  child: const Text(
                    "Sign In",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
                child: const Text(
                  "New User",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget togglePassword(bool isPassword) {
    return IconButton(
        color: Colors.white,
        onPressed: () {
          setState(() {
            isPasswordType = !isPasswordType;
          });
        },
        icon: isPasswordType
            ? const Icon(Icons.visibility)
            : const Icon(Icons.visibility_off));
  }

  String? validateEmail(String? formEmail) {
    if (formEmail == null || formEmail.isEmpty) {
      return 'E- Mail Address is required';
    }
    String pattern = r'\w+@\w+\.\w+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(formEmail)) {
      return 'Invalid E-Mail Address Format';
    }
    return null;
  }

  String? validatePassword(String? formPassword) {
    if (formPassword == null || formPassword.isEmpty) {
      return 'Password is required';
    }
    return null;
  }
}
