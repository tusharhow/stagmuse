import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreCreateFilePostPage extends StatefulWidget {
  const PreCreateFilePostPage({
    Key? key,
    required this.yourId,
  }) : super(key: key);
  final String yourId;

  @override
  _PreCreateFilePostPageState createState() => _PreCreateFilePostPageState();
}

class _PreCreateFilePostPageState extends State<PreCreateFilePostPage> {
  // Controller
  final _captionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _captionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Bloc
    final _postFileBloc = context.watch<PostFileBloc>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Row(
          children: [
            const SizedBox(width: margin),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.clear),
            ),
          ],
        ),
        title: const Text("New Post"),
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
      body: Column(
        children: [
          // Scroll Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // File Show
                  FileCreatePostWidget(
                      forMainFilePost: true,
                      height: MediaQuery.of(context).size.height * 1 / 3),
                  const SizedBox(height: 24),
                  // Cover || Caption
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: margin),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cover
                        Column(
                          children: [
                            FutureBuilder<Uint8List>(
                                future: _postFileBloc.state.files[0].url,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container(
                                      width: 80,
                                      height: 80,
                                      decoration: const BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                    );
                                  }
                                  return Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      image: DecorationImage(
                                        image: MemoryImage(
                                          snapshot.data!,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                }),
                            const SizedBox(height: 4),
                            Text(
                              "Cover",
                              style: regular12(colorThird),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        // Caption
                        Expanded(
                          child: TextField(
                            controller: _captionController,
                            maxLines: null,
                            style: regular12(Colors.grey),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(0),
                              hintText: "Write a caption...",
                              hintStyle: regular12(Colors.grey),
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              disabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Container(height: 0.5, color: colorPrimary),
          // Button Post
          BlocSelector<BackendResponseBloc, BackendResponseValue,
              BackEndStatus>(
            selector: (state) {
              return state.response.status;
            },
            builder: (context, state) {
              return flatTextButton(
                onPress: () async {
                  if (_captionController.text.isNotEmpty) {
                    await postServices.addImagePost(
                      context: context,
                      yourId: widget.yourId,
                      description: _captionController.text,
                      likes: [],
                    ).then(
                      (_) {
                        FirebaseStorageServices.setPostImage(
                          username: widget.yourId,
                          pickedFile: _postFileBloc.state.files,
                        );

                        Navigator.pushAndRemoveUntil(
                          context,
                          navigatorTo(
                            context: context,
                            screen: const LandingPage(),
                          ),
                          (route) => false,
                        );
                      },
                    );
                  }
                },
                text: (state == BackEndStatus.loading) ? "Loading..." : "Post",
                textColor: colorThird,
                buttonColor: colorPrimary,
                leftMargin: margin,
                rightMargin: margin,
                topMargin: 16,
                bottomMargin: 16,
                width: double.infinity,
                height: null,
              );
            },
          ),
        ],
      ),
    );
  }
}
