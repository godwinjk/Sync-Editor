import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synceditor/common_bloc/bloc_wrapper.dart';
import 'package:synceditor/home/bloc/editor_cubit.dart';
import 'package:synceditor/singnin/sing_in_page.dart';

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
      ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
        content: const Row(
          children: [
            Icon(
              Icons.warning,
              color: Colors.redAccent,
            ),
            Expanded(
                child: Text(
                    'Do not share password or any credentials. The message is not encrypted and I can see everything.'))
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
              },
              icon: const Icon(Icons.close))
        ],
      ));
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
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                _showLogoutDialog();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocConsumer<EditorCubit, EditorState>(
          builder: (_, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: Container()),
                Container(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.sizeOf(context).height * 0.8),
                  child: SingleChildScrollView(
                    reverse: true,
                    child: TextField(
                      autofocus: true,
                      expands: false,
                      controller: _controller,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      // Allows infinite lines
                      style: const TextStyle(fontSize: 18),
                      onChanged: (text) {
                        context.read<EditorCubit>().uploadContent(text);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Start typing here...',
                        border: InputBorder.none,
                      ),
                    ),
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
      )),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out Confirmation'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog
              await FirebaseAuth.instance.signOut(); // Perform logout
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) =>
                        const BlocWrapper(child: SignInPage())),
              );
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
