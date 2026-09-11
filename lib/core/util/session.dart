import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/DI/dependency_injection.dart';
import 'package:smart_pharmacy/core/service/dio_factory.dart';
import 'package:smart_pharmacy/feature/auth/domain/repos/auth_repos.dart';
import 'package:smart_pharmacy/feature/auth/presentation/views/login_view.dart';

Future<void> logout(BuildContext context) async {
  unawaited(getIt<AuthRepo>().logout());
  await DioFactory.clearLocalSession();
  if (context.mounted) {
    Navigator.pushNamedAndRemoveUntil(
      context, LoginView.routeName, (route) => false);
  }
}