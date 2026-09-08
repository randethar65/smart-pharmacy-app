import 'package:dartz/dartz.dart';
import 'package:smart_pharmacy/core/error/failures.dart';
import 'package:smart_pharmacy/feature/Checkout/data/models/upload_prescription_request.dart';
import 'package:smart_pharmacy/feature/Checkout/data/models/upload_prescription_response.dart';

abstract class PrescriptionRepos {
  /// Uploads one prescription image and attaches it to the order.
  Future<Either<Failure, PrescriptionResponse>> uploadPrescription(
    PrescriptionRequest prescriptionRequest,
  );
}
