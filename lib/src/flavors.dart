import 'package:dashboard/src/core/constants/app_images.dart';

enum FlavorEmun { development, staging, production }

class FlavorsConfig {
  static late final FlavorEmun appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case FlavorEmun.development:
        return 'Dev. Manejo de fondos';
      case FlavorEmun.staging:
        return 'Stg. Manejo de fondos';
      case FlavorEmun.production:
        return 'Manejo de fondos';
    }
  }

  static String get iconApp {
    switch (appFlavor) {
      case FlavorEmun.development:
        return AppImages.appIconDev;
      case FlavorEmun.staging:
        return AppImages.appIconStg;
      case FlavorEmun.production:
        return AppImages.appIcon;
    }
  }
}
