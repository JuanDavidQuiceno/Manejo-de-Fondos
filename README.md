# dashboard

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

flutter native splash
- dart run flutter_native_splash:create --flavors development,staging,production

flutter new app icon
- dart run flutter_launcher_icons:main -f flutter_launcher_icons*

Ejecución del script FlutterFire para cada sabor
- ./flutterfire-config.sh dev
- ./flutterfire-config.sh stg
- ./flutterfire-config.sh prod

app bundle
- flutter build appbundle  --flavor development --target=lib/main_development.dart --dart-define-from-file=api-key-dev.json

- flutter build appbundle  --flavor staging --target=lib/main_staging.dart --dart-define-from-file=api-key-stg.json

- flutter build appbundle  --flavor production --target=lib/main_production.dart --dart-define-from-file=api-key-prod.json

apk
- flutter build apk --split-per-abi --flavor development --target=lib/main_development.dart --dart-define-from-file=api-key-dev.json

- flutter build apk --split-per-abi --flavor staging --target=lib/main_staging.dart --dart-define-from-file=api-key-stg.json

- flutter build apk --split-per-abi --flavor production --target=lib/main_production.dart --dart-define-from-file=api-key-prod.json



Ios
- flutter build ipa --flavor development --target=lib/main_development.dart --dart-define-from-file=api-key-dev.json
- flutter build ipa --flavor staging --target=lib/main_staging.dart --dart-define-from-file=api-key-stg.json
- flutter build ipa --flavor production --target=lib/main_production.dart --dart-define-from-file=api-key-prod.json

luego ejecuta
open ./build/ios/archive/Runner.xcarchive
