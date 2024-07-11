import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/model/mood_model.dart';
import 'package:mood_tracker/repo/mood_repository.dart';

class FetchMoodViewModel extends StateNotifier<AsyncValue<List<MoodModel>>> {
  FetchMoodViewModel(this.ref) : super(const AsyncValue.loading()) {
    _initialize();
  }

  final Ref ref;

  void _initialize() {
    final moodStream = ref.watch(moodsStreamProvider.stream);
    moodStream.listen(
      (moods) {
        state = AsyncValue.data(moods);
      },
      onError: (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
    );
  }

  Future<void> deletePost(int postId) async {
    try {
      await ref.read(moodRepositoryProvider).deletePost(postId);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> sendPostToRandomUser(MoodModel post) async {
    try {
      await ref.read(moodRepositoryProvider).sendPostToRandomUser(post);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final fetchMoodProvider =
    StateNotifierProvider<FetchMoodViewModel, AsyncValue<List<MoodModel>>>(
  (ref) => FetchMoodViewModel(ref),
);
