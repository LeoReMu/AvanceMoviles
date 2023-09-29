import 'package:flutter/widgets.dart';
import 'package:moviles/Screens/Inicio_sesion.dart';
import 'package:moviles/Screens/Registro.dart';
import 'package:moviles/Splash/Splash.dart';
import 'package:moviles/request_permission/request_permission.dart';
import 'package:moviles/routes/routes.dart';
import 'package:moviles/Screens/home_page.dart';

Map<String, Widget Function(BuildContext)> appRoutes() {
  return {
    routes.SPLASH: (_) => const SplashPage(),
    routes.PERMISSIONS: (_) => const RequestPermissionpage(),
    routes.HOME: (_) => MapScreen(),
    routes.INICIARSESION: (_) => LoginWidget(),
    routes.REGISTRARSE: (_) => RegisterScreen(),
  };
}
