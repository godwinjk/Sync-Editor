import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synceditor/home/bloc/editor_cubit.dart';
import 'package:synceditor/singnin/bloc/sign_in_cubit.dart';

class BlocWrapper extends StatelessWidget {
  const BlocWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<SignInCubit>(create: (_) => SignInCubit()),
      BlocProvider<EditorCubit>(create: (_) => EditorCubit())
    ], child: child);
  }
}
