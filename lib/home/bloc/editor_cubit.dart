import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Editor Cubit class
class EditorCubit extends Cubit<EditorState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Store the current content in the EditorCubit
  String _content = '';

  // Firestore document reference
  final String documentId = 'editor_content';
  late String uid = '';

  EditorCubit() : super(EditorInitial());

  Future<void> initUserId() async {
    uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  // Method to upload content to Firestore
  Future<void> uploadContent(String content) async {
    try {
      emit(EditorUploading());
      _content = content;
      // Upload content to Firestore
      await _firestore.collection('editor').doc(documentId).set({
        'content': content,
        'timestamp': FieldValue.serverTimestamp(),
        'uid': uid,
      });

      emit(EditorUploadSuccess(content));
    } catch (e) {
      emit(EditorError('Failed to upload content: $e'));
    }
  }

  // Method to listen for changes in Firestore
  void listenToChanges() {
    _firestore.collection('editor').doc(documentId).snapshots().listen(
        (snapshot) {
      if (snapshot.exists) {
        String newContent = snapshot['content'] ?? '';

        if (_content != newContent) {
          _content = newContent;
          emit(EditorNewContent(newContent)); // Emit the new content state
        }
      } else {
        emit(EditorError('Document not found.'));
      }
    }, onError: (error) {
      emit(EditorError('Document not found.'));
    });
  }

  // Get the current content
  String get currentContent => _content;
}

// Define the states for the EditorCubit
sealed class EditorState extends Equatable {}

class EditorInitial extends EditorState {
  @override
  List<Object?> get props => [];
}

class EditorUploading extends EditorState {
  @override
  List<Object?> get props => [];
}

class EditorUploadSuccess extends EditorState {
  final String content;

  EditorUploadSuccess(this.content);

  @override
  List<Object?> get props => [content];
}

class EditorNewContent extends EditorState {
  final String content;

  EditorNewContent(this.content);

  @override
  List<Object?> get props => [content];
}

class EditorError extends EditorState {
  final String message;

  EditorError(this.message);

  @override
  List<Object?> get props => [message];
}
