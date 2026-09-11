import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/core/DI/dependency_injection.dart';
import 'package:smart_pharmacy/core/Helper/shared_pref_keys.dart';
import 'package:smart_pharmacy/core/Helper/sheard_pref_healper.dart';
import 'package:smart_pharmacy/core/util/app_navigator.dart';
import 'package:smart_pharmacy/core/util/app_router.dart';
import 'package:smart_pharmacy/core/util/app_theme.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/payment_cancelled_view.dart';
import 'package:smart_pharmacy/feature/auth/presentation/views/login_view.dart';
import 'package:smart_pharmacy/feature/cart/presentation/manger/cubit/cart_cubit.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/home_view.dart';
import 'package:smart_pharmacy/feature/order/presentation/views/order_view.dart';
import 'package:smart_pharmacy/feature/order/presentation/views/prescription_status_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();

  final token = await SharedPrefHelper.getSecuredString(
    SharedPrefKeys.userToken,
  );
  final startRoute = token.isNotEmpty
      ? HomeView.routeName
      : LoginView.routeName;

  runApp(SmartPharmacy(startRoute: startRoute));
}

class SmartPharmacy extends StatelessWidget {
  const SmartPharmacy({super.key, required this.startRoute});

  final String startRoute;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CartCubit>(),
      
      child: MaterialApp(
      
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        onGenerateRoute: onGenerateRoute,
        initialRoute:startRoute ,
        title: 'Smart Pharmacy',
        theme: AppTheme.light,
      ),
    );
  }
}
