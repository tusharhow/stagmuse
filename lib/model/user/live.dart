// Form Profile
class LiveFromProfile {
  // From Profile
  LiveFromProfile({
    this.providedByYou,
    this.youFollow,
    this.live,
  });

  List? providedByYou, youFollow;
  bool? live;

  // Map
  factory LiveFromProfile.fromMap(Map<String, dynamic> data) {
    return LiveFromProfile(
      providedByYou: data["provided by you"],
      youFollow: data["you follow"],
      live: data["live"],
    );
  }
}
