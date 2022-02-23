import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    // Show Ads
    adsServices.showInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    // Bloc
    final _exitBloc = context.watch<ExitAppBloc>();

    return WillPopScope(
      onWillPop: () async {
        // Show Confirmation Dialog
        return showDialog(
          context: context,
          builder: (context) {
            return confirmationDialog(
              content: Text(
                "Are you sure you want to exit from STAGEMUSE?",
                style: medium14(colorThird),
                textAlign: TextAlign.center,
              ),
              actions: [
                flatTextButton(
                  onPress: () {
                    // Update Bloc
                    _exitBloc.add(const SetExitApp(true));
                    // Back
                    Navigator.pop(context);
                  },
                  text: "Yes",
                  textColor: colorThird,
                  buttonColor: colorPrimary,
                  leftMargin: 0,
                  rightMargin: 0,
                  topMargin: 0,
                  bottomMargin: 0,
                  width: null,
                  height: null,
                ),
                flatOutlineTextButton(
                  onPress: () {
                    // Update Bloc
                    _exitBloc.add(const SetExitApp(false));
                    // Back
                    Navigator.pop(context);
                  },
                  text: "No",
                  textColor: colorPrimary,
                  borderColor: colorPrimary,
                  leftMargin: 0,
                  rightMargin: 0,
                  topMargin: 0,
                  bottomMargin: 0,
                  width: null,
                  height: null,
                ),
              ],
            );
          },
        ).then((_) => _exitBloc.state.exit);
      },
      child: StreamBuilder<User?>(
        stream: firebaseAuth.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SignInPage();
          }
          return MainPage(yourId: snapshot.data!.uid);
        },
      ),
    );
  }
}
