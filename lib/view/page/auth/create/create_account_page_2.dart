import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class CreateAccountPage2 extends StatefulWidget {
  const CreateAccountPage2({
    Key? key,
    required this.username,
  }) : super(key: key);
  final String username;

  @override
  _CreateAccountPage2State createState() => _CreateAccountPage2State();
}

class _CreateAccountPage2State extends State<CreateAccountPage2> {
  // Controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _noController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Bloc
    final _profileBloc = context.read<ProfileBloc>();

    // Update Bloc
    _profileBloc.add(const SetProfile(null));
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _birthController.dispose();
    _noController.dispose();
    _emailController.dispose();
    _pwController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Bloc
    final _imageBloc = context.read<ProfileBloc>();
    final _backEndResponseBloc = context.read<BackendResponseBloc>();

    final String username = widget.username;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Custom.back, color: colorThird),
        ),
        title: Text(
          "Create account",
          style: medium22(colorThird),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(gambarSignUp),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: margin),
          width: double.infinity,
          height: double.infinity,
          color: colorPrimary.withOpacity(0.2),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 24 + kToolbarHeight + 24),
                // Photo Profile
                SizedBox(
                  width: 140,
                  height: 140,
                  child: Stack(
                    children: [
                      // Icon
                      BlocSelector<ProfileBloc, ProfileValue, ImageData?>(
                        selector: (state) {
                          return state.image;
                        },
                        builder: (context, state) {
                          return (state == null)
                              ? photoProfileAuthWidget(null)
                              : FutureBuilder<Uint8List?>(
                                  future: state.dataLocal,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return photoProfileAuthWidget(null);
                                    }
                                    return photoProfileAuthWidget(
                                        snapshot.data);
                                  },
                                );
                        },
                      ),
                      // Button
                      GestureDetector(
                        onTap: () {
                          // Show Bottom
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            context: context,
                            builder: (context) {
                              return AuthTypePickProfileWidget(
                                username: username,
                              );
                            },
                          );
                        },
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(
                              color: colorPrimary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Form
                // Name
                textFormFieldFill(
                  controller: _nameController,
                  keyboardType: TextInputType.emailAddress,
                  style: semiBold14(colorThird),
                  hintText: "Name",
                  onTap: null,
                  fillColor: colorSecondary.withOpacity(0.3),
                  prefix: const Icon(Custom.userOutline, color: Colors.white),
                  leftMargin: 0,
                  topMargin: 82,
                  rightMargin: 0,
                  bottomMargin: 0,
                ),
                // Birthdate
                textFormFieldFill(
                  controller: _birthController,
                  keyboardType: TextInputType.emailAddress,
                  style: semiBold14(colorThird),
                  hintText: "Birthdate",
                  onTap: () async {
                    await TimeServices.selectDate(
                            context: context, tanggal: null)
                        .then((value) {
                      if (value != null) {
                        // Update Birthdate Controller
                        _birthController.text = value;
                      }
                    });
                  },
                  fillColor: colorSecondary.withOpacity(0.3),
                  prefix: const Icon(Icons.child_care, color: Colors.white),
                  leftMargin: 0,
                  topMargin: 16,
                  rightMargin: 0,
                  bottomMargin: 0,
                ),
                // No
                textFormFieldFill(
                  controller: _noController,
                  keyboardType: TextInputType.phone,
                  style: semiBold14(colorThird),
                  hintText: "Phone Number",
                  onTap: null,
                  fillColor: colorSecondary.withOpacity(0.3),
                  prefix: const Icon(Icons.call, color: Colors.white),
                  leftMargin: 0,
                  topMargin: 16,
                  rightMargin: 0,
                  bottomMargin: 0,
                ),
                // Email
                textFormFieldFill(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: semiBold14(colorThird),
                  hintText: "Email",
                  onTap: null,
                  fillColor: colorSecondary.withOpacity(0.3),
                  prefix: const Icon(Icons.email, color: Colors.white),
                  leftMargin: 0,
                  topMargin: 16,
                  rightMargin: 0,
                  bottomMargin: 0,
                ),
                // Password
                textFormFieldFill(
                  controller: _pwController,
                  keyboardType: TextInputType.visiblePassword,
                  obscure: true,
                  style: semiBold14(colorThird),
                  hintText: "Password",
                  onTap: null,
                  fillColor: colorSecondary.withOpacity(0.3),
                  prefix: const Icon(Icons.lock, color: Colors.white),
                  leftMargin: 0,
                  topMargin: 16,
                  rightMargin: 0,
                  bottomMargin: 0,
                ),
                // Button Send
                BlocSelector<BackendResponseBloc, BackendResponseValue,
                    BackendResponseValue>(
                  selector: (state) {
                    return state;
                  },
                  builder: (context, state) {
                    return flatTextButton(
                      onPress: () {
                        if (_nameController.text.isNotEmpty &&
                            _birthController.text.isNotEmpty &&
                            _emailController.text.isNotEmpty &&
                            _pwController.text.isNotEmpty) {
                          // Date Variable
                          final DateTime birthdate = DateFormat("yyyy-mm-dd")
                              .parse(_birthController.text);
                          final DateTime adultDate = DateTime(
                              birthdate.year + 17,
                              birthdate.month,
                              birthdate.day);
                          // Check Age
                          if (adultDate.compareTo(DateTime.now()) <= 0) {
                            authServices
                                .signUp(
                                    email: _emailController.text,
                                    password: _pwController.text,
                                    context: context)
                                .then((response) {
                              // Update Bloc
                              _backEndResponseBloc.add(
                                const SetBackendResponse(
                                  BackEndResponse(
                                    BackEndStatus.loading,
                                  ),
                                ),
                              );
                              // If Success
                              if (response.message == null) {
                                // If profile not null
                                if (_imageBloc.state.image != null) {
                                  // Store photo file to firebase storage
                                  FirebaseStorageServices.setProfile(
                                          username: username,
                                          pickedFile:
                                              _imageBloc.state.image!.file)
                                      .then((url) {
                                    // Add Firestore Data
                                    dataProfileServices
                                        .addUser(
                                      userId: response.user!.user!.uid,
                                      photo: url,
                                      username: username,
                                      name: _nameController.text,
                                      bio: null,
                                      birthdate: _birthController.text,
                                      email: _emailController.text,
                                      phoneNumber: _noController.text,
                                    )
                                        .then((_) {
                                      // Add firebase all
                                      searchDatabaseServices
                                          .addAccount(response.user!.user!.uid);

                                      // Update Bloc
                                      _backEndResponseBloc.add(
                                        const SetBackendResponse(
                                          BackEndResponse(
                                            BackEndStatus.success,
                                          ),
                                        ),
                                      );
                                      // Show Dialog
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return generalDialog(
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: margin,
                                                      vertical: 30),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
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
                                                    "Your account has been success created.You can sign in now!",
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
                                  });
                                } else {
                                  // Add Firestore Data
                                  dataProfileServices
                                      .addUser(
                                    userId: response.user!.user!.uid,
                                    photo: null,
                                    username: username,
                                    name: _nameController.text,
                                    bio: null,
                                    birthdate: _birthController.text,
                                    email: _emailController.text,
                                    phoneNumber: _noController.text,
                                  )
                                      .then((_) {
                                    // Add firebase all
                                    searchDatabaseServices
                                        .addAccount(response.user!.user!.uid);
                                    // Update Bloc
                                    _backEndResponseBloc.add(
                                      const SetBackendResponse(
                                        BackEndResponse(
                                          BackEndStatus.success,
                                        ),
                                      ),
                                    );
                                    // Show Dialog
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return generalDialog(
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: margin,
                                                vertical: 30),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                  "Your account has been success created.You can sign in now!",
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
                                }
                              }
                              // If Error
                              if (response.message != null) {
                                // Update Bloc
                                _backEndResponseBloc.add(
                                  const SetBackendResponse(
                                    BackEndResponse(
                                      BackEndStatus.error,
                                    ),
                                  ),
                                );
                                // Show snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      response.message!,
                                      style: medium14(colorThird),
                                    ),
                                  ),
                                );
                              }
                            });
                          } else {
                            // Show snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 2),
                                backgroundColor: Colors.red,
                                content: Text(
                                  "You must be at least 17 years old!",
                                  style: medium14(colorThird),
                                ),
                              ),
                            );
                          }
                        } else {
                          // Show snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 2),
                              backgroundColor: Colors.red,
                              content: RichText(
                                text: TextSpan(
                                  text: "You haven't filled out your ",
                                  style: medium12(colorThird),
                                  children: [
                                    TextSpan(
                                      text: "NAME",
                                      style: bold12(colorThird),
                                    ),
                                    TextSpan(
                                      text: ",",
                                      style: medium12(colorThird),
                                    ),
                                    TextSpan(
                                      text: "BIRTHDATE",
                                      style: bold12(colorThird),
                                    ),
                                    TextSpan(
                                      text: ",",
                                      style: medium12(colorThird),
                                    ),
                                    TextSpan(
                                      text: "EMAIL",
                                      style: bold12(colorThird),
                                    ),
                                    TextSpan(
                                      text: ",",
                                      style: medium12(colorThird),
                                    ),
                                    TextSpan(
                                      text: "PASSWORD",
                                      style: bold12(colorThird),
                                    ),
                                    TextSpan(
                                      text: "!",
                                      style: medium12(colorThird),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      text: (state.response.status == BackEndStatus.loading)
                          ? "Loading..."
                          : "Registration",
                      textColor: colorThird,
                      buttonColor: colorPrimary,
                      leftMargin: 0,
                      rightMargin: 0,
                      topMargin: 48,
                      bottomMargin: 0,
                      width: double.infinity,
                      height: null,
                    );
                  },
                ),
                flatTextButton(
                  onPress: () {
                    // Navigate
                    Navigator.pushAndRemoveUntil(
                        context,
                        navigatorTo(
                          context: context,
                          screen: const LandingPage(),
                        ),
                        (route) => false);
                  },
                  text: "Login",
                  textColor: colorPrimary,
                  buttonColor: colorThird,
                  leftMargin: 0,
                  rightMargin: 0,
                  topMargin: 16,
                  bottomMargin: 24,
                  width: double.infinity,
                  height: null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
