part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class SignInWithEmailAndPasswordEvent extends AuthEvent {
  SignInWithEmailAndPasswordEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

class SignUpWithEmailAndPasswordEvent extends AuthEvent {
  SignUpWithEmailAndPasswordEvent({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;
}

class SignInWithGoogle extends AuthEvent {}
