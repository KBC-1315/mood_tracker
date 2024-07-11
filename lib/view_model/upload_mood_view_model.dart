import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/model/mood_model.dart';
import 'package:mood_tracker/repo/authentification_repository.dart';
import 'package:mood_tracker/repo/mood_repository.dart';

class UploadMoodViewModel extends AsyncNotifier<void> {
  late final MoodRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(moodRepositoryProvider);
  }

  Future<void> uploadPost(
      BuildContext context, String mood, String text) async {
    final moodInput = mood.split("/").last;
    final moodLast = moodInput.split(".").first;
    final user = ref.read(authRepo).user;

    if (user == null) {
      return;
    }

    final displayName = user.displayName ?? 'User';
    final prompt =
        "너는 $displayName의 친한 친구이다. 그는 지금 $text인 상태이고 그래서 기분이 $moodLast 인 상태이다. 이에 대한 적절한 답변을 제공해줘. 답변은 영문으로 작성해줘";

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        await _repository.savePost(
          MoodModel(
            postType: "human",
            creator: displayName,
            description: text,
            replied: false,
            repliedto: "",
            status: mood,
            creatorUid: user.uid,
            createdAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
        final generatedText = await _repository.generateText(prompt);
        await _repository.savePost(
          MoodModel(
            postType: "AI",
            creator: displayName,
            description: generatedText,
            replied: false,
            repliedto: user.uid,
            status: mood,
            creatorUid: user.uid,
            createdAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      },
    );
  }
}

final uploadPostProvider = AsyncNotifierProvider<UploadMoodViewModel, void>(
  () => UploadMoodViewModel(),
);
