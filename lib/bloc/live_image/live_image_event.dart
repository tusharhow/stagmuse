part of 'live_image_bloc.dart';

class SetLiveImage {
  SetLiveImage({
    required this.cover,
    required this.images,
  });

  final XFile? cover;
  List<XFile> images;
}
