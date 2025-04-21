import 'dart:convert';
import 'dart:typed_data';

import 'package:ecomanga/controllers/controllers.dart';
import 'package:ecomanga/models/models.dart';
import 'package:ecomanga/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class PostController extends GetxController {
  RxMap<String, bool> isLoading = {
    keys.createPost: false,
    keys.getPosts: false,
    keys.getPostById: false,
    keys.getCommentById: false,
  }.obs;
  RxBool isSuccessful = false.obs;
  RxString errorMessage = "".obs;
  Map<String, dynamic> data = {};
  List<Post> posts = [];
  List<Post> newPosts = [];
  Post? post;

  void getPosts() async {
    isLoading[keys.getPosts] = true;

    try {
      final response = await http.get(
        Urls.post,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Controllers.prefController.aTk}',
        },
      );
      data = await json.decode(response.body);

      if (response.statusCode == 200) {
        data['data'].forEach((post) => newPosts.add(Post.fromJson(post)));
        if (newPosts != posts) posts = newPosts;
        newPosts = [];
      } else {
        errorMessage.value = data['message'];
        // throw Exception("Unauthorized");
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading[keys.getPosts] = false;
    }
  }

  void getPostById(int id) async {
    isLoading[keys.getPosts] = true;

    try {
      final response = await http.get(
        Urls.postById(id),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Controllers.prefController.aTk}',
        },
      );
      data = await json.decode(response.body);

      if (response.statusCode == 200) {
        post = Post.fromJson(data['data']);
        print(post!.author);
      } else {
        errorMessage.value = data['message'];
        // throw Exception("Unauthorized");
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading[keys.getPosts] = false;
    }
  }

  void getCommentsById(int id) async {
    isLoading[keys.getPosts] = true;

    try {
      final response = await http.get(
        Urls.commentsById(id),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Controllers.prefController.aTk}',
        },
      );
      data = await json.decode(response.body);

      if (response.statusCode == 200) {
        print(data['data']);
      } else {
        errorMessage.value = data['message'];
        // throw Exception("Unauthorized");
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading[keys.getPosts] = false;
    }
  }

  Future<void> createPost(
    String desc,
    String username,
    Uint8List? image,
  ) async {
    isLoading[keys.createPost] = true;
    try {
      final response = await http.post(
        Urls.post,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Controllers.prefController.aTk}',
        },
        body: json.encode({
          "title": username + DateTime.now().toString(),
          "content": desc,
        }),
      );
      print(response.statusCode);
      data = await json.decode(response.body);

      if (response.statusCode == 201) {
        isSuccessful.value = true;
      } else {
        errorMessage.value = data['message'];
        // throw Exception("Unauthorized");
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading[keys.createPost] = false;
    }
  }
}
