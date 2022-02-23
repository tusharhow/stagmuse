import 'package:flutter/material.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({
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
                  forceElevated: innerBoxIsScrolled,
                  leading: Row(
                    children: const [
                      SizedBox(width: margin),
                      Icon(
                        Custom.searchOutline,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  title: const SearchSearchBarWidget(),
                  centerTitle: true,
                  bottom: PreferredSize(
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: margin,
                      ),
                      child: TabBar(
                        labelPadding: const EdgeInsets.all(0),
                        labelStyle: semiBold14(Colors.black),
                        unselectedLabelStyle: regular14(Colors.black),
                        labelColor: colorThird,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: const UnderlineTabIndicator(
                          borderSide: BorderSide(
                            width: 5.0,
                            color: colorThird,
                          ),
                        ),
                        tabs: const [
                          Tab(icon: Text("Account")),
                          Tab(icon: Text("Post")),
                        ],
                      ),
                    ),
                    preferredSize: const Size(double.infinity, 48),
                  ),
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              AccountSearchResultWidget(yourId: yourId),
              PostSearchResultWidget(yourId: yourId),
            ],
          ),
        ),
      ),
    );
  }
}
