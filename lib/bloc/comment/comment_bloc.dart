import 'package:bloc/bloc.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<SetComment, CommentValue> {
  CommentBloc() : super(const CommentValue(false)) {
    on<SetComment>((event, emit) {
      emit(CommentValue(event.expand));
    });
  }
}
