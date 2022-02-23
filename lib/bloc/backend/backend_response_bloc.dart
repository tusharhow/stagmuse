import 'package:bloc/bloc.dart';
import 'package:stagemuse/model/export_model.dart';

part 'backend_response_event.dart';
part 'backend_response_state.dart';

class BackendResponseBloc
    extends Bloc<SetBackendResponse, BackendResponseValue> {
  BackendResponseBloc()
      : super(const BackendResponseValue(
            BackEndResponse(BackEndStatus.undoing))) {
    on<SetBackendResponse>((event, emit) {
      emit(
        BackendResponseValue(
          BackEndResponse(
            event.response.status,
          ),
        ),
      );
    });
  }
}
