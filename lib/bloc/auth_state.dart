part of 'auth_cubit.dart';

abstract class AuthState extends Equatable{
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState{
   const AuthInitial();
}

class AuthLoading extends AuthState{
  const AuthLoading();
}

class AuthSignUp extends AuthState{
  const AuthSignUp();
}

class AuthSignIn extends AuthState{
  const AuthSignIn();
}

class AuthError extends AuthState{

  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
