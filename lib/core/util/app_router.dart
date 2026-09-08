import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/core/DI/dependency_injection.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/manger/checkout/checkout_cubit.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/card_payment_redirect_view.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/checkout_view.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/order_placed_success.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/payment_cancelled_view.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/payment_success_view.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/rx_required_view.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/manger/prescription/cubit/prescription_cubit.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/upload_prescription_view.dart';
import 'package:smart_pharmacy/feature/auth/presentation/manger/forget_password/forget_password_cubit.dart';
import 'package:smart_pharmacy/feature/auth/presentation/manger/login/login_cubit.dart';
import 'package:smart_pharmacy/feature/auth/presentation/manger/register/register_cubit.dart';
import 'package:smart_pharmacy/feature/auth/presentation/views/check_email_view.dart';
import 'package:smart_pharmacy/feature/auth/presentation/views/forget_password_view.dart';
import 'package:smart_pharmacy/feature/auth/presentation/views/login_view.dart';
import 'package:smart_pharmacy/feature/auth/presentation/views/register_view.dart';
import 'package:smart_pharmacy/feature/auth/presentation/views/reset_password.dart';
import 'package:smart_pharmacy/feature/cart/presentation/views/cart_view.dart';
import 'package:smart_pharmacy/feature/home/presentation/manger/ProductDetail/product_details_cubit.dart';
import 'package:smart_pharmacy/feature/home/presentation/manger/category/category_cubit.dart';
import 'package:smart_pharmacy/feature/home/presentation/manger/Product/product_cubit.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/home_view.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/widgets/Product_details_consumer.dart';
import 'package:smart_pharmacy/feature/order/presentation/manger/cubit/order_cubit.dart';
import 'package:smart_pharmacy/feature/order/presentation/views/order_view.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginView.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => BlocProvider(
          create: (_) => getIt<LoginCubit>(),
          child: const LoginView(),
        ),
      );

    case RegisterView.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => BlocProvider(
          create: (_) => getIt<RegisterCubit>(),
          child: const RegisterView(),
        ),
      );

    case CheckEmailView.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const CheckEmailView(),
      );

    case ForgetPasswordView.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => BlocProvider(
          create: (_) => getIt<ForgetPasswordCubit>(),
          child: const ForgetPasswordView(),
        ),
      );
    //عشان arguments توصل لازم onGenerateRoute يمرّر الـ settings نفسها للـ MaterialPageRoute
    case ResetPasswordView.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => BlocProvider(
          create: (_) => getIt<ForgetPasswordCubit>(),
          child: const ResetPasswordView(),
        ),
      );

    case HomeView.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<CategoryCubit>(
              create: (_) => getIt<CategoryCubit>()..fetchCategories(),
            ),
            BlocProvider<ProductCubit>(
              create: (_) => getIt<ProductCubit>()..fetchProducts(),
            ),
            // CartCubit is provided app-wide in main.dart — not here, or the
            // nav-bar badge and "add to cart" would read different instances.
          ],
          child: const HomeView(),
        ),
      );
    case ProductDetailsConsumer.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => BlocProvider(
          create: (context) => getIt<ProductDetailsCubit>()..fetchProductDetails(id: (settings.arguments as int)),
          child: const ProductDetailsConsumer(),
        ),
      );

    case CartView.routeName:
      // CartCubit is provided app-wide in main.dart — no BlocProvider here.
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const CartView(),
      );
    case CheckoutView.routName:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => BlocProvider(
          create: (_) => getIt<CheckoutCubit>(),
          child: const CheckoutView(),
        ),
      );

    case OrderPlacedSuccess.routName:
      final args = settings.arguments;
      // After a hot restart / state restoration the arguments are gone —
      // don't crash, just send the user home.
      if (args is! Map) {
        return onGenerateRoute(const RouteSettings(name: HomeView.routeName));
      }
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => OrderPlacedSuccess(
          orderId: args['orderId'] as int,
          total: (args['total'] as num).toDouble(),
        ),
      );

    case PaymentSuccessView.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const PaymentSuccessView(),
      );
    case CardPaymentRedirectView.routeName:
      final args = settings.arguments;
      
      if (args is! Map) {
        return onGenerateRoute(const RouteSettings(name: HomeView.routeName));
      }
      return MaterialPageRoute(
        settings: settings,
        builder: (_) =>  CardPaymentRedirectView(
        
          checkoutUrl: args['checkoutUrl'] as String ,
          amount:(args['amount'] as num).toDouble(),

        ),
      );

    case PaymentCancelledView.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const PaymentCancelledView(),
      );

    case RxRequiredView.routeName:
      {
        final args = settings.arguments;
        if (args is! Map) {
          return onGenerateRoute(const RouteSettings(name: HomeView.routeName));
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => RxRequiredView(orderId: args['orderId'] as int),
        );
      }

    case UploadPrescriptionView.routeName:
      {
        final args = settings.arguments;
        if (args is! Map) {
          return onGenerateRoute(const RouteSettings(name: HomeView.routeName));
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<PrescriptionCubit>(),
            child: UploadPrescriptionView(orderId: args['orderId'] as int),
          ),
        );
      }
    case OrderView.routName:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => BlocProvider(
          create: (_) => getIt<OrderCubit>(),
          child: const OrderView(),
        ),
      );
    default:
      return null;
  }
}
