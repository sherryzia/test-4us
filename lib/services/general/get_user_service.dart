import 'package:dio/dio.dart';
import 'package:forus_app/utils/dio_util.dart';
import 'package:forus_app/utils/rest_endpoints.dart';

class GetUserServiceService {
  final Dio _dio = DioUtil.dio;

  Future<Response<dynamic>> fetchUserDetails() async {
    final response = await _dio.get(RestConstants.user);
    return response;
  }
}
