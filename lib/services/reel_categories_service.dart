import 'package:candid/utils/rest_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:candid/utils/dio_util.dart';

class ReelCategoriesService {
  final String reelCategoriesUrl = '/api/v1/social/reel-categories';
  final Dio _dio = DioUtil.dio;

  // Get reel categories
  Future<Response<dynamic>> getReelCategories() async {
    final response = await _dio.get(reelCategoriesUrl);
    return response;
  }
}