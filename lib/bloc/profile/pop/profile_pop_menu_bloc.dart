import 'package:bloc/bloc.dart';

part 'profile_pop_menu_event.dart';
part 'profile_pop_menu_state.dart';

enum ProfilePopMenu { logout, block, blockedAccounts }

class ProfilePopMenuBloc extends Bloc<SetProfilePopMenu, ProfilePopMenuValue> {
  ProfilePopMenuBloc() : super(const ProfilePopMenuValue(null)) {
    on<SetProfilePopMenu>((event, emit) {
      emit(ProfilePopMenuValue(event.value));
    });
  }
}
