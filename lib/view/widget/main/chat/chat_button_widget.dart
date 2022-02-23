import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class ChatButtonWidget extends StatelessWidget {
  const ChatButtonWidget({
    Key? key,
    required this.yourId,
  }) : super(key: key);
  final String yourId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestoreUser
            .doc(yourId)
            .collection('CHAT')
            .where('read', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return GestureDetector(
              onTap: () {
                adsServices.showInterstitialAd();
                // Navigate
                Navigator.push(
                  context,
                  navigatorTo(
                    context: context,
                    screen: ChatListPage(yourId: yourId),
                  ),
                );
              },
              child: const Icon(Custom.chat),
            );
          } else {
            final List total = snapshot.data!.docs;

            return (total.isNotEmpty)
                ? Badge(
                    position: const BadgePosition(top: 5, end: -3),
                    badgeContent: Text(
                      ((total.length) > 9) ? "9+" : "${total.length}",
                      style: regular10(colorThird),
                    ),
                    badgeColor: Colors.red,
                    child: GestureDetector(
                      onTap: () {
                        adsServices.showInterstitialAd();
                        // Navigate
                        Navigator.push(
                          context,
                          navigatorTo(
                            context: context,
                            screen: ChatListPage(yourId: yourId),
                          ),
                        );
                      },
                      child: const Icon(Custom.chat),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      adsServices.showInterstitialAd();
                      // Navigate
                      Navigator.push(
                        context,
                        navigatorTo(
                          context: context,
                          screen: ChatListPage(yourId: yourId),
                        ),
                      );
                    },
                    child: const Icon(Custom.chat),
                  );
          }
        });
  }
}
