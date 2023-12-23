import 'package:bloc/bloc.dart';
import 'package:cilean/data/repository/auth_repository.dart';
import 'package:cilean/data/resource/firebase_response.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository = AuthRepository();

  AuthBloc() : super(AuthInitial()) {
    on<SignInWithEmailAndPasswordEvent>(_onUserSignInWithEmailAndPassword);
    on<SignUpWithEmailAndPasswordEvent>(_onUserSignUpWithEmailAndPassword);
    on<SignInWithGoogle>(_onUserSignInWithGoogle);
  }

  Future<void> _onUserSignInWithEmailAndPassword(
    SignInWithEmailAndPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _repository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthLoadded(credential: response.data!));
    } catch (e) {
      emit(AuthError());
    }
  }

  Future<void> _onUserSignInWithGoogle(
    SignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    print("Start");
    emit(AuthLoading());
    try {
      final response = await _repository.signInWithGoogle();
      emit(AuthLoadded(credential: response.data!));
    } catch (e) {
      emit(AuthError());
    }
    print("End");
  }

  Future<void> _onUserSignUpWithEmailAndPassword(
    SignUpWithEmailAndPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _repository.signUpWithEmailAndPassword(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      emit(AuthLoadded(credential: response.data!));
    } catch (e) {
      emit(AuthError());
    }
  }
}
