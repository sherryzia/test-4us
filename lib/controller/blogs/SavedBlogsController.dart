import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SavedBlogsController extends GetxController {
  final supabase = Supabase.instance.client;

  // Reactive list to hold saved blogs
  var savedBlogs = [].obs;

  // Fetch saved blogs for the current user
  Future<void> fetchSavedBlogs(String uid) async {
    try {
      // Query the saved_articles table to get the saved blog IDs for the user
      final savedArticles = await supabase
          .from('saved_articles')
          .select('blog_id')
          .eq('user_id', uid);

      if (savedArticles.isNotEmpty) {
        // Extract blog IDs
        List<String> blogIds = List<String>.from(
          savedArticles.map((article) => article['blog_id']),
        );

        print('Blog IDs: $blogIds');

        // Dynamically build the OR filter for blog IDs
        String orFilter = blogIds
            .map((id) => 'id.eq.$id')
            .join(',');

        // Fetch blog details for the saved blog IDs from the blogs table
        final blogs = await supabase
            .from('blogs')
            .select()
            .or(orFilter);

        savedBlogs.value = blogs;

        print('Fetched Blogs: $blogs');
      } else {
        savedBlogs.clear();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch saved blogs: $e',
          snackPosition: SnackPosition.BOTTOM);
      print('Error fetching saved blogs: $e');
    }
  }
}
