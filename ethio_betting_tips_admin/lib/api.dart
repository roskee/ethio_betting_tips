import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class API {
  final FirebaseFirestore _instance;
  final FirebaseAuth _auth;
  final VoidCallback onUpdate;
  API(this._instance, this._auth, this.onUpdate);
  Future<List<MatchTip>> getAllMatchs() async {
    List<MatchTip> temp = [];
    QuerySnapshot<Map<String, dynamic>> docs = await _instance
        .collection('Tips')
        .where('time', isGreaterThan: DateTime.now())
        .orderBy('time')
        .get();
    for (var element in docs.docs) {
      temp.add(MatchTip.fromMap(element.id, element.data()));
    }
    return temp;
  }

  Future<List<MatchTip>> getMatchsForResult(String term) async {
    List<MatchTip> temp = [];
    QuerySnapshot<Map<String, dynamic>> docs = await _instance
        .collection('Tips')
        .where('time', isGreaterThan: DateTime.now())
        .get();
    for (var element in docs.docs) {
      if ((element.data()['home'] as String)
              .toLowerCase()
              .contains(term.toLowerCase()) ||
          (element.data()['away'] as String)
              .toLowerCase()
              .contains(term.toLowerCase())) {
        temp.add(MatchTip.fromMap(element.id, element.data()));
      }
    }
    return temp;
  }

  Future<void> updateTip(MatchTip tip) async {
    await _instance.collection('Tips').doc(tip.id).update(tip.toMap());
    onUpdate();
  }

  Future<void> deleteTip(MatchTip tip) async {
    await _instance.collection('Tips').doc(tip.id).delete();
    onUpdate();
  }

  Future<String> addTip(MatchTip tip) async {
    DocumentReference x = await _instance.collection('Tips').add(tip.toMap());
    onUpdate();
    return x.id;
  }

  Future<String?> logIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } catch (e) {
      String errorMessage;
      switch ((e as FirebaseAuthException).code) {
        case 'user-not-found':
          errorMessage = 'There is no account with this email';
          break;
        case 'invalid-email':
          errorMessage = 'You have entered an invalid email';
          break;
        case 'user-disabled':
          errorMessage =
              'The account you tried to login to is currently disabled. contact administrators';
          break;
        case 'wrong-password':
          errorMessage = "The password is incorrect";
          break;
        default:
          errorMessage = 'Unknown Error has occured';
      }
      return errorMessage;
    }
  }

  Future<String?> createAdmin(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return null;
    } catch (e) {
      String errorMessage;
      switch ((e as FirebaseAuthException).code) {
        case 'user-not-found':
          errorMessage = 'There is no account with this email';
          break;
        case 'invalid-email':
          errorMessage = 'You have entered an invalid email';
          break;
        case 'user-disabled':
          errorMessage =
              'The account you tried to login to is currently disabled. contact administrators';
          break;
        case 'wrong-password':
          errorMessage = "The password is incorrect";
          break;
        default:
          errorMessage = 'Unknown Error has occured';
      }
      return errorMessage;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}

class MatchTip {
  MatchTip.defaultTip() {
    home = 'HomeTeam';
    away = 'AwayTeam';
    time = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
    homeRecord = [2, 2, 2, 2, 2];
    awayRecord = [2, 2, 2, 2, 2];
    winTip = 0;
    overUnderTip = 0.5;
    gGTip = false;
  }
  MatchTip(this.home, this.away, this.time, this.winTip, this.overUnderTip,
      this.gGTip,
      {this.homeRecord = const [-2, -2, -2, -2, -2],
      this.awayRecord = const [-2, -2, -2, -2, -2],
      this.id});
  late final String home;
  late final String away;
  late final DateTime time;
  late final List<int> homeRecord;
  late final List<int> awayRecord;
  late final int winTip;
  late final double overUnderTip;
  late final bool gGTip;
  String? id;
  MatchTip editTip(
      {String? id,
      String? home,
      String? away,
      DateTime? time,
      int? winTip,
      double? overUnderTip,
      bool? gGTip,
      List<int>? homeRecord,
      List<int>? awayRecord}) {
    return MatchTip(
        home ?? this.home,
        away ?? this.away,
        time ?? this.time,
        winTip ?? this.winTip,
        overUnderTip ?? this.overUnderTip,
        gGTip ?? this.gGTip,
        homeRecord: homeRecord ?? this.homeRecord,
        awayRecord: awayRecord ?? this.awayRecord,
        id: id ?? this.id);
  }

  MatchTip.fromMap(this.id, Map<String, dynamic> map) {
    home = map['home'];
    away = map['away'];
    time = (map['time'] as Timestamp).toDate();
    homeRecord = (map['homeRecord'] as List<dynamic>).cast();
    awayRecord = (map['awayRecord'] as List<dynamic>).cast();
    winTip = map['winTip'];
    overUnderTip = map['overUnderTip'];
    gGTip = map['gGTip'];
  }
  Map<String, dynamic> toMap() {
    return {
      'home': home,
      'away': away,
      'time': Timestamp.fromDate(time),
      'homeRecord': homeRecord,
      'awayRecord': awayRecord,
      'winTip': winTip,
      'overUnderTip': overUnderTip,
      'gGTip': gGTip
    };
  }
}
