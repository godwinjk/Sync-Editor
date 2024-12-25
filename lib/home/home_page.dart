import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synceditor/home/bloc/editor_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    context.read<EditorCubit>().initUserId();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EditorCubit>().listenToChanges();
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Form(
              child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocConsumer<EditorCubit, EditorState>(
          builder: (_, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextField(
                  autofocus: true,
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null, // Allows infinite lines
                  style: const TextStyle(fontSize: 18),
                  onChanged: (text) {
                    context.read<EditorCubit>().uploadContent(text);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Start typing here...',
                    border: InputBorder.none,
                  ),
                ),
              ],
            );
          },
          listener: (_, state) {
            if (state is EditorNewContent) {
              _controller.text = state.content;
            }
          },
        ),
      ))),
    );
  }
}
