import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:gluco_care/src/utils/popups/loander.dart';

/// Gestiona el estado de conectividad de red y proporciona métodos para verificar y manejar los cambios de conectividad.
class NetworkManager extends GetxController {
  static NetworkManager get instance => Get.find();
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final Rx<ConnectivityResult> _connectionStatus = ConnectivityResult.none.obs;

  /// Inicializa el gestor de red y configura un stream para comprobar continuamente el estado de la conexión.
  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  /// Actualiza el estado de la conexión en función de los cambios en la conectividad y muestra un popup relevante para la falta de conexión a internet.
  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    _connectionStatus.value = result as ConnectivityResult;
    if (_connectionStatus.value == ConnectivityResult.none) {
      TLoaders.warningSnackBar(title: 'Sin Conexión a Internet');
    }
  }

  /// Verifica el estado de la conexión a internet.
  /// Retorna 'true' si está conectado, 'false' en caso contrario.
  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      // ignore: unrelated_type_equality_checks
      if (result == ConnectivityResult.none) {
        return false;
      } else {
        return true;
      }
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Dispose o cierra el stream de conectividad activo.
  @override
  void onClose() {
    super.onClose();
    _connectivitySubscription.cancel();
  }
}
