import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

enum ProfileFollowType { followers, following }

class ProfileFollowPage extends StatefulWidget {
  const ProfileFollowPage({
    Key? key,
    required this.type,
    required this.yourId,
    required this.userId,
  }) : super(key: key);
  final ProfileFollowType type;
  final String userId, yourId;

  const ProfileFollowPage.followers({
    Key? key,
    this.type = ProfileFollowType.followers,
    required this.yourId,
    required this.userId,
  }) : super(key: key);

  const ProfileFollowPage.following({
    Key? key,
    this.type = ProfileFollowType.following,
    required this.yourId,
    required this.userId,
  }) : super(key: key);

  @override
  _ProfileFollowPageState createState() => _ProfileFollowPageState();
}

class _ProfileFollowPageState extends State<ProfileFollowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: DefaultTabController(
        length: 2,
        initialIndex: (widget.type == ProfileFollowType.followers) ? 0 : 1,
        child: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverSafeArea(
                top: false,
                sliver: SliverAppBar(
                  expandedHeight: 100,
                  floating: true,
                  pinned: true,
                  elevation: 0,
                  forceElevated: innerBoxIsScrolled,
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
                  title: // User name
                      StreamBuilder<DocumentSnapshot>(
                    stream: firestoreUser.doc(widget.userId).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Text("Loading...");
                      } else {
                        // Object
                        final User user = User.fromMap(
                            snapshot.data!.data() as Map<String, dynamic>);

                        final DataProfile dataProfile =
                            DataProfile.fromMap(user.dataProfile!);

                        return Text("@${dataProfile.username}");
                      }
                    },
                  ),
                  centerTitle: true,
                  bottom: PreferredSize(
                    child: TabBar(
                      labelPadding: const EdgeInsets.all(0),
                      labelStyle: semiBold14(Colors.black),
                      unselectedLabelStyle: regular14(Colors.black),
                      labelColor: colorThird,
                      indicator: const UnderlineTabIndicator(
                        borderSide: BorderSide(
                          width: 5.0,
                          color: colorThird,
                        ),
                      ),
                      tabs: const [
                        Tab(icon: Text("Followers")),
                        Tab(icon: Text("Following")),
                      ],
                    ),
                    preferredSize: const Size(double.infinity, 48),
                  ),
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              ProfileFollowersComponentWidget(
                  userId: widget.userId, yourId: widget.yourId),
              ProfileFollowingComponentWidget(
                  userId: widget.userId, yourId: widget.yourId),
            ],
          ),
        ),
      ),
    );
  }
}
