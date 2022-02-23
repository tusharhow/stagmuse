import 'package:flutter/material.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class CardProfileBlockedAccountsWidget extends StatelessWidget {
  const CardProfileBlockedAccountsWidget({
    Key? key,
    required this.userId,
    required this.yourId,
    required this.dataProfile,
  }) : super(key: key);
  final String yourId, userId;
  final DataProfile dataProfile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate
        Navigator.push(
          context,
          navigatorTo(
            context: context,
            screen: ProfilePage.other(
              yourId: yourId,
              userId: userId,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: margin, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile
            photoProfileNetworkUtils(size: 48, url: dataProfile.photo),
            const SizedBox(width: 8),
            // User name || Desciprition
            Expanded(
              child: Text(
                "@${dataProfile.username}",
                style: semiBold14(colorThird),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
