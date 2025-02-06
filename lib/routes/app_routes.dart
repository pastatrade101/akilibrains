import 'package:get/get_navigation/src/routes/get_route.dart';

import '../features/authentication/onboarding/onboarding.dart';
import '../features/authentication/password_configuration/forget_password.dart';
import '../features/authentication/personalization/screens/profile/profile.dart';
import '../features/authentication/personalization/screens/setting/settings.dart';
import '../features/authentication/signup/screens/signup.dart';
import '../features/authentication/signup/screens/verify_email.dart';
import '../features/library/cart/cart.dart';
import '../features/library/cart/order.dart';
import '../features/library/home.dart';
import '../features/wishlist/screens/wishlist.dart';
import 'routes.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: TRoutes.home, page: () => const HomeScreen()),

    GetPage(name: TRoutes.favourites, page: () => const FavouriteScreen()),
    GetPage(name: TRoutes.settings, page: () => const SettingsScreen()),


    GetPage(name: TRoutes.order, page: () => const OrderScreen()),

    GetPage(name: TRoutes.cart, page: () => const CartScreen()),
    GetPage(name: TRoutes.userProfile, page: () => const ProfileScreen()),

    GetPage(name: TRoutes.signup, page: () => const SignupScreen()),
    GetPage(name: TRoutes.verifyEmail, page: () => const VerifyEmailScreen()),

    GetPage(name: TRoutes.forgetPassword, page: () => const ForgetPassword()),
    GetPage(name: TRoutes.onBoarding, page: () => const OnBoardingScreen()),
    // Add more GetPage entries as needed
  ];
}
