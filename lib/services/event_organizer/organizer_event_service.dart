import 'package:dio/dio.dart';
import 'package:forus_app/utils/dio_util.dart';
import 'package:forus_app/utils/rest_endpoints.dart';

class OrganizerEventService {
  final Dio _dio = DioUtil.dio;

  Future<Response<dynamic>> createEvent() async {
    throw Exception("Method not Implemented");
  }

  Future<Response<dynamic>> updateEvent(eventId) async {
    throw Exception("Method not Implemented");
  }

  Future<Response<dynamic>> getAllEvents() async {
    throw Exception("Method not Implemented");
  }

  Future<Response<dynamic>> getEvent(eventId) async {
    throw Exception("Method not Implemented");
  }

  Future<Response<dynamic>> deleteEvent(eventId) async {
    throw Exception("Method not Implemented");
  }
}