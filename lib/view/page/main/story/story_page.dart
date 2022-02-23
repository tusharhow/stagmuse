import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/view/export_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum StoryType { own, other }

class StoryPage extends StatelessWidget {
  const StoryPage({
    Key? key,
    required this.userId,
    required this.yourId,
    required this.type,
    required this.index,
  }) : super(key: key);
  final String userId, yourId;
  final int index;
  final StoryType type;

  @override
  Widget build(BuildContext context) {
    // Bloc
    final _storyBloc = context.read<StoryCommentBloc>();

    return WillPopScope(
      onWillPop: () async {
        _storyBloc.add(const SetStoryComment(false));
        return true;
      },
      child: AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.transparent,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    ViewStoryWidget(
                      userId: (type == StoryType.own) ? userId : yourId,
                      type: type,
                      index: index,
                    ),
                    SizedBox(height: (type == StoryType.own) ? 30 : 56),
                  ],
                ),
                BlocSelector<StoryCommentBloc, StoryCommentValue, bool>(
                  selector: (state) => state.showComment,
                  builder: (context, state) {
                    return (state)
                        ? Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height,
                            color: Colors.black.withOpacity(0.4),
                          )
                        : Container();
                  },
                ),
                (type == StoryType.own)
                    ? BlocSelector<StoryControllBloc, StoryControllValue,
                        String?>(
                        selector: (state) {
                          return state.storyId;
                        },
                        builder: (context, state) {
                          return ButtonSeeStoryViewerWidget(
                            storyId: state,
                            userId: userId,
                          );
                        },
                      )
                    : StoryCommentBarWidget(
                        userId: userId,
                        yourId: yourId,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
