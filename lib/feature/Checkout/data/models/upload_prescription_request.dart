import 'dart:io';
import 'package:dio/dio.dart';

class PrescriptionRequest {
  final int orderId;
  final File image;

  PrescriptionRequest({required this.orderId, required this.image});

  Future<FormData> toFormData() async => FormData.fromMap({
        'OrderId': orderId,
        'Image': await MultipartFile.fromFile(
          image.path,
          //هاي فقط عشان نحدد اسم الملف اللي رح ينبعت للسيرفر
          // خلّي الاسم بامتداده الأصلي — الباك يتحقق من الامتداد مش الـ content-type
          filename: image.path.split(Platform.pathSeparator).last,
        ),
      });
}