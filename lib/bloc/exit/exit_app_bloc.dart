import 'package:bloc/bloc.dart';

part 'exit_app_event.dart';
part 'exit_app_state.dart';

class ExitAppBloc extends Bloc<SetExitApp, ExitAppValue> {
  ExitAppBloc() : super(const ExitAppValue(false)) {
    on<SetExitApp>((event, emit) {
      emit(ExitAppValue(event.exit));
    });
  }
}
