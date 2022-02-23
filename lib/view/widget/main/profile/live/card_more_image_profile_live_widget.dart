import 'dart:typed_data';

import 'package:flutter/material.dart';

Widget cardMoreImageProfileLiveWidget({
  required Uint8List? memory,
  required String? network,
  required int index,
  required int lastIndex,
}) {
  return AspectRatio(
    aspectRatio: 3.0 / 4.0,
    child: (memory != null)
        ? Container(
            margin: EdgeInsets.only(
              right: (index == lastIndex) ? 0 : 16,
            ),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: const BorderRadius.all(Radius.circular(7)),
              image: DecorationImage(
                image: MemoryImage(memory),
                fit: BoxFit.cover,
              ),
            ),
          )
        : Container(
            margin: EdgeInsets.only(
              right: (index == lastIndex) ? 0 : 16,
            ),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: const BorderRadius.all(Radius.circular(7)),
              image: DecorationImage(
                image: NetworkImage(network!),
                fit: BoxFit.cover,
              ),
            ),
          ),
  );
}
