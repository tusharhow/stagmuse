import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({
    Key? key,
    required this.yourId,
  }) : super(key: key);
  final String yourId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: const Text("Chats"),
        centerTitle: true,
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
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreUser.doc(yourId).collection('CHAT').snapshots(),
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
              ? SingleChildScrollView(
                  child: Column(
                    children: snapshot.data!.docs.map(
                      (doc) {
                        return CardChatListWidget(
                          userId: doc.id,
                          yourId: yourId,
                        );
                      },
                    ).toList(),
                  ),
                )
              : Center(
                  child: Text(
                    "Empty Chat",
                    style: medium14(colorThird),
                  ),
                );
        },
      ),
    );
  }
}
