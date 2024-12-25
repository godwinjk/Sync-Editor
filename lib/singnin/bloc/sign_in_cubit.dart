import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class SignInCubit extends Cubit<SignInCubitState> {
  SignInCubit() : super(SignInInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> checkAuthentication() async {
    emit(SignInProgress());

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        emit(AlreadySignedIn());
      } else {
        emit(SignInInitial());
      }
    } catch (e) {
      emit(SignInFailed("Checking user state failed"));
    }
  }

  Future<void> signIn() async {
    emit(SignInProgress());

    try {
      UserCredential userCredential = await _auth.signInAnonymously();

      if (kDebugMode) {
        print('Signed in as: ${userCredential.user?.uid}');
      }
      emit(SignInFinished());
    } catch (e) {
      emit(SignInFailed("Login failed"));
    }
  }
}

sealed class SignInCubitState extends Equatable {}

class SignInInitial extends SignInCubitState {
  @override
  List<Object?> get props => [];
}

class SignInProgress extends SignInCubitState {
  @override
  List<Object?> get props => [];
}

class AlreadySignedIn extends SignInCubitState {
  @override
  List<Object?> get props => [];
}

class SignInFinished extends SignInCubitState {
  @override
  List<Object?> get props => [];
}

class SignInFailed extends SignInCubitState {
  final String message;

  SignInFailed(this.message);

  @override
  List<Object?> get props => [];
}
