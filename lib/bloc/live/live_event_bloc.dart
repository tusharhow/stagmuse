import 'package:bloc/bloc.dart';
import 'package:stagemuse/model/export_model.dart';

part 'live_event_event.dart';
part 'live_event_state.dart';

class LiveEventBloc extends Bloc<SetLiveEventProgress, LiveEventProgressValue> {
  LiveEventBloc()
      : super(LiveEventProgressValue(
          live: Live(),
          value: 0,
        )) {
    on<SetLiveEventProgress>((event, emit) {
      emit(
        LiveEventProgressValue(
          live: event.live,
          value: event.value * 2 / 10,
        ),
      );
    });
  }
}
