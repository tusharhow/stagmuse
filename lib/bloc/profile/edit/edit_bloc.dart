import 'package:bloc/bloc.dart';

part 'edit_event.dart';
part 'edit_state.dart';

class EditProfileBloc extends Bloc<SetEditProfile, EditProfileValue> {
  EditProfileBloc()
      : super(const EditProfileValue(
          userNameEmpty: false,
          nameEmpty: false,
          bioEmpty: false,
          privateAccount: false,
        )) {
    on<SetEditProfile>((event, emit) {
      emit(EditProfileValue(
        userNameEmpty: event.userNameEmpty,
        nameEmpty: event.nameEmpty,
        bioEmpty: event.bioEmpty,
        privateAccount: event.privateAccount,
      ));
    });
  }
}
