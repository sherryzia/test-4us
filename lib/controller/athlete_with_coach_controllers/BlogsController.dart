// BlogController
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BlogController extends GetxController {
  final supabase = Supabase.instance.client;

  var blogs = <Map<String, dynamic>>[].obs;
  var recommendedBlogs = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var filteredBlogs = <Map<String, dynamic>>[].obs;
  var selectedCategory = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBlogs();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    applyFilter();
  }

  void applyFilter() {
    print('Selected Category: ${selectedCategory.value}');

    String filterValue;
    switch (selectedCategory.value) {
      case 'Beginner Basics':
        filterValue = 'Beginner';
        break;
      case 'Advanced Techniques':
        filterValue = 'Advanced';
        break;
      case 'Stroke Refinement':
        filterValue = 'Stroke Refinement';
        break;
      default:
        filterValue = 'All';
    }

    if (filterValue == 'All') {
      filteredBlogs.value = blogs;
    } else {
      filteredBlogs.value = blogs.where((blog) {
        print('Checking blog: ${blog['level_category']}');
        return blog['level_category'] == filterValue;
      }).toList();
    }
    print('Filtered Blogs Count: ${filteredBlogs.length}');
  }

  Future<void> fetchBlogs() async {
    isLoading.value = true;
    try {
      final response = await supabase
          .from('blogs')
          .select('*')
          .order('created_at', ascending: false);

      if (response != null && response.isNotEmpty) {
        blogs.value = List<Map<String, dynamic>>.from(response);
        recommendedBlogs.value = blogs
            .where((blog) => blog['level_category'] == 'Beginner')
            .toList();
        applyFilter(); // Apply filter after fetching
      } else {
        print('No blogs found in response');
      }
    } catch (e) {
      print("Error fetching blogs: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
