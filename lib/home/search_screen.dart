import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mood_tracker/repo/authentification_repository.dart';
import 'package:mood_tracker/view_model/fetch_mood_view_model.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
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

  void showDeleteConfirmationDialog(mood) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text('Are you sure to delete?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await ref
                    .read(fetchMoodProvider.notifier)
                    .deletePost(mood.createdAt);
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final moodListAsyncValue = ref.watch(fetchMoodProvider);
    final authrepo = ref.watch(authRepo);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Moods',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                fontFamily: "roboto")),
      ),
      body: moodListAsyncValue.when(
        data: (moods) {
          final filteredMoods = moods
              .where((mood) => mood.creator == authrepo.user!.displayName)
              .toList();
          if (filteredMoods.isEmpty) {
            return const Center(child: Text('There is no post'));
          }
          return ListView.builder(
            itemCount: filteredMoods.length,
            itemBuilder: (context, index) {
              final mood = filteredMoods[index];
              return Dismissible(
                key: Key(
                    mood.creatorUid), // Assuming MoodModel has an `id` field
                background: Container(
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white)),
                secondaryBackground: Container(
                    color: Colors.blue,
                    child: const Icon(Icons.send, color: Colors.white)),
                confirmDismiss: (DismissDirection direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    // Show delete confirmation dialog
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm'),
                          content: const Text('Are you sure to delete'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop(
                                    false); // Dismiss the dialog and do not delete
                              },
                            ),
                            TextButton(
                              child: const Text('Delete'),
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(true); // Dismiss the dialog and delete
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else if (direction == DismissDirection.endToStart) {
                    // No need for confirmation to send to another user
                    return false;
                  }
                  return false;
                },
                onDismissed: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    () async {
                      await ref
                          .read(fetchMoodProvider.notifier)
                          .deletePost(mood.createdAt);
                    }();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: (mood.postType == "AI")
                        ? Colors.lightGreen[100]
                        : Colors.white, // Background color of ListTile
                    borderRadius:
                        BorderRadius.circular(10.0), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 16.0,
                    ),
                    title: Text(
                      mood.description,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      timeAgoSinceEpoch(mood.createdAt),
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: (mood.postType == "AI")
                        ? Lottie.asset("assets/AI_generating.json")
                        : Lottie.asset(mood.status),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('에러: $error')),
      ),
    );
  }
}
