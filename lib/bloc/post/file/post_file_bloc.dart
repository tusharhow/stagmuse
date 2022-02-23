import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'post_file_event.dart';
part 'post_file_state.dart';

class PostFile {
  const PostFile({
    required this.url,
    required this.file,
    required this.type,
  });

  final Future<Uint8List> url;
  final XFile file;
  final String type;
}

class PostFileBloc extends Bloc<SetPostFile, PostFileValue> {
  PostFileBloc() : super(PostFileValue([])) {
    on<SetPostFile>((event, emit) {
      emit(PostFileValue(event.files));
    });
  }
}
