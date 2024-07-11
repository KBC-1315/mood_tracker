import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mood_tracker/model/user_profile_model.dart';
import 'package:mood_tracker/repo/user_repository.dart';
import 'package:riverpod/riverpod.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _repository;
  @override
  FutureOr<UserProfileModel> build() {
    _repository = ref.read(userRepo);
    return UserProfileModel.empty();
  }

  Future<void> createAccount(UserCredential credential) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    }
    state = const AsyncValue.loading();
    final profile = UserProfileModel(
      bio: "",
      link: "",
      email: credential.user!.email ?? "anon@anon.com",
      uid: credential.user!.uid,
      name: credential.user!.displayName ?? "Anon",
    );
    await _repository.createProfile(profile);
    state = AsyncValue.data(profile);
  }
}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);
