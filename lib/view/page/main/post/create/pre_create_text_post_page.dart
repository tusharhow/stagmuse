import 'package:flutter/material.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/model/backend/backend.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreCreateTextPostPage extends StatefulWidget {
  const PreCreateTextPostPage({
    Key? key,
    required this.yourId,
  }) : super(key: key);
  final String yourId;

  @override
  _PreCreateTextPostPageState createState() => _PreCreateTextPostPageState();
}

class _PreCreateTextPostPageState extends State<PreCreateTextPostPage> {
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
    final _postTypeBloc = context.read<PostTypeBloc>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Row(
          children: [
            const SizedBox(width: margin),
            GestureDetector(
              onTap: () {
                // Update Bloc
                _postTypeBloc.add(const SetPostType(PostType.gallery));
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
                  const SizedBox(height: 36),
                  // Status Text
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: margin,
                    ),
                    child: TextField(
                      controller: _captionController,
                      maxLines: null,
                      style: regular18(Colors.grey),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(0),
                        hintText: "Type something...",
                        hintStyle: regular18(Colors.grey),
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
                onPress: () {
                  if (_captionController.text.isNotEmpty) {
                    postServices.addTextPost(
                      context: context,
                      yourId: widget.yourId,
                      status: _captionController.text,
                      likes: [],
                    ).whenComplete(
                      () {
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
