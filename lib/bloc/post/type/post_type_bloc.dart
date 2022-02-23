import 'package:bloc/bloc.dart';

part 'post_type_event.dart';
part 'post_type_state.dart';

enum PostType { gallery, camera, text }

class PostTypeBloc extends Bloc<SetPostType, PostTypeValue> {
  PostTypeBloc() : super(const PostTypeValue(PostType.gallery)) {
    on<SetPostType>((event, emit) {
      emit(PostTypeValue(event.type));
    });
  }
}
