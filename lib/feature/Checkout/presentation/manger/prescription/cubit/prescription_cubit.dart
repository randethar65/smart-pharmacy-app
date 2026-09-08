import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/feature/Checkout/data/models/upload_prescription_request.dart';
import 'package:smart_pharmacy/feature/Checkout/domain/repos/prescription_repos.dart';

part 'prescription_state.dart';

class PrescriptionCubit extends Cubit<PrescriptionState> {
  PrescriptionCubit({required this.prescriptionRepos})
      : super(PrescriptionInitial());

 final PrescriptionRepos prescriptionRepos;
  //ببعت كل الصور يلي بدي ارفعهم وكلهم بدخلهم مره وحده 
  /// Uploads every image for [orderId] — one request per file (the backend
  /// takes a single `IFormFile` per call). Stops at the first failure.
  Future<void> submit({
    required int orderId,
    required List<File> images,
  }) async {
    if (images.isEmpty) {
      emit(PrescriptionFailure('Add at least one prescription image.'));
      return;
    }
    emit(PrescriptionUploading(uploaded: 0, total: images.length));
    for (var i = 0; i < images.length; i++) {
      final result = await prescriptionRepos.uploadPrescription(
        PrescriptionRequest(orderId: orderId, image: images[i]),
      );
      final failure = result.fold<String?>((f) => f.message, (_) => null);
      if (failure != null) {
        emit(PrescriptionFailure(failure));
        return;
      }
      emit(PrescriptionUploading(uploaded: i + 1, total: images.length));
    }

    emit(PrescriptionSuccess());
 }
}
