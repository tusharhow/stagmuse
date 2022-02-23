import 'package:bloc/bloc.dart';

part 'story_comment_event.dart';
part 'story_comment_state.dart';

class StoryCommentBloc extends Bloc<SetStoryComment, StoryCommentValue> {
  StoryCommentBloc() : super(const StoryCommentValue(false)) {
    on<SetStoryComment>((event, emit) {
      emit(StoryCommentValue(event.showComment));
    });
  }
}
