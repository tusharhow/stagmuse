import 'package:bloc/bloc.dart';
import 'package:stagemuse/model/export_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<SetProfile, ProfileValue> {
  ProfileBloc() : super(const ProfileValue(null)) {
    on<SetProfile>((event, emit) {
      emit(ProfileValue(event.image));
    });
  }
}
