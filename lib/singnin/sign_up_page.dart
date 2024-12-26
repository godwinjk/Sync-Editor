import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synceditor/singnin/sing_in_page.dart';

import '../common_bloc/bloc_wrapper.dart';
import '../home/home_page.dart';
import '../validation/validator.dart';
import 'bloc/sign_in_cubit.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<SignInCubit, SignInCubitState>(builder: (_, state) {
      if (state is SignInProgress) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return Form(
          key: _formKey,
          child: Center(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: validateEmail,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: validatePassword,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<SignInCubit>().singUp(
                            email: _emailController.text,
                            password: _passwordController.text);
                      }
                    },
                    child: const Text('Sign Up'),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      text: 'Already a user? ',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign in',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = _onSignupTap,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
        );
      }
    }, listener: (_, state) {
      if (state is SignInFinished) {
        Navigator.of(context).pushReplacement((MaterialPageRoute(
            builder: (_) => const BlocWrapper(child: HomePage()))));
      } else if (state is SignInFailed) {
        _showMessage(state.message);
      }
    }));
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      showCloseIcon: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(
        bottom: MediaQuery.sizeOf(context).height * 0.1, // Toast-like position
        left: 16,
        right: 16,
      ),
      duration: const Duration(seconds: 5),
    ));
  }

  void _onSignupTap() {
    // Handle the signup click
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const BlocWrapper(child: SignInPage())));
  }
}
