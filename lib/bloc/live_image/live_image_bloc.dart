import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'live_image_event.dart';
part 'live_image_state.dart';

class LiveImageBloc extends Bloc<SetLiveImage, LiveImageValue> {
  LiveImageBloc() : super(LiveImageValue(cover: null, images: [])) {
    on<SetLiveImage>((event, emit) {
      emit(LiveImageValue(cover: event.cover, images: event.images));
    });
  }
}
