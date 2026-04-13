#!/bin/bash
# Script to generate Firebase configuration files for different environments/flavors
# Feel free to reuse and adapt this script for your own projects

if [[ $# -eq 0 ]]; then
  echo "Error: No environment specified. Use 'dev', 'stg', or 'prod'."
  exit 1
fi

case $1 in
  dev)
    flutterfire config \
      --project=feat-dev-95ad8 \
      --out=lib/firebase_options_dev.dart \
      --ios-bundle-id=com.xlabon.featDistribuidores.dev \
      --ios-out=ios/flavors/development/GoogleService-Info.plist \
      --android-package-name=com.xlabon.feat_distribuidores.dev \
      --android-out=android/app/src/development/google-services.json
    ;;
  stg)
    flutterfire config \
      --project=feat-stg \
      --out=lib/firebase_options_stg.dart \
      --ios-bundle-id=com.xlabon.featDistribuidores.stg \
      --ios-out=ios/flavors/staging/GoogleService-Info.plist \
      --android-package-name=com.xlabon.feat_distribuidores.stg \
      --android-out=android/app/src/staging/google-services.json
    ;;
  prod)
    flutterfire config \
      --project=feat-prod \
      --out=lib/firebase_options_prod.dart \
      --ios-bundle-id=com.xlabon.featDistribuidores \
      --ios-out=ios/flavors/production/GoogleService-Info.plist \
      --android-package-name=ccom.xlabon.feat_distribuidores \
      --android-out=android/app/src/production/google-services.json
    ;;
  *)
    echo "Error: Invalid environment specified. Use 'dev', 'stg', or 'prod'."
    exit 1
    ;;
esac