import 'package:stagemuse/view/export_view.dart';

String appBarTitleComponentProfileCreateEditLiveEvent(
    ProfileLiveEventType type) {
  switch (type) {
    case ProfileLiveEventType.create:
      return "Create";
    default:
      return "Edit";
  }
}
