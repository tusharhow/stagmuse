import 'package:flutter/material.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class ProfileMainWidget extends StatelessWidget {
  const ProfileMainWidget({
    Key? key,
    required this.type,
    required this.yourId,
    required this.userId,
  }) : super(key: key);
  final ProfilePageType type;
  final String yourId;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverList(
              delegate: SliverChildListDelegate.fixed(
                [
                  ProfileTopBarWidget(
                    type: type,
                    userId: userId,
                    yourId: yourId,
                  ),
                ],
              ),
            ),
          ];
        },
        body: Column(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: colorPrimary,
                  ),
                ),
              ),
              child: TabBar(
                labelPadding: const EdgeInsets.all(0),
                labelStyle: semiBold14(colorThird),
                unselectedLabelStyle: regular14(colorThird),
                labelColor: colorPrimary,
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 5.0,
                    color: colorPrimary,
                  ),
                ),
                tabs: const [
                  Tab(icon: Text("Post")),
                  Tab(icon: Text("Liked")),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: const BouncingScrollPhysics(),
                children: [
                  // Post
                  ProfilePostComponentWidget(
                    type: type,
                    userId: (type == ProfilePageType.own) ? yourId : userId!,
                  ),
                  // Like
                  ProfileLikePostComponentWidget(
                    yourId: yourId,
                    type: type,
                    userId: (type == ProfilePageType.own) ? yourId : userId!,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
