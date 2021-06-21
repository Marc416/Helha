import 'package:get/get.dart';
import 'package:helha/Widgets/sign_up_widget.dart';

import '../Widgets/login_widget.dart';
import 'Routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => LoginWidget(),
      // page: () => FileManagerWidget(),
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => SignUp(),
      // page: () => FileManagerWidget(),
    ),
  ];
}
