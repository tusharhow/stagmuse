import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

enum ProfileLiveType { own, other }

class ProfileLivePage extends StatelessWidget {
  const ProfileLivePage({
    Key? key,
    required this.liveId,
    required this.yourId,
    required this.isCreate,
    required this.isEdit,
    required this.type,
  }) : super(key: key);
  final String yourId, liveId;
  final bool isCreate, isEdit;
  final ProfileLiveType type;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.black.withOpacity(0.3),
      ),
      child: BlocSelector<LiveEventBloc, LiveEventProgressValue, Live?>(
        selector: (state) {
          return state.live;
        },
        builder: (context, state) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            body: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: (isCreate)
                  ? Stack(
                      children: [
                        // Image
                        Align(
                          alignment: Alignment.topCenter,
                          child: BlocSelector<LiveImageBloc, LiveImageValue,
                              XFile>(
                            selector: (state) {
                              return state.cover!;
                            },
                            builder: (context, state) {
                              return FutureBuilder<Uint8List>(
                                future: state.readAsBytes(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const SizedBox();
                                  }
                                  return Container(
                                    padding: const EdgeInsets.only(
                                        left: margin, top: 48),
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                            1 /
                                            3 +
                                        24,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: MemoryImage(snapshot.data!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: colorPrimary,
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.clear,
                                              color: colorThird,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        // Content
                        SlidingUpPanel(
                            parallaxEnabled: true,
                            minHeight: MediaQuery.of(context).size.height -
                                MediaQuery.of(context).size.height * 1 / 3 +
                                48,
                            maxHeight: MediaQuery.of(context).size.height - 64,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            color: Colors.transparent,
                            boxShadow: null,
                            panel: Stack(
                              children: [
                                // Content || Button
                                Column(
                                  children: [
                                    // Content
                                    Flexible(
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 24),
                                        padding: const EdgeInsets.fromLTRB(
                                          margin,
                                          margin,
                                          margin,
                                          0,
                                        ),
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30),
                                          ),
                                          color: colorBackground,
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 24),
                                              // Title
                                              Text(
                                                state!.name!,
                                                style: semiBold24(colorThird),
                                              ),
                                              // Time || Status
                                              RichText(
                                                text: TextSpan(
                                                  text: state.date!,
                                                  style: regular12(Colors.grey),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          " - ${state.time} - ",
                                                      style: regular12(
                                                          Colors.grey),
                                                    ),
                                                    TextSpan(
                                                      text: state.status,
                                                      style: regular12(
                                                          colorPrimary),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Description
                                              const SizedBox(height: 36),
                                              Text(
                                                state.description!,
                                                style: regular14(colorThird),
                                              ),
                                              // Other Image
                                              const SizedBox(height: 16),
                                              BlocSelector<LiveImageBloc,
                                                  LiveImageValue, List<XFile>>(
                                                selector: (state) {
                                                  return state.images;
                                                },
                                                builder: (context, state) {
                                                  return SizedBox(
                                                    width: double.infinity,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            1 /
                                                            4,
                                                    child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: state.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final memory =
                                                            state[index];

                                                        return FutureBuilder<
                                                            Uint8List>(
                                                          future: memory
                                                              .readAsBytes(),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (!snapshot
                                                                .hasData) {
                                                              return const SizedBox();
                                                            }
                                                            return cardMoreImageProfileLiveWidget(
                                                              memory: snapshot
                                                                  .data!,
                                                              network: null,
                                                              index: index,
                                                              lastIndex: 9,
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Button
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 0.5,
                                            width: double.infinity,
                                            color: colorPrimary,
                                          ),
                                          // Button
                                          ButtonProfileLive(
                                            liveId: liveId,
                                            live: Live(),
                                            isCreate: isCreate,
                                            isEdit: isEdit,
                                            type: type,
                                            yourId: yourId,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                // Button Play
                                GestureDetector(
                                  onTap: () {},
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: const BoxDecoration(
                                        color: colorPrimary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Custom.play,
                                          color: colorThird),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    )
                  : (isEdit)
                      ? StreamBuilder<DocumentSnapshot>(
                          stream: firestoreLive.doc(liveId).snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: Text(
                                  "Loading...",
                                  style: medium14(colorThird),
                                ),
                              );
                            } else {
                              // Object
                              final Live live = Live.fromMap(
                                snapshot.data!.data() as Map<String, dynamic>,
                              );

                              return Stack(
                                children: [
                                  // Image
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: margin, top: 48),
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                                  1 /
                                                  3 +
                                              24,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(live.cover!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            width: 36,
                                            height: 36,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: colorPrimary,
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.clear,
                                                color: colorThird,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Content
                                  SlidingUpPanel(
                                    parallaxEnabled: true,
                                    minHeight:
                                        MediaQuery.of(context).size.height -
                                            MediaQuery.of(context).size.height *
                                                1 /
                                                3 +
                                            48,
                                    maxHeight:
                                        MediaQuery.of(context).size.height - 64,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                                    color: Colors.transparent,
                                    boxShadow: null,
                                    panel: Stack(
                                      children: [
                                        // Content || Button
                                        Column(
                                          children: [
                                            // Content
                                            Flexible(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    top: 24),
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                  margin,
                                                  margin,
                                                  margin,
                                                  0,
                                                ),
                                                width: double.infinity,
                                                height: double.infinity,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30),
                                                    topRight:
                                                        Radius.circular(30),
                                                  ),
                                                  color: colorBackground,
                                                ),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                          height: 24),
                                                      // Title
                                                      Text(
                                                        state!.name!,
                                                        style: semiBold24(
                                                            colorThird),
                                                      ),
                                                      // Time || Status
                                                      RichText(
                                                        text: TextSpan(
                                                          text:
                                                              handlingTimeMonthDayYearUtils(
                                                            state.date!,
                                                          ),
                                                          style: regular12(
                                                              Colors.grey),
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  " - ${state.time} - ",
                                                              style: regular12(
                                                                  Colors.grey),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  state.status,
                                                              style: regular12(
                                                                  colorPrimary),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // Description
                                                      const SizedBox(
                                                          height: 36),
                                                      Text(
                                                        state.description!,
                                                        style: regular14(
                                                            colorThird),
                                                      ),
                                                      // Other Image
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
                                                      (live.images!.isNotEmpty)
                                                          ? SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  1 /
                                                                  4,
                                                              child: ListView
                                                                  .builder(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                itemCount: live
                                                                    .images!
                                                                    .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  final url =
                                                                      live.images![
                                                                          index];

                                                                  return cardMoreImageProfileLiveWidget(
                                                                    memory:
                                                                        null,
                                                                    network:
                                                                        url,
                                                                    index:
                                                                        index,
                                                                    lastIndex:
                                                                        9,
                                                                  );
                                                                },
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Button
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    height: 0.5,
                                                    width: double.infinity,
                                                    color: colorPrimary,
                                                  ),
                                                  // Button
                                                  ButtonProfileLive(
                                                    liveId: liveId,
                                                    live: live,
                                                    isCreate: isCreate,
                                                    isEdit: isEdit,
                                                    type: type,
                                                    yourId: yourId,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Button Play
                                        GestureDetector(
                                          onTap: () {},
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Container(
                                              width: 48,
                                              height: 48,
                                              decoration: const BoxDecoration(
                                                color: colorPrimary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(Custom.play,
                                                  color: colorThird),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        )
                      : StreamBuilder<DocumentSnapshot>(
                          stream: firestoreLive.doc(liveId).snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: Text(
                                  "Loading...",
                                  style: medium14(colorThird),
                                ),
                              );
                            } else {
                              // Object
                              final Live live = Live.fromMap(snapshot.data!
                                  .data() as Map<String, dynamic>);

                              return Stack(
                                children: [
                                  // Image
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: margin, top: 48),
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                                  1 /
                                                  3 +
                                              24,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(live.cover!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            width: 36,
                                            height: 36,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: colorPrimary,
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.clear,
                                                color: colorThird,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Content
                                  SlidingUpPanel(
                                    parallaxEnabled: true,
                                    minHeight:
                                        MediaQuery.of(context).size.height -
                                            MediaQuery.of(context).size.height *
                                                1 /
                                                3 +
                                            48,
                                    maxHeight:
                                        MediaQuery.of(context).size.height - 64,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                                    color: Colors.transparent,
                                    boxShadow: null,
                                    panel: Stack(
                                      children: [
                                        // Content || Button
                                        Column(
                                          children: [
                                            // Content
                                            Flexible(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    top: 24),
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                  margin,
                                                  margin,
                                                  margin,
                                                  0,
                                                ),
                                                width: double.infinity,
                                                height: double.infinity,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30),
                                                    topRight:
                                                        Radius.circular(30),
                                                  ),
                                                  color: colorBackground,
                                                ),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      // Title
                                                      Text(
                                                        live.name!,
                                                        style: semiBold24(
                                                            colorThird),
                                                      ),
                                                      // Time || Status
                                                      RichText(
                                                        text: TextSpan(
                                                          text:
                                                              handlingTimeMonthDayYearUtils(
                                                            live.date!,
                                                          ),
                                                          style: regular12(
                                                              Colors.grey),
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  " - ${live.time} - ",
                                                              style: regular12(
                                                                  Colors.grey),
                                                            ),
                                                            TextSpan(
                                                              text: live.time!,
                                                              style: regular12(
                                                                  colorPrimary),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // Description
                                                      const SizedBox(
                                                        height: 36,
                                                      ),
                                                      Text(
                                                        live.description!,
                                                        style: regular14(
                                                            colorThird),
                                                      ),
                                                      // Other Image
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
                                                      (live.images!.isNotEmpty)
                                                          ? SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  1 /
                                                                  4,
                                                              child: ListView
                                                                  .builder(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                itemCount: live
                                                                    .images!
                                                                    .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  final url =
                                                                      live.images![
                                                                          index];

                                                                  return cardMoreImageProfileLiveWidget(
                                                                    memory:
                                                                        null,
                                                                    network:
                                                                        url,
                                                                    index:
                                                                        index,
                                                                    lastIndex:
                                                                        9,
                                                                  );
                                                                },
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Button
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    height: 0.5,
                                                    width: double.infinity,
                                                    color: colorPrimary,
                                                  ),
                                                  // Button
                                                  ButtonProfileLive(
                                                    liveId: liveId,
                                                    live: live,
                                                    isCreate: isCreate,
                                                    isEdit: isEdit,
                                                    type: type,
                                                    yourId: yourId,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Button Play
                                        GestureDetector(
                                          onTap: () {},
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Container(
                                              width: 48,
                                              height: 48,
                                              decoration: const BoxDecoration(
                                                color: colorPrimary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(Custom.play,
                                                  color: colorThird),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
            ),
          );
        },
      ),
    );
  }
}
