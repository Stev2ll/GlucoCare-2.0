# gluco_care

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
# GlucoCare

# PAQUETES DE DEPENDENCIA NECESARIOS

DEPENDENCIES:
  http: ^1.2.1
  intl: ^0.19.0
  logger: ^2.3.0
  url_launcher: ^6.3.0
  flutter_native_splash: ^2.4.0

  #Icons
  iconsax: ^0.0.8
  cupertino_icons: ^1.0.8

  #State Management
  get: ^4.6.6
  get_storage: ^2.1.1


# Archivo splash.yaml
Para su creeacion se debe ejectutar 
flutter pub run flutter_native_splash:create --path=splash.yaml
y borrar el de preferencia
flutter pub run flutter_native_splash:remove# GlucoCare

# Iniciar/Cerrar sesion FireBase
npm install -g firebase-tools
firebase login - firebase logout starstreaming593@gmail.com
dart pub global deactivate flutterfire_cli
dart pub global activate flutterfire_cli
flutterfire configure 

# Agregar Huella Digital Android cosola
keytool -list -v -keystore "C:\Users\Steven\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

#Iniciar para uso del Firestore
flutter pub add cloud_firestore
flutter pub add firebase_auth