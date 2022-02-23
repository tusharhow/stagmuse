import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class ImageData {
  const ImageData({
    required this.dataLocal,
    required this.file,
  });

  final Future<Uint8List> dataLocal;
  final XFile file;
}
