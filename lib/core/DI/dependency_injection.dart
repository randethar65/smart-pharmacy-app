import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_pharmacy/core/service/api_services.dart';
import 'package:smart_pharmacy/core/service/dio_factory.dart';
import 'package:smart_pharmacy/feature/auth/data/repos/auth_repo_impl.dart';
import 'package:smart_pharmacy/feature/auth/domain/repos/auth_repos.dart';
import 'package:smart_pharmacy/feature/auth/presentation/manger/forget_password/forget_password_cubit.dart';
import 'package:smart_pharmacy/feature/auth/presentation/manger/login/login_cubit.dart';
import 'package:smart_pharmacy/feature/auth/presentation/manger/register/register_cubit.dart';
import 'package:smart_pharmacy/feature/home/data/repos/category_repos_impl.dart';
import 'package:smart_pharmacy/feature/home/data/repos/product_repos_imple.dart';
import 'package:smart_pharmacy/feature/home/domain/repos/category_repos.dart';
import 'package:smart_pharmacy/feature/home/domain/repos/product_repos.dart';
import 'package:smart_pharmacy/feature/home/presentation/manger/ProductDetail/product_details_cubit.dart';
import 'package:smart_pharmacy/feature/home/presentation/manger/category/category_cubit.dart';
import 'package:smart_pharmacy/feature/home/presentation/manger/Product/product_cubit.dart';
import 'package:smart_pharmacy/feature/cart/data/repos_imple/cart_repos_imple.dart';
import 'package:smart_pharmacy/feature/cart/domain/repos/cart_repos.dart';
import 'package:smart_pharmacy/feature/cart/presentation/manger/cubit/cart_cubit.dart';
import 'package:smart_pharmacy/feature/Checkout/data/repos_imple.dart/checkout_repos_imple.dart';
import 'package:smart_pharmacy/feature/Checkout/data/repos_imple.dart/prescription_repos_imple.dart';
import 'package:smart_pharmacy/feature/Checkout/domain/repos/checkout_repos.dart';
import 'package:smart_pharmacy/feature/Checkout/domain/repos/prescription_repos.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/manger/checkout/checkout_cubit.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/manger/prescription/cubit/prescription_cubit.dart';
import 'package:smart_pharmacy/feature/order/data/repos_Imple/order_repo_imple.dart';
import 'package:smart_pharmacy/feature/order/domain/repos/order_repo.dart';
import 'package:smart_pharmacy/feature/order/presentation/manger/order/order_cubit.dart';
import 'package:smart_pharmacy/feature/order/presentation/manger/order_detail.dart/cubit/order_detail_cubit.dart';
import 'package:smart_pharmacy/feature/Notification/data/repos_imple/notification_repo_imple.dart';
import 'package:smart_pharmacy/feature/Notification/domain/repos/notification_repo.dart';
import 'package:smart_pharmacy/feature/Notification/presentation/manger/cubit/notification_cubit.dart';
import 'package:smart_pharmacy/feature/profile/data/repos_imple/profile_repo_imple.dart';
import 'package:smart_pharmacy/feature/profile/domain/repos/profile_repo.dart';
import 'package:smart_pharmacy/feature/profile/presentation/manger/cubit/profile_cubit.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  // Dio + ApiService
  final Dio dio = await DioFactory.getDio();
  getIt.registerSingleton<ApiService>(ApiService(dio: dio));

  // Repo — مسجّل على النوع المجرّد AuthRepo
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<CategoryRepos>(
    () => CategoryReposImpl(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ProductRepos>(
    () => ProductReposImpl(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<CartRepos>(
    () => CartReposImple(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<CheckoutRepos>(
    () => CheckoutReposImple(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<PrescriptionRepos>(
    () => PrescriptionReposImple(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<OrderRepo>(
    () => OrderRepoImple(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImple(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<NotificationRepo>(
    () => NotificationRepoImple(apiService: getIt<ApiService>()),
  );

  // Cubits — نسخة جديدة كل مرة تُطلب
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(authRepo: getIt<AuthRepo>()),
  );
  getIt.registerFactory<RegisterCubit>(
    () => RegisterCubit(authRepo: getIt<AuthRepo>()),
  );
  getIt.registerFactory<ForgetPasswordCubit>(
    () => ForgetPasswordCubit(authRepo: getIt<AuthRepo>()),
  );
  getIt.registerFactory<CategoryCubit>(
    () => CategoryCubit(categoryRepos: getIt<CategoryRepos>()),
  );
  getIt.registerFactory<ProductCubit>(
    () => ProductCubit(productRepos: getIt<ProductRepos>()),
  );
   getIt.registerFactory<ProductDetailsCubit>(
    () => ProductDetailsCubit(productRepos: getIt<ProductRepos>()),
  );
  // Singleton: the cart is one shared thing across the whole app.
  getIt.registerLazySingleton<CartCubit>(
    () => CartCubit(cartRepos: getIt<CartRepos>()),
  );
  getIt.registerFactory<CheckoutCubit>(
    () => CheckoutCubit(checkoutRepos: getIt<CheckoutRepos>()),
  );
  getIt.registerFactory<PrescriptionCubit>(
    () => PrescriptionCubit(prescriptionRepos: getIt<PrescriptionRepos>()),
  );
  getIt.registerFactory<OrderCubit>(
    () => OrderCubit(orderRepo: getIt<OrderRepo>()),
  );
   getIt.registerFactory<OrderDetailCubit>(
    () => OrderDetailCubit(orderRepo: getIt<OrderRepo>(),

  checkoutRepos:  getIt<CheckoutRepos>()
    ),
  );
  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(profileRepo: getIt<ProfileRepo>()),
  );
  // Singleton: ProfileView's badge and NotificationView's list must share
  // the same unreadCount, same as CartCubit above.
  getIt.registerLazySingleton<NotificationCubit>(
    () => NotificationCubit(notificationRepo: getIt<NotificationRepo>()),
  );
}
