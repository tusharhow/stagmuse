import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';

Widget photoProfileAuthWidget(Uint8List? url) {
  return CircleAvatar(
    minRadius: double.infinity,
    backgroundColor:
        (url != null) ? Colors.transparent : Colors.black.withOpacity(0.3),
    backgroundImage: (url == null) ? null : MemoryImage(url),
    child: (url != null)
        ? null
        : const Icon(
            Custom.userFill,
            color: Colors.white,
            size: 56,
          ),
  );
}
