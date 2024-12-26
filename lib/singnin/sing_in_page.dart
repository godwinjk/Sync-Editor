import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synceditor/common_bloc/bloc_wrapper.dart';
import 'package:synceditor/home/home_page.dart';
import 'package:synceditor/singnin/bloc/sign_in_cubit.dart';
import 'package:synceditor/singnin/sign_up_page.dart';

import '../common/app_bar.dart';
import '../validation/validator.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    context.read<SignInCubit>().checkAuthentication();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
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
                          context.read<SignInCubit>().signIn(
                              email: _emailController.text,
                              password: _passwordController.text);
                        }
                      },
                      child: const Text('Sign In'),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Not a user? ',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: 'Signup',
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
      }),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 5),
      showCloseIcon: true,
    ));
  }

  void _onSignupTap() {
    // Handle the signup click

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const BlocWrapper(child: SignUpPage())));
  }
}
