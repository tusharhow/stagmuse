import 'package:bloc/bloc.dart';

part 'bottom_navigation_event.dart';
part 'bottom_navigation_state.dart';

class BottomNavigationBloc
    extends Bloc<SetBottomNavigation, BottomNavigationValue> {
  BottomNavigationBloc() : super(const BottomNavigationValue(0)) {
    on<SetBottomNavigation>((event, emit) {
      emit(BottomNavigationValue(event.selectedIndex));
    });
  }
}
