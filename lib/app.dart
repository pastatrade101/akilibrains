
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trade101/routes/app_routes.dart';
import 'package:trade101/utils/constants/colors.dart';
import 'package:trade101/utils/constants/text_strings.dart';
import 'package:trade101/utils/theme/theme.dart';

import 'bindings/general_bindings.dart';
import 'common/scroll/schroll_behaviour.dart';
import 'features/authentication/personalization/controllers/setting_controller.dart';



class App extends StatelessWidget {
  const App({super.key});



  @override
  Widget build(BuildContext context) {
    final settingController  = Get.put(SettingController());
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    return GetMaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
        title: TTexts.appName,
        themeMode: ThemeMode.system,
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        initialBinding: GeneralBindings(),
        getPages: AppRoutes.pages,
        home: const Scaffold(
          backgroundColor: TColors.primary,
          body: Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ),
      );

  }
}
