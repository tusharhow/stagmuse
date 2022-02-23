import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Post
const postTypeImage = "Image", postTypeText = "Text";

// Live
const liveStatusSoon = "SOON",
    liveStatusDoing = 'DOING',
    liveStatusDone = 'DONE',
    liveStatusExpired = "EXPIRED";

// Search
const searchTypeAccount = "Account",
    searchTypeLive = "Live",
    searchTypeAll = "All";

// Notification
const notificationTypeFollowPermission = "Follow Permission",
    notificationTypeFollow = "Follow Notif",
    notificationTypeLike = "Like Notif",
    notificationTypeLive = "Live Notif";

// Chat
const chatTypeText = "Text Chat",
    chatTypeImage = "Image Chat",
    chatTypeStory = "Story Chat";
String chatFrom(String userId) {
  return "from$userId";
}

// Firebase
// Auth
final firebaseAuth = FirebaseAuth.instance;

// Storage
final firebaseStorage = FirebaseStorage.instance;

// Firestore
final firestoreUser = FirebaseFirestore.instance.collection("USER");
final firestoreHastag = FirebaseFirestore.instance.collection("HASHTAG");
final firestoreLive = FirebaseFirestore.instance.collection("LIVE");
final firestoreStory = FirebaseFirestore.instance.collection("STORY");
final firestoreFeed = FirebaseFirestore.instance.collection("FEED");
final firestoreAll = FirebaseFirestore.instance.collection("ALL");
final firebaseMessaging = FirebaseMessaging.instance;
