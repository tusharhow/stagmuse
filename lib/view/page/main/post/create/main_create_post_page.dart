import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class MainCreatePostPage extends StatefulWidget {
  const MainCreatePostPage({
    Key? key,
    required this.yourId,
  }) : super(key: key);
  final String yourId;

  @override
  _MainCreatePostPageState createState() => _MainCreatePostPageState();
}

class _MainCreatePostPageState extends State<MainCreatePostPage> {
  @override
  void initState() {
    super.initState();
    // Bloc
    final _postTypeBloc = context.read<PostTypeBloc>();
    final _postFileBloc = context.read<PostFileBloc>();

    // Update Bloc
    _postTypeBloc.add(const SetPostType(PostType.gallery));
    _postFileBloc.add(SetPostFile([]));
  }

  @override
  Widget build(BuildContext context) {
    // Bloc
    final _postTypeBloc = context.read<PostTypeBloc>();
    final _postFileBloc = context.watch<PostFileBloc>();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_postFileBloc.state.files.isNotEmpty) {
            // Navigate
            Navigator.push(
              context,
              navigatorTo(
                context: context,
                screen: PreCreateFilePostPage(yourId: widget.yourId),
              ),
            );
          } else {
            // Show snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.red,
                content: Text(
                  "You haven't uploaded any files",
                  style: medium12(colorThird),
                ),
              ),
            );
          }
        },
        label: Text(
          "Next",
          style: semiBold14(colorThird),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        backgroundColor: colorPrimary,
        elevation: 0,
      ),
      appBar: AppBar(
        leading: Row(
          children: [
            const SizedBox(width: margin),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Custom.back),
            ),
          ],
        ),
        title: BlocSelector<PostTypeBloc, PostTypeValue, PostType>(
            selector: (state) => state.type,
            builder: (context, state) {
              return DropdownButton(
                dropdownColor: colorBackground,
                underline: Container(),
                iconEnabledColor: colorThird,
                value: state,
                onChanged: (PostType? value) {
                  // Update Bloc
                  _postTypeBloc.add(SetPostType(value!));

                  if (value == PostType.text) {
                    // Navigate
                    Navigator.push(
                      context,
                      navigatorTo(
                        context: context,
                        screen: PreCreateTextPostPage(yourId: widget.yourId),
                      ),
                    );
                  }
                },
                items: [
                  // Gallery
                  DropdownMenuItem(
                    child: Text(
                      "Gallery",
                      style: medium18(colorThird),
                    ),
                    value: PostType.gallery,
                  ),
                  // Camera
                  DropdownMenuItem(
                    child: Text(
                      "Camera",
                      style: medium18(colorThird),
                    ),
                    value: PostType.camera,
                  ),
                  // Text
                  DropdownMenuItem(
                    child: Text(
                      "Text",
                      style: medium18(colorThird),
                    ),
                    value: PostType.text,
                  ),
                ],
              );
            }),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorSecondary,
                colorPrimary,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Post File
            const FileCreatePostWidget(forMainFilePost: false),
            // Button Pick File
            const SizedBox(height: 50),
            GestureDetector(
              onTap: () async {
                switch (_postTypeBloc.state.type) {
                  case PostType.camera:
                    // Get Image From Camera
                    await FileServices.getImageFromCamera().then(
                      (file) {
                        if (file != null) {
                          setState(() {
                            List<PostFile> files = _postFileBloc.state.files;
                            files.add(
                              PostFile(
                                url: file.readAsBytes(),
                                type: postTypeImage,
                                file: file,
                              ),
                            );

                            _postFileBloc.add(SetPostFile(files));
                          });
                        }
                      },
                    );
                    break;
                  default:
                    // Get Image From Gallery
                    await FileServices.getImageFromGallery().then(
                      (file) {
                        if (file != null) {
                          List<PostFile> files = _postFileBloc.state.files;
                          files.add(
                            PostFile(
                              url: file.readAsBytes(),
                              type: postTypeImage,
                              file: file,
                            ),
                          );

                          _postFileBloc.add(SetPostFile(files));
                        }
                      },
                    );
                }
              },
              child: Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorSecondary,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: colorThird,
                    size: 36,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
