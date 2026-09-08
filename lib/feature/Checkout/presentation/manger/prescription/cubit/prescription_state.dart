part of 'prescription_cubit.dart';

@immutable
sealed class PrescriptionState {}

final class PrescriptionInitial extends PrescriptionState {}

/// Uploading in progress — [uploaded] of [total] files done.
final class PrescriptionUploading extends PrescriptionState {
  final int uploaded;
  final int total;
  PrescriptionUploading({required this.uploaded, required this.total});
}

/// Every image uploaded; the order is now pending pharmacist review.
final class PrescriptionSuccess extends PrescriptionState {}

final class PrescriptionFailure extends PrescriptionState {
  final String message;
  PrescriptionFailure(this.message);
}
