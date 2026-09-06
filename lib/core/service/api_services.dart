import 'package:dio/dio.dart';
import 'package:smart_pharmacy/core/service/api_constant.dart';


class ApiService {
  final Dio dio;

  ApiService({required this.dio});
  /// `dynamic` لأن الردود مش كلها كائن — بعض الـ endpoints (زي الكاتيجوري)
  /// ترجع مصفوفة JSON مباشرة بدل `{ ... }`.
  Future<dynamic> get({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    var respons = await dio.get(
      "${ApiConstants.apiBaseUrl}$endPoint",
      queryParameters: queryParameters,
    );
    return respons.data;
  }

  Future<Map<String, dynamic>> post(
      {required String endPoint, required Map<String, dynamic> data}) async {
    var respons =
        await dio.post("${ApiConstants.apiBaseUrl}$endPoint", data: data);
    return respons.data;
  }

  Future<dynamic> delete({
    required String endPoint,
    Map<String, dynamic>? data,
  }) async {
    var respons = await dio.delete(
      "${ApiConstants.apiBaseUrl}$endPoint",
      data: data,
    );
    return respons.data;
  }

  Future<dynamic> patch({
    required String endPoint,
    required Map<String, dynamic> data,
  }) async {
    var respons = await dio.patch(
      "${ApiConstants.apiBaseUrl}$endPoint",
      data: data,
    );
    return respons.data;
  }
}