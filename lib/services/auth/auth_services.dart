import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/model/backend/backend.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Object
final AuthServices authServices = AuthServices();

class SignUpResponse {
  SignUpResponse({required this.message, required this.user});

  final String? message;
  final UserCredential? user;
}

class AuthServices {
  // Singleton
  static final _instance = AuthServices.constructor();
  AuthServices.constructor();

  factory AuthServices() {
    return _instance;
  }

  // Process
  Bloc _bloc(BuildContext context) {
    return context.read<BackendResponseBloc>();
  }

  // Method
  Future<SignUpResponse> signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Update Bloc
      _bloc(context).add(
        const SetBackendResponse(
          BackEndResponse(BackEndStatus.loading),
        ),
      );

      UserCredential user = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update Bloc
      _bloc(context).add(
        const SetBackendResponse(
          BackEndResponse(
            BackEndStatus.success,
          ),
        ),
      );

      return SignUpResponse(message: null, user: user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // Update Bloc
        _bloc(context).add(
          const SetBackendResponse(
            BackEndResponse(
              BackEndStatus.error,
            ),
          ),
        );

        return SignUpResponse(
            message: "Weak password,user minimal 6 character", user: null);
      }
      if (e.code == 'email-already-in-use') {
        // Update Bloc
        _bloc(context).add(
          const SetBackendResponse(
            BackEndResponse(
              BackEndStatus.error,
            ),
          ),
        );

        return SignUpResponse(message: "Email already in use", user: null);
      } else {
        // Update Bloc
        _bloc(context).add(
          const SetBackendResponse(
            BackEndResponse(
              BackEndStatus.error,
            ),
          ),
        );

        return SignUpResponse(message: "Invalid email", user: null);
      }
    }
  }

  Future<String?> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Update Bloc
      _bloc(context).add(
        const SetBackendResponse(
          BackEndResponse(BackEndStatus.loading),
        ),
      );

      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update Bloc
      _bloc(context).add(
        const SetBackendResponse(
          BackEndResponse(
            BackEndStatus.success,
          ),
        ),
      );

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Update Bloc
        _bloc(context).add(
          const SetBackendResponse(
            BackEndResponse(
              BackEndStatus.error,
            ),
          ),
        );

        return "User not found";
      }
      if (e.code == 'wrong-password') {
        // Update Bloc
        _bloc(context).add(
          const SetBackendResponse(
            BackEndResponse(
              BackEndStatus.error,
            ),
          ),
        );

        return "Wrong password";
      } else {
        // Update Bloc
        _bloc(context).add(
          const SetBackendResponse(
            BackEndResponse(
              BackEndStatus.error,
            ),
          ),
        );

        return "Invalid email";
      }
    }
  }

  Future<bool> changePassword(String email) async {
    try {
      return await firebaseAuth
          .sendPasswordResetEmail(email: email)
          .then((_) => true);
    } catch (e) {
      return false;
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
