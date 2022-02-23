import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class CreateAccountPage1 extends StatefulWidget {
  const CreateAccountPage1({Key? key}) : super(key: key);

  @override
  _CreateAccountPage1State createState() => _CreateAccountPage1State();
}

class _CreateAccountPage1State extends State<CreateAccountPage1> {
  // Controller
  final TextEditingController _userNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _userNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Bloc
    final _backEndResponseBloc = context.read<BackendResponseBloc>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Custom.back, color: colorThird),
        ),
        title: const Text(
          "Create account",
          style: TextStyle(color: colorThird),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        // width: double.infinity,
        // height: double.infinity,
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage(gambarSignUp),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: margin),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorSecondary.withOpacity(0.3),
                colorPrimary.withOpacity(0.3),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Form
              // User name
              textFormFieldFill(
                controller: _userNameController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white54, fontSize: 17),
                hintText: "Enter Username",
                onTap: null,
                fillColor: colorSecondary.withOpacity(0.3),
                prefix: const Icon(Custom.userOutline, color: Colors.white54),
                leftMargin: 0,
                topMargin: 0,
                rightMargin: 0,
                bottomMargin: 0,
              ),
              const SizedBox(height: margin / 2),
              // Button Next
              BlocSelector<BackendResponseBloc, BackendResponseValue,
                  BackendResponseValue>(
                selector: (state) {
                  return state;
                },
                builder: (context, state) {
                  return flatTextButton(
                    onPress: () async {
                      if (_userNameController.text.isNotEmpty) {
                        await dataProfileServices.checkUsername(
                          username: _userNameController.text,
                          onValid: () {
                            // Navigate
                            Navigator.push(
                              context,
                              navigatorTo(
                                context: context,
                                screen: CreateAccountPage2(
                                  username: _userNameController.text,
                                ),
                              ),
                            );
                          },
                          onInValid: () {
                            // Show snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 2),
                                backgroundColor: Colors.red,
                                content: Text(
                                  "Username is already in use",
                                  style: medium14(colorThird),
                                ),
                              ),
                            );
                          },
                          updateBlocLoading: () {
                            // Update Bloc
                            _backEndResponseBloc.add(
                              const SetBackendResponse(
                                BackEndResponse(
                                  BackEndStatus.loading,
                                ),
                              ),
                            );
                          },
                          updateBlocSuccess: () {
                            _backEndResponseBloc.add(
                              const SetBackendResponse(
                                BackEndResponse(
                                  BackEndStatus.success,
                                ),
                              ),
                            );
                          },
                          updateBlocError: () {
                            _backEndResponseBloc.add(
                              const SetBackendResponse(
                                BackEndResponse(
                                  BackEndStatus.error,
                                ),
                              ),
                            );
                          },
                        );
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
                                    text: "USERNAME",
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
                        ? "Checking..."
                        : "Next",
                    textColor: colorThird,
                    buttonColor: colorPrimary,
                    leftMargin: 0,
                    rightMargin: 0,
                    topMargin: 48,
                    bottomMargin: 48,
                    width: double.infinity,
                    height: null,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
