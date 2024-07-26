import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart' as firebase;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/model/mood_model.dart';
import 'package:http/http.dart' as http;

class MoodRepository {
  final firebase.FirebaseFirestore _db = firebase.FirebaseFirestore.instance;
  final String apiKey = dotenv.env['API_KEY'] ?? '';
  final apiUrl = "https://api.openai.com/v1/chat/completions";

  Future<void> savePost(MoodModel post) async {
    try {
      await _db.collection("moods").add(post.toJson());
    } catch (e) {
      print('Error saving post: $e');
    }
  }

  Future<void> deletePost(int postId) async {
    try {
      firebase.QuerySnapshot querySnapshot = await _db
          .collection("moods")
          .where("createdAt", isEqualTo: postId)
          .get();
      querySnapshot.docs.forEach((doc) async {
        await _db.collection("moods").doc(doc.id).delete();
      });
    } catch (e) {
      print('Error deleting post: $e');
    }
  }

  Future<void> sendPostToRandomUser(MoodModel post) async {
    // 여기에 전송 로직을 추가하세요. 예를 들어, 다른 사용자의 ID를 찾고 해당 사용자에게 게시물을 전송하는 기능.
  }

  Future<firebase.QuerySnapshot<Map<String, dynamic>>> fetchPosts() {
    return _db.collection("moods").orderBy("createdAt", descending: true).get();
  }

  Future<String> generateText(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          'messages': [
            {"role": "user", "content": prompt}
          ],
          'max_tokens': 30,
          'temperature': 0,
          "top_p": 1,
          "frequency_penalty": 0,
          "presence_penalty": 0,
        }),
      );
      if (response.statusCode == 200) {
        final newResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return newResponse['choices'][0]['message']['content'];
      } else {
        print('Error generating text: ${response.statusCode}');
        return 'Error generating text';
      }
    } catch (e) {
      print('Error generating text: $e');
      return 'Error generating text';
    }
  }

  Stream<List<MoodModel>> getMoodStream() {
    return _db
        .collection("moods")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MoodModel.fromJson(doc.data()))
            .toList());
  }
}

// Repository provider
final moodRepositoryProvider = Provider((ref) => MoodRepository());

// Stream provider for moods
final moodsStreamProvider = StreamProvider<List<MoodModel>>((ref) {
  final repository = ref.watch(moodRepositoryProvider);
  return repository.getMoodStream();
});
