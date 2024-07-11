import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_tracker/repo/authentification_repository.dart';
import 'package:mood_tracker/utils.dart';
import 'package:mood_tracker/view_model/users_view_model.dart';
import 'package:riverpod/riverpod.dart';

class SignupViewModel extends AsyncNotifier<void> {
  late final AuthentificationRepository _authRepo;

  @override
  FutureOr<void> build() {
    _authRepo = ref.read(authRepo);
  }

  Future<void> signUp(
      BuildContext context, String email, String password) async {
    state = const AsyncValue.loading();
    final users = ref.read(usersProvider.notifier);
    state = await AsyncValue.guard(() async {
      final userCredential = await _authRepo.signUp(
        email,
        password,
      );
      if (userCredential.user != null) {
        await users.createAccount(userCredential);
      }
    });
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      context.go("/home");
    }
  }
}

final signUpForm = StateProvider((ref) => {});

final signUpProvider = AsyncNotifierProvider<SignupViewModel, void>(
  () => SignupViewModel(),
);
