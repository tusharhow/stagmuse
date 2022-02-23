import 'package:flutter/material.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class ButtonProfileLive extends StatelessWidget {
  const ButtonProfileLive({
    Key? key,
    required this.liveId,
    required this.isCreate,
    required this.isEdit,
    required this.yourId,
    required this.type,
    required this.live,
  }) : super(key: key);
  final String yourId, liveId;
  final bool isCreate, isEdit;
  final ProfileLiveType type;
  final Live live;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ProfileLiveType.other:
        return Container(
          color: colorBackground,
          padding: const EdgeInsets.symmetric(horizontal: margin, vertical: 16),
          child: Row(
            children: [
              // Total Followers
              Column(
                children: [
                  Text(
                    convertTextFormat((isCreate) ? 0 : live.followers!.length),
                    style: medium14(colorThird),
                  ),
                  Text(
                    "Followers",
                    style: semiBold14(colorThird),
                  ),
                ],
              ),
              // Button Follow || Unfoll
              Expanded(
                child: (!isCreate && !isEdit)
                    ? (live.followers!.contains(yourId))
                        ? flatOutlineTextButton(
                            onPress: () {
                              if (type != ProfileLiveType.own) {
                                if (!isCreate && !isEdit) {
                                  // For Live
                                  liveServices.deleteLiveFollowers(
                                    liveId: liveId,
                                    yourId: yourId,
                                  );

                                  // For You
                                  userServices.deleteLiveFollow(
                                    liveId: liveId,
                                    userId: yourId,
                                  );
                                }
                              }
                            },
                            text: "Unfoll",
                            textColor: colorPrimary,
                            borderColor: colorPrimary,
                            leftMargin: 16,
                            rightMargin: 0,
                            topMargin: 0,
                            bottomMargin: 0,
                            width: double.infinity,
                          )
                        : flatTextButton(
                            onPress: () {
                              if (type != ProfileLiveType.own) {
                                if (!isCreate && !isEdit) {
                                  // For Live
                                  liveServices.addLiveFollowers(
                                    liveId: liveId,
                                    yourId: yourId,
                                  );

                                  // For You
                                  userServices.addLiveFollow(
                                    liveId: liveId,
                                    userId: yourId,
                                  );
                                }
                              }
                            },
                            text: "Follow",
                            textColor: colorThird,
                            buttonColor: colorPrimary,
                            leftMargin: 16,
                            rightMargin: 0,
                            topMargin: 0,
                            bottomMargin: 0,
                            width: double.infinity,
                          )
                    : flatTextButton(
                        onPress: () {},
                        text: "Follow",
                        textColor: colorThird,
                        buttonColor: colorPrimary,
                        leftMargin: 16,
                        rightMargin: 0,
                        topMargin: 0,
                        bottomMargin: 0,
                        width: double.infinity,
                      ),
              ),
            ],
          ),
        );
      default:
        return Container(
          color: colorBackground,
          padding: const EdgeInsets.symmetric(horizontal: margin, vertical: 16),
          child: Row(
            children: [
              // Button Edit
              Expanded(
                flex: 6,
                child: flatTextButton(
                  onPress: () {
                    // Navigate
                    Navigator.push(
                      context,
                      navigatorTo(
                        context: context,
                        screen: ProfileCreateEditLiveEventPage.edit(
                          yourId: yourId,
                          liveId: liveId,
                          live: live,
                        ),
                      ),
                    );
                  },
                  text: "Edit",
                  textColor: colorThird,
                  buttonColor: colorPrimary,
                  leftMargin: 0,
                  rightMargin: 0,
                  topMargin: 0,
                  bottomMargin: 0,
                  width: double.infinity,
                  height: null,
                ),
              ),
              const SizedBox(width: 16),
              // Button Delete
              Expanded(
                flex: 2,
                child: flatOutlineIconButton(
                  onPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return confirmationDialog(
                          content: Text(
                            "Are you sure you want to delete this live",
                            style: medium14(colorThird),
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            flatTextButton(
                              onPress: () {
                                // Update firebase
                                liveServices.deleteLive(liveId);
                                // Back
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    navigatorTo(
                                      context: context,
                                      screen: const LandingPage(),
                                    ),
                                    (route) => false);
                              },
                              text: "Yes",
                              textColor: colorThird,
                              buttonColor: colorPrimary,
                              leftMargin: 0,
                              rightMargin: 0,
                              topMargin: 0,
                              bottomMargin: 0,
                              width: null,
                              height: null,
                            ),
                            flatOutlineTextButton(
                              onPress: () {
                                // Back
                                Navigator.pop(context);
                              },
                              text: "No",
                              textColor: colorPrimary,
                              borderColor: colorPrimary,
                              leftMargin: 0,
                              rightMargin: 0,
                              topMargin: 0,
                              bottomMargin: 0,
                              width: null,
                              height: null,
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Custom.delete,
                  iconColor: colorPrimary,
                  iconSize: 18,
                  borderColor: colorPrimary,
                  leftMargin: 0,
                  rightMargin: 0,
                  topMargin: 0,
                  bottomMargin: 0,
                  width: double.infinity,
                  height: null,
                ),
              ),
            ],
          ),
        );
    }
  }
}
