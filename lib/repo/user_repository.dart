import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mood_tracker/model/user_profile_model.dart';
import 'package:riverpod/riverpod.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

//create profile
  Future<void> createProfile(UserProfileModel user) async {
    await _db.collection("users").doc(user.uid).set(user.toJson());
  }
//get profile
}

final userRepo = Provider((ref) => UserRepository());
