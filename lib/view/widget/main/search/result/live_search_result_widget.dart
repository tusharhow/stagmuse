import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class LiveSearchResultWidget extends StatelessWidget {
  const LiveSearchResultWidget({
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
                  "Find Live Event",
                  style: medium14(colorThird),
                ),
              )
            : StreamBuilder<QuerySnapshot>(
                stream: firestoreLive.snapshots(),
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
                      final Live live =
                          Live.fromMap(data.data() as Map<String, dynamic>);

                      return live.name!
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
                              children: result.map(
                                (doc) {
                                  final Live live = Live.fromMap(
                                      doc.data() as Map<String, dynamic>);

                                  return CardLiveSearchResultWidget(
                                    liveId: doc.id,
                                    live: live,
                                    yourId: yourId,
                                    forHistory: false,
                                  );
                                },
                              ).toList(),
                            ),
                          );
                  }
                },
              );
      },
    );
  }
}
