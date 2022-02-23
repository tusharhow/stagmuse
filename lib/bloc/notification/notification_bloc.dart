import 'package:bloc/bloc.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<SetNotification, NotificationValue> {
  NotificationBloc() : super(const NotificationValue(0)) {
    on<SetNotification>((event, emit) {
      emit(NotificationValue(event.total));
    });
  }
}
