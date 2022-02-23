import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class PostSearchResultWidget extends StatelessWidget {
  const PostSearchResultWidget({
    Key? key,
    required this.yourId,
  }) : super(key: key);
  final String yourId;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SearchBloc, SearchValue, String?>(
      selector: (state) {
        return state.search;
      },
      builder: (context, state) {
        return (state == null || state == "")
            ? Center(
                child: Text(
                  "Find Post",
                  style: medium14(colorThird),
                ),
              )
            : StreamBuilder<QuerySnapshot>(
                stream: firestoreUser.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text(
                        "Loading...",
                        style: medium14(colorThird),
                      ),
                    );
                  } else {
                    final result = snapshot.data!.docs.where((data) {
                      final User user =
                          User.fromMap(data.data() as Map<String, dynamic>);
                      final DataProfile dataProfile =
                          DataProfile.fromMap(user.dataProfile!);

                      return dataProfile.username!
                          .toLowerCase()
                          .contains(state.toLowerCase());
                    });

                    return (result.isEmpty)
                        ? Center(
                            child: Text(
                              "Not Found",
                              style: medium14(colorThird),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: result.map((doc) {
                                // Object
                                final User user = User.fromMap(
                                    doc.data() as Map<String, dynamic>);
                                final DataProfile dataProfile =
                                    DataProfile.fromMap(user.dataProfile!);

                                return StreamBuilder<QuerySnapshot>(
                                  stream: firestoreUser
                                      .doc(doc.id)
                                      .collection('POST')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const SizedBox();
                                    } else {
                                      return (snapshot.data!.docs.isEmpty)
                                          ? const SizedBox()
                                          : Column(
                                              children: snapshot.data!.docs.map(
                                                (doc) {
                                                  // Object
                                                  final map = doc.data()
                                                      as Map<String, dynamic>;
                                                  final ImagePost? imagePost =
                                                      (map['type'] ==
                                                              postTypeImage)
                                                          ? ImagePost.fromMap(
                                                              map)
                                                          : null;
                                                  final TextPost? textPost =
                                                      (map['type'] ==
                                                              postTypeText)
                                                          ? TextPost.fromMap(
                                                              map)
                                                          : null;

                                                  return CardPostSearchResultWidget(
                                                    username:
                                                        dataProfile.username!,
                                                    postId: doc.id,
                                                    textPost: textPost,
                                                    imagePost: imagePost,
                                                    yourId: yourId,
                                                    forHistory: false,
                                                  );
                                                },
                                              ).toList(),
                                            );
                                    }
                                  },
                                );
                              }).toList(),
                            ),
                          );
                  }
                },
              );
      },
    );
  }
}
