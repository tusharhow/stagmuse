import 'package:flutter/material.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({
    Key? key,
    required this.yourId,
  }) : super(key: key);
  final String yourId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: DefaultTabController(
        length: 2,
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
                  snap: false,
                  primary: true,
                  elevation: 0,
                  forceElevated: innerBoxIsScrolled,
                  titleSpacing: margin,
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
                  title: Row(
                    children: [
                      const SizedBox(width: 8),
                      Text(
                        "Notifications",
                        style: bold22(colorThird),
                      ),
                    ],
                  ),
                  bottom: PreferredSize(
                    child: TabBar(
                      labelPadding: const EdgeInsets.all(0),
                      labelStyle: semiBold14(Colors.black),
                      unselectedLabelStyle: regular14(Colors.black),
                      labelColor: colorThird,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: colorThird,
                      indicator: const UnderlineTabIndicator(
                        borderSide: BorderSide(
                          width: 5.0,
                          color: colorThird,
                        ),
                      ),
                      tabs: const [
                        Tab(icon: Text("Follow")),
                        Tab(icon: Text("Like")),
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
              MainFollowNotificationWidget(yourId: yourId),
              MainLikeNotificationWidget(yourId: yourId),
            ],
          ),
        ),
      ),
    );
  }
}
