import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mood_tracker/repo/authentification_repository.dart';
import 'package:mood_tracker/view_model/fetch_mood_view_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late TextEditingController _nicknameController;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowNicknameDialog();
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _checkAndShowNicknameDialog() async {
    final repo = ref.read(authRepo);
    final user = repo.user;

    if (user != null &&
        (user.displayName == null || user.displayName!.isEmpty)) {
      await _showNicknameDialog();
    }
  }

  Future<void> _showNicknameDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set your nickname'),
          content: TextField(
            controller: _nicknameController,
            decoration: const InputDecoration(hintText: 'Enter your nickname'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final nickname = _nicknameController.text.trim();
                if (nickname.isNotEmpty) {
                  await _setNickname(nickname);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _setNickname(String nickname) async {
    final repo = ref.read(authRepo);
    final user = repo.user;

    if (user != null) {
      await user.updateDisplayName(nickname);
      // Optionally, you can also update the Firestore user document if needed.
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(fetchMoodProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All moods',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                fontFamily: "roboto")),
      ),
      body: repo.when(
        data: (moods) {
          final filteredMoods =
              moods.where((mood) => mood.postType != "AI").toList();

          if (filteredMoods.isEmpty) {
            return const Center(child: Text('There is no post'));
          }

          return ListView.builder(
            itemCount: filteredMoods.length,
            itemBuilder: (context, index) {
              final mood = filteredMoods[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  title: Text(
                    mood.description,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    timeAgoSinceEpoch(mood.createdAt),
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                  trailing: Lottie.asset(mood.status),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  String timeAgoSinceEpoch(int millisecondsSinceEpoch) {
    final postCreatedAt =
        DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    final now = DateTime.now();
    final difference = now.difference(postCreatedAt);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 10) {
      return '${difference.inMinutes}M';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}M';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}D';
    }
  }
}
