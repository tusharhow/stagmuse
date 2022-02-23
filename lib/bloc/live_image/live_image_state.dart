part of 'live_image_bloc.dart';

class LiveImageValue {
  LiveImageValue({
    required this.cover,
    required this.images,
  });

  final XFile? cover;
  List<XFile> images;
}
