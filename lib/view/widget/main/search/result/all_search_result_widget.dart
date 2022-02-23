import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/widget/main/search/card_search_widget.dart';

class AllSearchResultWidget extends StatelessWidget {
  const AllSearchResultWidget({
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
                  "Find All",
                  style: medium14(colorThird),
                ),
              )
            : StreamBuilder<QuerySnapshot>(
                stream: firestoreAll.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text(
                        "Loading...",
                        style: medium14(colorThird),
                      ),
                    );
                  } else {
                    return SingleChildScrollView(
                      child: Column(
                          children: snapshot.data!.docs.map((doc) {
                        // Map
                        final map = doc.data() as Map<String, dynamic>;

                        return (map['type'] == searchTypeAccount)
                            ? StreamBuilder<DocumentSnapshot>(
                                stream: firestoreUser
                                    .doc(map['user id'])
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const SizedBox();
                                  } else {
                                    final User user = User.fromMap(
                                        snapshot.data!.data()
                                            as Map<String, dynamic>);
                                    final DataProfile dataProfile =
                                        DataProfile.fromMap(user.dataProfile!);

                                    return (dataProfile.username!
                                            .toLowerCase()
                                            .contains(state.toLowerCase()))
                                        ? CardAccountSearchResultWidget(
                                            dataProfile: dataProfile,
                                            forHistory: false,
                                            yourId: yourId,
                                            userId: snapshot.data!.id,
                                          )
                                        : const SizedBox();
                                  }
                                },
                              )
                            : StreamBuilder<DocumentSnapshot>(
                                stream: firestoreLive
                                    .doc(map['live id'])
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const SizedBox();
                                  } else {
                                    if (snapshot.data!.exists) {
                                      final Live live = Live.fromMap(
                                          snapshot.data!.data()
                                              as Map<String, dynamic>);

                                      return (live.name!
                                              .toLowerCase()
                                              .contains(state.toLowerCase()))
                                          ? CardLiveSearchResultWidget(
                                              liveId: snapshot.data!.id,
                                              live: live,
                                              yourId: yourId,
                                              forHistory: false,
                                            )
                                          : const SizedBox();
                                    } else {
                                      // Delete
                                      searchDatabaseServices.deleteLive(
                                        snapshot.data!.id,
                                      );

                                      return const SizedBox();
                                    }
                                  }
                                },
                              );
                      }).toList()),
                    );
                  }
                },
              );
      },
    );
  }
}
