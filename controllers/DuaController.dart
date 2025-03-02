import 'package:get/get.dart';
import 'package:dio/dio.dart';

class DuaController extends GetxController {
  var isLoading = false.obs;
  var languages = <String>[].obs;
  var categories = <Map<String, dynamic>>[].obs;
  var combinedDuas = <Map<String, dynamic>>[].obs; // ✅ Combined duas from valid categories
  var selectedLanguage = "en".obs;

  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://dua-dhikr.vercel.app",
    connectTimeout: const Duration(seconds: 10), // ✅ Increased timeout
    receiveTimeout: const Duration(seconds: 15),
  ));

  @override
  void onInit() {
    super.onInit();
    fetchLanguages();
    fetchDuasFromValidCategories();
  }

  // ✅ Fetch available languages
  Future<void> fetchLanguages() async {
    try {
      isLoading(true);
      final response = await _dio.get("/languages");

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map<String, dynamic> && response.data.containsKey('data')) {
          final extractedLanguages = response.data['data'] as List<dynamic>;
          languages.assignAll(extractedLanguages.map((e) => e.toString()).toList());
        }
      }
    } catch (e) {
      print("❌ Error fetching languages: $e");
    } finally {
      isLoading(false);
    }
  }

  // ✅ Fetch and Combine Duas from Categories with `total > 0`
  Future<void> fetchDuasFromValidCategories({int retryCount = 0}) async {
    isLoading(true); // Keep loading indicator ON while retrying

    try {
      final response = await _dio.get(
        "/categories",
        options: Options(headers: {"Accept-Language": selectedLanguage.value}),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map<String, dynamic> && response.data.containsKey('data')) {
          final extractedCategories = response.data['data'] as List<dynamic>;

          // ✅ Filter categories with `total > 0`
          final validCategories = extractedCategories
              .where((category) => category['total'] != null && category['total'] > 0)
              .toList();

          categories.assignAll(validCategories.cast<Map<String, dynamic>>());

          // ✅ Fetch duas from each valid category with delay
          List<Map<String, dynamic>> allDuas = [];
          for (var category in validCategories) {
            final categorySlug = category['slug'];

            // 🔹 Add delay before making each request to prevent rate limit (429)
            await Future.delayed(const Duration(milliseconds: 500));

            final duas = await fetchDuas(categorySlug);
            allDuas.addAll(duas);
          }

          combinedDuas.assignAll(allDuas);
        } else {
          print("⚠️ Unexpected data format in categories response: ${response.data}");
        }
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        if (retryCount < 3) {
          print("⚠️ Rate limit reached. Retrying in 2 seconds... (Attempt ${retryCount + 1})");
          await Future.delayed(const Duration(seconds: 2));
          return fetchDuasFromValidCategories(retryCount: retryCount + 1);
        } else {
          print("❌ Reached max retries due to rate limit.");
        }
      }
    } catch (e) {
      print("❌ Error fetching categories: $e");
    } finally {
      isLoading(false);
    }
  }

  // ✅ Fetch Duas for a category with rate limit handling
  Future<List<Map<String, dynamic>>> fetchDuas(String category, {int retryCount = 0}) async {
    try {
      final response = await _dio.get(
        "/categories/$category",
        options: Options(headers: {"Accept-Language": selectedLanguage.value}),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map<String, dynamic> && response.data.containsKey('data')) {
          final extractedDuas = response.data['data'] as List<dynamic>;
          return extractedDuas.map((e) => e as Map<String, dynamic>).toList();
        } else {
          print("⚠️ Unexpected data format in duas response: ${response.data}");
        }
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        if (retryCount < 3) {
          print("⚠️ Rate limit reached. Retrying in 2 seconds... (Attempt ${retryCount + 1})");
          await Future.delayed(const Duration(seconds: 2));
          return fetchDuas(category, retryCount: retryCount + 1);
        } else {
          print("❌ Reached max retries due to rate limit.");
        }
      }
    } catch (e) {
      print("❌ Error fetching duas: $e");
    }
    return [];
  }

  // ✅ **Newly Added Fetch Dua Details Function**
  Future<Map<String, dynamic>?> fetchDuaDetails(String category, String duaId) async {
    try {
      final response = await _dio.get(
        "/categories/$category/$duaId",
        options: Options(headers: {"Accept-Language": selectedLanguage.value}),
      );

      print("🔹 Raw API Response for Dua ID $duaId: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map<String, dynamic> && response.data.containsKey('data')) {
          return response.data['data']; // ✅ Extracting the correct data format
        } else {
          print("⚠️ Unexpected API response format for dua details: ${response.data}");
        }
      }
    } catch (e) {
      print("❌ Error fetching dua details: $e");
    }
    return null;
  }
}
