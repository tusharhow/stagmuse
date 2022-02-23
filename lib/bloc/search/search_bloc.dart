import 'package:bloc/bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SetSearch, SearchValue> {
  SearchBloc() : super(const SearchValue(null)) {
    on<SetSearch>((event, emit) {
      emit(SearchValue(event.search));
    });
  }
}
