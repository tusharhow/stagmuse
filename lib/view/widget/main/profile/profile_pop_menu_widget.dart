import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

Widget profilePopMenuWidget({
  required BuildContext context,
  required ProfilePageType type,
  required String yourId,
  required String? userId,
}) {
  // Bloc
  final _popMenu = context.read<ProfilePopMenuBloc>();

  switch (type) {
    case ProfilePageType.own:
      return BlocSelector<ProfilePopMenuBloc, ProfilePopMenuValue,
          ProfilePopMenu?>(
        selector: (state) => state.value,
        builder: (context, state) {
          return PopupMenuButton<ProfilePopMenu>(
            onSelected: (value) {
              // Update Bloc
              _popMenu.add(SetProfilePopMenu(value));
              // Do Statement
              // Log Out
              if (value == ProfilePopMenu.logout) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return confirmationDialog(
                      content: Text(
                        "Are you sure you want to out from your account?",
                        style: medium14(colorThird),
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        flatTextButton(
                          onPress: () async {
                            notificationMessagingServices.unSubsribeTopic(
                              'chat$yourId',
                            );
                            notificationMessagingServices.unSubsribeTopic(
                              'notif$yourId',
                            );
                            await authServices.signOut();
                            Navigator.pop(context);
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
              }
              // Block
              else {
                // Navigate
                Navigator.push(
                  context,
                  navigatorTo(
                    context: context,
                    screen: ProfileBlockedAccountsPage(yourId: yourId),
                  ),
                );
              }
            },
            itemBuilder: (context) => <PopupMenuEntry<ProfilePopMenu>>[
              // Blocked Accounts
              PopupMenuItem<ProfilePopMenu>(
                value: ProfilePopMenu.blockedAccounts,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Blocked accounts'),
                    Icon(Icons.block, color: Colors.grey),
                  ],
                ),
              ),
              // Log Out
              PopupMenuItem<ProfilePopMenu>(
                value: ProfilePopMenu.logout,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Logout'),
                    Icon(Icons.exit_to_app, color: Colors.grey),
                  ],
                ),
              ),
            ],
          );
        },
      );

    default:
      return BlocSelector<ProfilePopMenuBloc, ProfilePopMenuValue,
          ProfilePopMenu?>(
        selector: (state) => state.value,
        builder: (context, state) {
          return PopupMenuButton<ProfilePopMenu>(
            onSelected: (value) {
              // Update Bloc
              _popMenu.add(SetProfilePopMenu(value));
              // Do Statement
              if (value == ProfilePopMenu.block) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return confirmationDialog(
                      content: Text(
                        "Are you sure you want to block this account?",
                        style: medium14(colorThird),
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        flatTextButton(
                          onPress: () {
                            if (userId != null) {
                              userServices.addBloc(
                                yourId: yourId,
                                userId: userId,
                              );
                              userServices.block(
                                  userId: userId, yourId: yourId);
                              Navigator.pop(context);
                            }
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
              }
            },
            itemBuilder: (context) => <PopupMenuEntry<ProfilePopMenu>>[
              PopupMenuItem<ProfilePopMenu>(
                value: ProfilePopMenu.block,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Block'),
                    Icon(Icons.block, color: Colors.grey),
                  ],
                ),
              ),
            ],
          );
        },
      );
  }
}
