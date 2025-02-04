import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gluco_care/src/features/screens/login/login.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  // Variables
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  // Actualiza el índice actual cuando la página se desplaza
  void updatePageIndicator(int index) => currentPageIndex.value = index;

  // Salta a la página específica seleccionada por el punto
  void dotNavigationClick(int index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }

  // Actualiza el índice actual cuando la página se desplaza
  void nextPage() {
    if (currentPageIndex.value == 2) {
      final storage = GetStorage();

      if (kDebugMode) {
        {
          print('=========== GET STORAGE NETX BUTTON ===========');
          print(storage.read('PrimerTiempo'));
        }

        storage.write('PrimerTiempo', false);

        Get.offAll(() => const LoginScreen()); // Cambiado aquí
      } else {
        int page = currentPageIndex.value + 1;
        pageController.jumpToPage(page);
      }
    }
  }

  // Salta a la página de omisión
  void skipPage() {
    currentPageIndex.value = 2;
    pageController.jumpToPage(2);
  }
}
