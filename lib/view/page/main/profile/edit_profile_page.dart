import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/view/export_view.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    Key? key,
    required this.userId,
  }) : super(key: key);
  final String userId;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Controller
  final _emailController = TextEditingController();
  final _noController = TextEditingController();
  final _birthController = TextEditingController();
  final _userController = TextEditingController();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Bloc
    final _editBloc = context.read<EditProfileBloc>();

    // Update Initial Value
    firestoreUser.doc(widget.userId).get().then((doc) {
      // Object
      final User user = User.fromMap(doc.data() as Map<String, dynamic>);
      final DataProfile dataProfile = DataProfile.fromMap(user.dataProfile!);

      _userController.text = "${dataProfile.username}";
      _nameController.text = "${dataProfile.name}";
      _bioController.text = dataProfile.bio ?? "";
      _noController.text = "${dataProfile.phoneNumber}";

      // Update Bloc
      _editBloc.add(
        SetEditProfile(
          userNameEmpty: _editBloc.state.userNameEmpty,
          nameEmpty: _editBloc.state.nameEmpty,
          bioEmpty: _editBloc.state.bioEmpty,
          privateAccount: user.privateAccount!, // Update
        ),
      );
    });

    // User name
    _userController.addListener(() {
      if (_userController.text.isNotEmpty) {
        if (_editBloc.state.userNameEmpty) {
          // Update Bloc
          _editBloc.add(
            SetEditProfile(
              userNameEmpty: false, // Update
              nameEmpty: _editBloc.state.nameEmpty,
              bioEmpty: _editBloc.state.bioEmpty,
              privateAccount: _editBloc.state.privateAccount,
            ),
          );
        }
      }
      if (_userController.text.isEmpty) {
        if (!_editBloc.state.userNameEmpty) {
          // Update Bloc
          _editBloc.add(
            SetEditProfile(
              userNameEmpty: true, // Update
              nameEmpty: _editBloc.state.nameEmpty,
              bioEmpty: _editBloc.state.bioEmpty,
              privateAccount: _editBloc.state.privateAccount,
            ),
          );
        }
      }
    });

    // Name
    _nameController.addListener(() {
      if (_nameController.text.isNotEmpty) {
        if (_editBloc.state.nameEmpty) {
          // Update Bloc
          _editBloc.add(
            SetEditProfile(
              userNameEmpty: _editBloc.state.nameEmpty,
              nameEmpty: false, // Update
              bioEmpty: _editBloc.state.bioEmpty,
              privateAccount: _editBloc.state.privateAccount,
            ),
          );
        }
      }
      if (_nameController.text.isEmpty) {
        if (!_editBloc.state.nameEmpty) {
          // Update Bloc
          _editBloc.add(
            SetEditProfile(
              userNameEmpty: _editBloc.state.nameEmpty,
              nameEmpty: true, // Update
              bioEmpty: _editBloc.state.bioEmpty,
              privateAccount: _editBloc.state.privateAccount,
            ),
          );
        }
      }
    });

    // Bio
    _bioController.addListener(() {
      if (_bioController.text.isNotEmpty) {
        if (_editBloc.state.bioEmpty) {
          // Update Bloc
          _editBloc.add(
            SetEditProfile(
              userNameEmpty: _editBloc.state.nameEmpty,
              nameEmpty: _editBloc.state.nameEmpty,
              bioEmpty: false, // Update
              privateAccount: _editBloc.state.privateAccount,
            ),
          );
        }
      }
      if (_bioController.text.isEmpty) {
        if (!_editBloc.state.bioEmpty) {
          // Update Bloc
          _editBloc.add(
            SetEditProfile(
              userNameEmpty: _editBloc.state.nameEmpty,
              nameEmpty: _editBloc.state.nameEmpty,
              bioEmpty: true, // Update
              privateAccount: _editBloc.state.privateAccount,
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _noController.dispose();
    _birthController.dispose();
    _userController.dispose();
    _nameController.dispose();
    _bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Bloc
    final _editBloc = context.read<EditProfileBloc>();

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
        title: const Text("Edit Profile"),
        actions: [
          GestureDetector(
            onTap: () async {
              if (_userController.text.isNotEmpty &&
                  _nameController.text.isNotEmpty) {
                await dataProfileServices
                    .updateDataProfile(
                  userId: widget.userId,
                  username: _userController.text,
                  name: _nameController.text,
                  bio: _bioController.text,
                  isPrivateAccount: _editBloc.state.privateAccount,
                )
                    .then((_) {
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
                                "Your data has been success saved",
                                style: medium14(colorThird),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                });
              } else {
                // Show snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.red,
                    content: RichText(
                      text: TextSpan(
                        text: "USER NAME",
                        style: bold12(colorThird),
                        children: [
                          TextSpan(
                            text: " or ",
                            style: medium12(colorThird),
                          ),
                          TextSpan(
                            text: "EMAIL",
                            style: bold12(colorThird),
                          ),
                          TextSpan(
                            text: " cannot be empty ",
                            style: medium12(colorThird),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
            child: const Icon(Icons.check),
          ),
          const SizedBox(width: margin),
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
      body: StreamBuilder<DocumentSnapshot>(
        stream: firestoreUser.doc(widget.userId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                "Loading...",
                style: medium18(colorThird),
              ),
            );
          } else {
            // Object
            final User user =
                User.fromMap(snapshot.data!.data() as Map<String, dynamic>);
            final DataProfile dataProfile =
                DataProfile.fromMap(user.dataProfile!);

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: margin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner Ads
                    (adsServices.bannerAd != null)
                        ? SizedBox(
                            width: adsServices.bannerAd!.size.width.toDouble(),
                            height:
                                adsServices.bannerAd!.size.height.toDouble(),
                            child: AdWidget(ad: adsServices.bannerAd!),
                          )
                        : const SizedBox(),
                    const SizedBox(height: 24),
                    // Photo Profile
                    Center(
                      child: photoProfileNetworkUtils(
                        size: 100,
                        url: dataProfile.photo,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Button Replace Photo
                    GestureDetector(
                      onTap: () {
                        // Show Modal Bottom
                        showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          context: context,
                          builder: (context) {
                            return SetProfilePhotoWidget(
                              userId: widget.userId,
                              username: dataProfile.username,
                              url: dataProfile.photo,
                            );
                          },
                        );
                      },
                      child: Center(
                        child: Text(
                          "Replace Photo Profile",
                          style: medium18(colorPrimary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Permanent Data
                    Text("Permanent", style: semiBold18(colorThird)),
                    // Email
                    underlineTextField(
                      enabled: false,
                      controller: _emailController..text = dataProfile.email!,
                      keyboardType: TextInputType.emailAddress,
                      style: regular12(colorThird),
                      labelText: "Email",
                      labelStyle: regular12(Colors.grey),
                      colorUnderline: colorThird,
                      leftMargin: 0,
                      topMargin: 16,
                      rightMargin: 0,
                      bottomMargin: 0,
                    ),
                    // Birthdate
                    underlineTextField(
                      enabled: false,
                      controller: _birthController
                        ..text = handlingTimeMonthDayYearUtils(
                            dataProfile.birthdate!),
                      keyboardType: TextInputType.emailAddress,
                      style: regular12(colorThird),
                      labelText: "Birthdate",
                      labelStyle: regular12(Colors.grey),
                      colorUnderline: colorThird,
                      leftMargin: 0,
                      topMargin: 16,
                      rightMargin: 0,
                      bottomMargin: 36,
                    ),
                    // Editable Data
                    Text("Editable", style: semiBold18(colorThird)),
                    BlocSelector<EditProfileBloc, EditProfileValue,
                        EditProfileValue>(
                      selector: (state) => state,
                      builder: (_, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // User name
                            underlineTextField(
                              enabled: true,
                              controller: _userController,
                              keyboardType: TextInputType.text,
                              style: regular12(colorThird),
                              labelText: "User name",
                              labelStyle: regular12(Colors.grey),
                              suffix: (state.userNameEmpty)
                                  ? null
                                  : GestureDetector(
                                      onTap: () {
                                        _userController.clear();
                                      },
                                      child: const Icon(Icons.clear,
                                          color: Colors.grey),
                                    ),
                              colorUnderline: colorThird,
                              leftMargin: 0,
                              topMargin: 16,
                              rightMargin: 0,
                              bottomMargin: 0,
                            ),
                            // Name
                            underlineTextField(
                              enabled: true,
                              controller: _nameController,
                              keyboardType: TextInputType.text,
                              style: regular12(colorThird),
                              labelText: "Name",
                              labelStyle: regular12(Colors.grey),
                              suffix: (state.nameEmpty)
                                  ? null
                                  : GestureDetector(
                                      onTap: () {
                                        _nameController.clear();
                                      },
                                      child: const Icon(Icons.clear,
                                          color: Colors.grey),
                                    ),
                              colorUnderline: colorThird,
                              leftMargin: 0,
                              topMargin: 16,
                              rightMargin: 0,
                              bottomMargin: 0,
                            ),
                            // Bio
                            underlineTextField(
                              enabled: true,
                              maxLength: 100,
                              controller: _bioController,
                              keyboardType: TextInputType.name,
                              style: regular12(colorThird),
                              labelText: "Bio",
                              labelStyle: regular12(Colors.grey),
                              suffix: (state.bioEmpty)
                                  ? null
                                  : GestureDetector(
                                      onTap: () {
                                        _bioController.clear();
                                      },
                                      child: const Icon(Icons.clear,
                                          color: Colors.grey),
                                    ),
                              colorUnderline: colorThird,
                              leftMargin: 0,
                              topMargin: 16,
                              rightMargin: 0,
                              bottomMargin: 0,
                            ),
                            // No
                            underlineTextField(
                              enabled: true,
                              maxLength: 100,
                              controller: _noController,
                              keyboardType: TextInputType.number,
                              style: regular12(colorThird),
                              labelText: "Phone Number",
                              labelStyle: regular12(Colors.grey),
                              suffix: (state.bioEmpty)
                                  ? null
                                  : GestureDetector(
                                      onTap: () {
                                        _noController.clear();
                                      },
                                      child: const Icon(
                                        Icons.clear,
                                        color: Colors.grey,
                                      ),
                                    ),
                              colorUnderline: colorThird,
                              leftMargin: 0,
                              topMargin: 16,
                              rightMargin: 0,
                              bottomMargin: 0,
                            ),
                            // Private Account
                            const SizedBox(height: 16),
                            Text("Private Account",
                                style: semiBold14(colorThird)),
                            Row(
                              children: [
                                // Swatch
                                Switch(
                                  value: state.privateAccount,
                                  onChanged: (value) {
                                    // Update Bloc
                                    _editBloc.add(
                                      SetEditProfile(
                                        userNameEmpty: state.userNameEmpty,
                                        nameEmpty: state.nameEmpty,
                                        bioEmpty: state.bioEmpty,
                                        privateAccount: value, // Update
                                      ),
                                    );
                                  },
                                  activeColor: colorPrimary,
                                  inactiveThumbColor:
                                      colorPrimary.withOpacity(0.3),
                                  inactiveTrackColor:
                                      colorPrimary.withOpacity(0.2),
                                ),
                                // Text
                                Text(
                                  (state.privateAccount)
                                      ? "Your account is private"
                                      : "Your account is not private",
                                  style: regular12(colorThird),
                                ),
                              ],
                            ),
                            const SizedBox(height: 36),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
