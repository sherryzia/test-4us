import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BlogDetailsController extends GetxController {
  final supabase = Supabase.instance.client;

  Future<void> saveArticle(String userId, String blogId) async {
    try {
      // Check if the blog is already saved
      final existing = await supabase
          .from('saved_articles')
          .select()
          .eq('user_id', userId)
          .eq('blog_id', blogId)
          .maybeSingle();

      if (existing == null) {
        // Insert a new record if not already saved
        await supabase.from('saved_articles').insert({
          'user_id': userId,
          'blog_id': blogId,
        });

        Get.snackbar('Saved', 'Blog saved successfully!',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Already Saved', 'This blog is already saved!',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save blog: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteArticle(String userId, String blogId) async {
    try {
      await supabase
          .from('saved_articles')
          .delete()
          .eq('user_id', userId)
          .eq('blog_id', blogId);

      Get.snackbar('Removed', 'Blog removed from saved!',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove blog: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
