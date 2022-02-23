import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class ProfilePostComponentWidget extends StatelessWidget {
  const ProfilePostComponentWidget({
    Key? key,
    required this.type,
    required this.userId,
  }) : super(key: key);
  final ProfilePageType type;
  final String userId;

  @override
  Widget build(BuildContext context) {
    // Size Grid
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height * 1 / 5;
    final double itemWidth = size.width / 3;

    return StreamBuilder<QuerySnapshot>(
      stream: firestoreUser
          .doc(userId)
          .collection("POST")
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text(
              "Loading...",
              style: medium14(colorThird),
            ),
          );
        }
        return (snapshot.data!.docs.isNotEmpty)
            ? GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                crossAxisSpacing: 2,
                childAspectRatio: (itemWidth / itemHeight),
                mainAxisSpacing: 2,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                  snapshot.data!.docs.length,
                  (index) {
                    // Object
                    final map = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    final TextPost? text = (map['type'] == postTypeText)
                        ? TextPost.fromMap(map)
                        : null;
                    final ImagePost? image = (map['type'] == postTypeImage)
                        ? ImagePost.fromMap(map)
                        : null;

                    return GestureDetector(
                      onTap: () {
                        // Navigate
                        Navigator.push(
                          context,
                          navigatorTo(
                            context: context,
                            screen: ProfilePostPage(
                              type: type,
                              userId: userId,
                              postIndex: index,
                            ),
                          ),
                        );
                      },
                      child: CardProfileComponentBottomWidget(
                        image: image,
                        text: text,
                      ),
                    );
                  },
                ).toList())
            : Center(
                child: Text(
                  "Empty Post",
                  style: medium14(colorThird),
                ),
              );
      },
    );
  }
}
