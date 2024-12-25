import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:synceditor/common_bloc/bloc_wrapper.dart';
import 'package:synceditor/home/home_page.dart';
import 'package:synceditor/singnin/bloc/sign_in_cubit.dart';

import '../common/app_bar.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
          return Center(
              child: ElevatedButton(
            onPressed: () {
              context.read<SignInCubit>().signIn();
            },
            child: const Text('Sign In'),
          ));
        }
      }, listener: (_, state) {
        if (state is SignInFinished) {
          Navigator.of(context).pushReplacement((MaterialPageRoute(
              builder: (_) => BlocWrapper(child: const HomePage()))));
        } else if (state is SignInFailed) {
          Fluttertoast.showToast(msg: state.message);
        }
      }),
    );
  }
}
