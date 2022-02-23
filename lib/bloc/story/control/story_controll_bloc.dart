import 'package:bloc/bloc.dart';

part 'story_controll_event.dart';
part 'story_controll_state.dart';

class StoryControllBloc extends Bloc<SetStoryControll, StoryControllValue> {
  StoryControllBloc()
      : super(const StoryControllValue(activeSlideIndex: 0, storyId: null)) {
    on<SetStoryControll>((event, emit) {
      emit(
        StoryControllValue(
          activeSlideIndex: event.activeSlideIndex,
          storyId: event.storyId,
        ),
      );
    });
  }
}
