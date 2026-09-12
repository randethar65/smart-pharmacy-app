import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/core/DI/dependency_injection.dart';
import 'package:smart_pharmacy/core/util/app_navigator.dart';
import 'package:smart_pharmacy/core/util/app_router.dart';
import 'package:smart_pharmacy/core/util/app_theme.dart';
import 'package:smart_pharmacy/feature/cart/presentation/manger/cubit/cart_cubit.dart';
import 'package:smart_pharmacy/feature/Notification/presentation/manger/cubit/notification_cubit.dart';
import 'package:smart_pharmacy/feature/splash/presentation/views/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(const SmartPharmacy());
}

class SmartPharmacy extends StatelessWidget {
  const SmartPharmacy({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<CartCubit>()),
        BlocProvider(create: (context) => getIt<NotificationCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        onGenerateRoute: onGenerateRoute,
        initialRoute: SplashView.routeName,
        title: 'Smart Pharmacy',
        theme: AppTheme.light,
      ),
    );
  }
}
