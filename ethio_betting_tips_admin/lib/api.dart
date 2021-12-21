import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class API {
  final FirebaseFirestore _instance;
  final FirebaseAuth _auth;
  API(this._instance, this._auth);
  Future<List<MatchTip>> getAllMatchs() async {
    List<MatchTip> temp = [];
    QuerySnapshot<Map<String, dynamic>> docs =
        await _instance.collection('Tips').get();
    for (var element in docs.docs) {
      temp.add(MatchTip.fromMap(element.data()));
    }
    return temp;
  }

  Future<List<MatchTip>> getMatchsForResult(String term) async {
    List<MatchTip> temp = [];
    QuerySnapshot<Map<String, dynamic>> docs =
        await _instance.collection('Tips').get();
    for (var element in docs.docs) {
      if ((element.data()['home'] as String)
              .toLowerCase()
              .contains(term.toLowerCase()) ||
          (element.data()['away'] as String)
              .toLowerCase()
              .contains(term.toLowerCase())) {
        temp.add(MatchTip.fromMap(element.data()));
      }
    }
    return temp;
  }

  Future<String?> logIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
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
}

class MatchTip {
  MatchTip(this.home, this.away, this.time, this.winTip, this.overUnderTip,
      this.gGTip,
      {this.homeRecord = const [-2, -2, -2, -2, -2],
      this.awayRecord = const [-2, -2, -2, -2, -2]});
  late final String home;
  late final String away;
  late final DateTime time;
  late final List<int> homeRecord;
  late final List<int> awayRecord;
  late final int winTip;
  late final double overUnderTip;
  late final bool gGTip;
  MatchTip.fromMap(Map<String, dynamic> map) {
    home = map['home'];
    away = map['away'];
    time = (map['time'] as Timestamp).toDate();
    homeRecord = (map['homeRecord'] as List<dynamic>).cast();
    awayRecord = (map['awayRecord'] as List<dynamic>).cast();
    winTip = map['winTip'];
    overUnderTip = map['overUnderTip'];
    gGTip = map['gGTip'];
  }
}
