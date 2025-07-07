// login_bloc.dart
import 'package:finalproject/data/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial());

  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginRequested) {
      yield LoginLoading(); 

      try {
        var response = await authRepository.login(event.email, event.password);
        yield LoginSuccess(message: response['message']);
      } catch (e) {
        yield LoginFailure(errorMessage: e.toString());
      }
    }
  }
}
