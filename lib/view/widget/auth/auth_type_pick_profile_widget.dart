import 'package:flutter/material.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stagemuse/model/export_model.dart';

class AuthTypePickProfileWidget extends StatelessWidget {
  const AuthTypePickProfileWidget({
    Key? key,
    required this.username,
  }) : super(key: key);
  final String username;

  @override
  Widget build(BuildContext context) {
    // Bloc
    final _imageBloc = context.read<ProfileBloc>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Camera
        ListTile(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          onTap: () async {
            Navigator.pop(context);
            await FileServices.getImageFromCamera().then((value) {
              if (value != null) {
                // Update Bloc
                _imageBloc.add(
                  SetProfile(
                    ImageData(
                      dataLocal: value.readAsBytes(),
                      file: value,
                    ),
                  ),
                );
              }
            });
          },
          contentPadding:
              const EdgeInsets.symmetric(horizontal: margin, vertical: 8),
          title: Text(
            "Camera",
            style: medium18(colorThird),
          ),
          trailing: const Icon(Custom.camera, color: colorThird),
        ),
        // Gallery
        ListTile(
          onTap: () async {
            Navigator.pop(context);
            await FileServices.getImageFromGallery().then((value) {
              if (value != null) {
                // Update Bloc
                _imageBloc.add(
                  SetProfile(
                    ImageData(
                      dataLocal: value.readAsBytes(),
                      file: value,
                    ),
                  ),
                );
              }
            });
          },
          contentPadding:
              const EdgeInsets.symmetric(horizontal: margin, vertical: 8),
          title: Text(
            "Gallery",
            style: medium18(colorThird),
          ),
          trailing: const Icon(Custom.gallery, color: colorThird),
        ),
      ],
    );
  }
}
