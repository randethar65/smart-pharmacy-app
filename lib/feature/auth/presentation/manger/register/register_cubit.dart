import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/feature/auth/data/models/register_request_body.dart';
import 'package:smart_pharmacy/feature/auth/domain/repos/auth_repos.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({required this.authRepo}) : super(RegisterInitial());

  final AuthRepo authRepo;

  Future<void> register({
    required String fullName,
    required String userName,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    emit(RegisterLoading());

    final result = await authRepo.register(
      RegisterRequest(
        fullName: fullName,
        userName: userName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      ),
    );

    result.fold(
      (failure) => emit(RegisterFailure(failure.message)),
      (response) {
        // The API returns 400 (-> RegisterFailure) on a failed registration, so
        // a 200 body should already be success == true. Guard anyway.
        if (!response.success) {
          emit(RegisterFailure(response.message));
          return;
        }
        emit(RegisterSuccess(response.message));
      },
    );
  }
}
