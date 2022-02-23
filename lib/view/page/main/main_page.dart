import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
    required this.yourId,
  }) : super(key: key);
  final String yourId;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    // Story
    storyServices.deleteStoryControler(widget.yourId);
    // Notification
    // Notification
    notificationMessagingServices.onMessage(
      context: context,
      yourId: widget.yourId,
    );
    notificationServices.checkTotalUnreadNotif(
      yourId: widget.yourId,
      setTotal: (value) {
        context.read<NotificationBloc>().add(SetNotification(value));
      },
    );
    notificationMessagingServices.subsribeTopic("notif${widget.yourId}");
    notificationMessagingServices.subsribeTopic("chat${widget.yourId}");
    // Live
    liveServices.updateLiveStatus(widget.yourId);
  }

  @override
  Widget build(BuildContext context) {
    // Bloc
    final _bottomNavBloc = context.read<BottomNavigationBloc>();

    // Screen
    final _pages = [
      HomePage(yourId: widget.yourId),
      SearchPage(yourId: widget.yourId),
      NotificationPage(yourId: widget.yourId),
      NotificationPage(yourId: widget.yourId),
      ProfilePage.own(userId: null, yourId: widget.yourId),
    ];

    return BlocSelector<BottomNavigationBloc, BottomNavigationValue, int>(
        selector: (state) {
      return state.selectedIndex;
    }, builder: (context, state) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: (state == 0) ? true : false,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     // Show Bottom Sheet
        //     showModalBottomSheet(
        //       backgroundColor: colorBackground,
        //       shape: const RoundedRectangleBorder(
        //         borderRadius: BorderRadius.only(
        //           topLeft: Radius.circular(30),
        //           topRight: Radius.circular(30),
        //         ),
        //       ),
        //       context: context,
        //       builder: (context) {
        //         return SetTypePostWidget(yourId: widget.yourId);
        //       },
        //     );
        //   },
        //   child: const Icon(Icons.add, color: colorThird),
        //   elevation: 0,
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          notchMargin: 8,
          color: colorPrimary,
          elevation: 0,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorPrimary,
                  colorSecondary,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: margin, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      _bottomNavBloc.add(const SetBottomNavigation(0));
                    },
                    child: Icon(
                      (state == 0) ? Custom.homeFill : Custom.homeOutline,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _bottomNavBloc.add(const SetBottomNavigation(1));
                    },
                    child: Icon(
                      (state == 1) ? Custom.searchFill : Custom.searchOutline,
                      color: Colors.white,
                    ),
                  ),
                  // const SizedBox(width: 25),
                  // GestureDetector(
                  //   onTap: () {
                  // showModalBottomSheet(
                  //   backgroundColor: colorBackground,
                  //   shape: const RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.only(
                  //       topLeft: Radius.circular(30),
                  //       topRight: Radius.circular(30),
                  //     ),
                  //   ),
                  //   context: context,
                  //   builder: (context) {
                  //     return SetTypePostWidget(yourId: widget.yourId);
                  //   },
                  // );
                  //   },
                  //   child:
                  //       BlocSelector<NotificationBloc, NotificationValue, int>(
                  //     selector: (state) {
                  //       return state.total;
                  //     },
                  //     builder: (context, total) {
                  //       return notificationBottomNavigationWidget(
                  //         icon: Icon((state == 2) ? Icons.add : Icons.add,
                  //             color: colorThird),
                  //         total: total,
                  //       );
                  //     },
                  //   ),
                  // ),
                  GestureDetector(
                    onTap: () {
                      // _bottomNavBloc.add(const SetBottomNavigation(2));
                      showModalBottomSheet(
                        backgroundColor: colorBackground,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        context: context,
                        builder: (context) {
                          return SetTypePostWidget(yourId: widget.yourId);
                        },
                      );
                    },
                    child: Icon(
                      (state == 2) ? Icons.add : Icons.add,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _bottomNavBloc.add(const SetBottomNavigation(3));
                    },
                    child:
                        BlocSelector<NotificationBloc, NotificationValue, int>(
                      selector: (state) {
                        return state.total;
                      },
                      builder: (context, total) {
                        return notificationBottomNavigationWidget(
                          icon: Icon(
                            (state == 3)
                                ? Custom.notificationFill
                                : Custom.notificationOutline,
                            color: Colors.white,
                          ),
                          total: total,
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _bottomNavBloc.add(const SetBottomNavigation(4));
                    },
                    child: profileBottomNavigationWidget(
                      index: state,
                      yourId: widget.yourId,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: _pages.elementAt(state),
      );
    });
  }
}
