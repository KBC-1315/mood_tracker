import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_tracker/repo/authentification_repository.dart';
import 'package:mood_tracker/utils.dart';
import 'package:riverpod/riverpod.dart';

class SocialAuthViewModel extends AsyncNotifier<void> {
  late final AuthentificationRepository _repository;
  @override
  FutureOr<void> build() {
    _repository = ref.read(authRepo);
  }

  Future<void> githubSignIn(BuildContext context) async {
    state = const AsyncValue.loading();
    state =
        await AsyncValue.guard(() async => await _repository.githubSignIn());
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      context.go("/home");
    }
  }
}

final socialAuthProvider = AsyncNotifierProvider<SocialAuthViewModel, void>(
    () => SocialAuthViewModel());
