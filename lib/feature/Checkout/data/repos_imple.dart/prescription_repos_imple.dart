import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_pharmacy/core/error/failures.dart';
import 'package:smart_pharmacy/core/service/api_constant.dart';
import 'package:smart_pharmacy/core/service/api_services.dart';
import 'package:smart_pharmacy/feature/Checkout/data/models/upload_prescription_request.dart';
import 'package:smart_pharmacy/feature/Checkout/data/models/upload_prescription_response.dart';
import 'package:smart_pharmacy/feature/Checkout/domain/repos/prescription_repos.dart';

class PrescriptionReposImple implements PrescriptionRepos {
  final ApiService apiService;

  PrescriptionReposImple({required this.apiService});

  @override
  Future<Either<Failure, PrescriptionResponse>> uploadPrescription(
    PrescriptionRequest prescriptionRequest,
  ) async {
    try {
     

      // ApiService.post only takes a Map; multipart needs dio directly.
      final response = await apiService.dio.post(
        '${ApiConstants.apiBaseUrl}${ApiConstants.uploadPrescription}',
        data:await prescriptionRequest.toFormData(),
      );

      return Right(
        PrescriptionResponse.fromJson(response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
