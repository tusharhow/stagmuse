import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

enum ProfileLiveEventType { create, edit }

class ProfileCreateEditLiveEventPage extends StatefulWidget {
  const ProfileCreateEditLiveEventPage({
    Key? key,
    required this.liveId,
    required this.yourId,
    required this.type,
    required this.live,
  }) : super(key: key);
  final String yourId, liveId;
  final ProfileLiveEventType type;
  final Live live;

  const ProfileCreateEditLiveEventPage.create({
    Key? key,
    this.liveId = "",
    required this.yourId,
    required this.live,
    this.type = ProfileLiveEventType.create,
  }) : super(key: key);

  const ProfileCreateEditLiveEventPage.edit({
    Key? key,
    required this.liveId,
    required this.yourId,
    required this.live,
    this.type = ProfileLiveEventType.edit,
  }) : super(key: key);

  @override
  _ProfileCreateEditLiveEventPageState createState() =>
      _ProfileCreateEditLiveEventPageState();
}

class _ProfileCreateEditLiveEventPageState
    extends State<ProfileCreateEditLiveEventPage> {
  // Controller
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    // Bloc
    final _progressBloc = context.read<LiveEventBloc>();
    final _liveImage = context.read<LiveImageBloc>();
    super.initState();

    // Update bloc
    _liveImage.add(
      SetLiveImage(
        cover: null,
        images: [],
      ),
    );
    if (widget.type == ProfileLiveEventType.edit) {
      // Update Progress
      _progressBloc.add(const SetLiveEventProgress(live: null, value: 5));

      // TextField
      _nameController.text = widget.live.name!;
      _dateController.text = widget.live.date!;
      _timeController.text = widget.live.time!;
      _descriptionController.text = widget.live.description!;
    } else {
      // Update Progress
      _progressBloc.add(const SetLiveEventProgress(live: null, value: 0));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Bloc
    final _progressBloc = context.read<LiveEventBloc>();
    final _liveImage = context.watch<LiveImageBloc>();
    final _backEndBloc = context.read<BackendResponseBloc>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: BlocSelector<BackendResponseBloc,
          BackendResponseValue, BackEndStatus>(
        selector: (state) {
          return state.response.status;
        },
        builder: (context, state) {
          return (widget.type == ProfileLiveEventType.create)
              ? FloatingActionButton.extended(
                  onPressed: () async {
                    if (_nameController.text.isNotEmpty &&
                        _dateController.text.isNotEmpty &&
                        _timeController.text.isNotEmpty &&
                        _descriptionController.text.isNotEmpty &&
                        _liveImage.state.cover != null) {
                      // Update Firestore
                      await liveServices
                          .addLive(
                        onLoading: () {
                          _backEndBloc.add(
                            const SetBackendResponse(
                              BackEndResponse(
                                BackEndStatus.loading,
                              ),
                            ),
                          );
                        },
                        onSuccess: () {
                          _backEndBloc.add(
                            const SetBackendResponse(
                              BackEndResponse(
                                BackEndStatus.success,
                              ),
                            ),
                          );
                        },
                        yourId: widget.yourId,
                        name: _nameController.text,
                        time: _timeController.text,
                        date: _dateController.text,
                        description: _descriptionController.text,
                        provider: widget.yourId,
                      )
                          .whenComplete(
                        () {
                          FirebaseStorageServices.setLiveCover(
                              username: widget.yourId,
                              pickedFile: _liveImage.state.cover!);
                          if (_liveImage.state.images.isNotEmpty) {
                            FirebaseStorageServices.setLiveImage(
                                username: widget.yourId,
                                pickedFile: _liveImage.state.images);
                          }

                          Navigator.pushAndRemoveUntil(
                              context,
                              navigatorTo(
                                context: context,
                                screen: const LandingPage(),
                              ),
                              (route) => false);
                          // Show Dialog
                          showDialog(
                            context: context,
                            builder: (context) {
                              return generalDialog(
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: margin, vertical: 30),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Icon
                                      const Icon(
                                        Icons.check,
                                        color: colorPrimary,
                                        size: 36,
                                      ),
                                      const SizedBox(height: 16),
                                      // Text
                                      Text(
                                        "Your live event has been success created",
                                        style: medium14(colorThird),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(7),
                              ),
                            ),
                            content: Text(
                              "Sorry, your progress must be complete",
                              style: medium14(colorThird),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      );
                    }
                  },
                  label: Text(
                    (state == BackEndStatus.loading) ? "Loading..." : "Publish",
                    style: semiBold14(colorThird),
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  backgroundColor: colorPrimary,
                  elevation: 0,
                )
              : FloatingActionButton.extended(
                  onPressed: () async {
                    if (_nameController.text.isNotEmpty &&
                        _dateController.text.isNotEmpty &&
                        _timeController.text.isNotEmpty &&
                        _descriptionController.text.isNotEmpty &&
                        widget.live.cover != null) {
                      // Update Firestore
                      await liveServices
                          .updateLive(
                        loading: () {
                          _backEndBloc.add(
                            const SetBackendResponse(
                              BackEndResponse(
                                BackEndStatus.loading,
                              ),
                            ),
                          );
                        },
                        success: () {
                          _backEndBloc.add(
                            const SetBackendResponse(
                              BackEndResponse(
                                BackEndStatus.success,
                              ),
                            ),
                          );
                        },
                        liveId: widget.liveId,
                        name: _nameController.text,
                        time: _timeController.text,
                        date: _dateController.text,
                        description: _descriptionController.text,
                      )
                          .whenComplete(
                        () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              navigatorTo(
                                context: context,
                                screen: const LandingPage(),
                              ),
                              (route) => false);
                          // Show Dialog
                          showDialog(
                            context: context,
                            builder: (context) {
                              return generalDialog(
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: margin, vertical: 30),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Icon
                                      const Icon(
                                        Icons.check,
                                        color: colorPrimary,
                                        size: 36,
                                      ),
                                      const SizedBox(height: 16),
                                      // Text
                                      Text(
                                        "Your live event has been success update",
                                        style: medium14(colorThird),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(7),
                              ),
                            ),
                            content: Text(
                              "Sorry, your progress must be complete",
                              style: medium14(colorThird),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      );
                    }
                  },
                  label: Text(
                    (state == BackEndStatus.loading) ? "Loading..." : "Save",
                    style: semiBold14(colorThird),
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  backgroundColor: colorPrimary,
                  elevation: 0,
                );
        },
      ),
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
        title: Text(
          appBarTitleComponentProfileCreateEditLiveEvent(
            widget.type,
          ),
        ),
        actions: [
          // Button Review
          GestureDetector(
            onTap: () {
              if (widget.type == ProfileLiveEventType.create) {
                if (_nameController.text.isNotEmpty &&
                    _dateController.text.isNotEmpty &&
                    _timeController.text.isNotEmpty &&
                    _descriptionController.text.isNotEmpty &&
                    _liveImage.state.cover != null) {
                  // Update Bloc
                  _progressBloc.add(
                    SetLiveEventProgress(
                      live: Live(
                        description: _descriptionController.text,
                        date: _dateController.text,
                        followers: [],
                        name: _nameController.text,
                        provider: widget.yourId,
                        status: liveStatusSoon,
                        time: _timeController.text,
                      ),
                      value: 5.0,
                    ),
                  );
                  // Navigate
                  Navigator.push(
                    context,
                    navigatorTo(
                      context: context,
                      screen: ProfileLivePage(
                        liveId: "",
                        yourId: widget.yourId,
                        type: ProfileLiveType.other,
                        isCreate: (widget.type == ProfileLiveEventType.create)
                            ? true
                            : false,
                        isEdit: (widget.type == ProfileLiveEventType.edit)
                            ? true
                            : false,
                      ),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                        ),
                        content: Text(
                          "Sorry, your progress must be complete",
                          style: medium14(colorThird),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  );
                }
              } else {
                if (_nameController.text.isNotEmpty &&
                    _dateController.text.isNotEmpty &&
                    _timeController.text.isNotEmpty &&
                    _descriptionController.text.isNotEmpty &&
                    widget.live.cover != null) {
                  // Update Bloc
                  _progressBloc.add(
                    SetLiveEventProgress(
                      live: Live(
                        description: _descriptionController.text,
                        date: _dateController.text,
                        followers: [],
                        name: _nameController.text,
                        provider: widget.yourId,
                        status: liveStatusSoon,
                        time: _timeController.text,
                      ),
                      value: 5.0,
                    ),
                  );
                  // Navigate
                  Navigator.push(
                    context,
                    navigatorTo(
                      context: context,
                      screen: ProfileLivePage(
                        liveId: widget.liveId,
                        yourId: widget.yourId,
                        type: ProfileLiveType.other,
                        isCreate: (widget.type == ProfileLiveEventType.create)
                            ? true
                            : false,
                        isEdit: (widget.type == ProfileLiveEventType.edit)
                            ? true
                            : false,
                      ),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                        ),
                        content: Text(
                          "Sorry, your progress must be complete",
                          style: medium14(colorThird),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  );
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: margin),
              child: Row(
                children: [
                  const Icon(Icons.remove_red_eye, color: colorThird),
                  const SizedBox(width: 4),
                  Text(
                    "Review",
                    style: semiBold14(colorThird),
                  ),
                ],
              ),
            ),
          ),
        ],
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(margin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              underlineTextField(
                enabled: true,
                controller: _nameController,
                keyboardType: TextInputType.name,
                style: regular14(colorThird),
                labelText: "Name",
                labelStyle: regular18(Colors.grey),
                colorUnderline: colorThird,
                leftMargin: 0,
                topMargin: 0,
                rightMargin: 0,
                bottomMargin: 0,
              ),
              const SizedBox(height: 16),
              // Date || Time
              Row(
                children: [
                  // Date
                  Expanded(
                    flex: 3,
                    child: underlineTextField(
                      enabled: true,
                      controller: _dateController,
                      keyboardType: TextInputType.datetime,
                      onTap: () async {
                        await TimeServices.selectDate(
                          context: context,
                          tanggal: (widget.type == ProfileLiveEventType.create)
                              ? null
                              : "2021-08-22",
                        ).then((date) {
                          if (date != null) {
                            // Convert
                            final DateTime convert = DateTime.parse(date);

                            if (DateTime.now().compareTo(convert) <= 0) {
                              // Update Controller
                              _dateController.text = date;
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(7),
                                      ),
                                    ),
                                    content: Text(
                                      "Sorry, the date cannot be less than the current date",
                                      style: medium14(colorThird),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                },
                              );
                            }
                          }
                        });
                      },
                      style: regular14(colorThird),
                      labelText: "Date",
                      labelStyle: regular18(Colors.grey),
                      colorUnderline: colorThird,
                      leftMargin: 0,
                      topMargin: 0,
                      rightMargin: 0,
                      bottomMargin: 0,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Time
                  Expanded(
                    flex: 2,
                    child: underlineTextField(
                      enabled: true,
                      controller: _timeController,
                      keyboardType: TextInputType.datetime,
                      onTap: () async {
                        await TimeServices.selectTime(
                          context: context,
                          time: (widget.type == ProfileLiveEventType.create)
                              ? null
                              : "2021-08-22",
                        ).then(
                          (time) {
                            if (time != null) {
                              // Update Controller
                              _timeController.text = time;
                            }
                          },
                        );
                      },
                      style: regular14(colorThird),
                      labelText: "Time",
                      labelStyle: regular18(Colors.grey),
                      colorUnderline: colorThird,
                      leftMargin: 0,
                      topMargin: 0,
                      rightMargin: 0,
                      bottomMargin: 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Description
              underlineTextField(
                enabled: true,
                controller: _descriptionController,
                keyboardType: TextInputType.multiline,
                style: regular14(colorThird),
                labelText: "Description",
                labelStyle: regular18(Colors.grey),
                colorUnderline: colorThird,
                leftMargin: 0,
                topMargin: 0,
                rightMargin: 0,
                bottomMargin: 0,
              ),
              const SizedBox(height: 16),
              // Upload Image
              ListTile(
                onTap: () {
                  // Navigate
                  Navigator.push(
                    context,
                    navigatorTo(
                      context: context,
                      screen: ProfileUploadImageLiveEventPage(
                        yourId: widget.yourId,
                        liveId: widget.liveId,
                        type: widget.type,
                      ),
                    ),
                  );
                },
                contentPadding: const EdgeInsets.all(0),
                title: Text(
                  "Upload Image",
                  style: medium14(colorThird),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 72),
            ],
          ),
        ),
      ),
    );
  }
}
