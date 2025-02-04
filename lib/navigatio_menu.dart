import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gluco_care/src/features/screens/home/Alarma/alarm_screen.dart';
import 'package:gluco_care/src/features/screens/home/Educacion/educacion.dart';
import 'package:gluco_care/src/features/screens/home/Registros/menu_reg.dart';
import 'package:gluco_care/src/features/screens/home/home.dart';
import 'package:gluco_care/src/utils/constants/colors.dart';
import 'package:gluco_care/src/utils/theme/custom_themes/help_functions.dart';
import 'package:iconsax/iconsax.dart';

class NavigatioMenu extends StatelessWidget {
  const NavigatioMenu({super.key});
  


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigatioController());
    final darkMode = THelperFuctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectIndex.value,
          onDestinationSelected: (index) => controller.selectIndex.value = index,
          backgroundColor: darkMode ? TColors.black : TColors.white,
          indicatorColor: darkMode ? TColors.white.withOpacity(0.1) : TColors.black.withOpacity(0.1),

          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home',),
            NavigationDestination(icon: Icon(Iconsax.receipt), label: 'Registros',),
            NavigationDestination(icon: Icon(Iconsax.book), label: 'Educación',),
            NavigationDestination(icon: Icon(Iconsax.alarm), label: 'Recordatorios',),
          ],
        ),
      ),
      body: Obx (() => controller.screens[controller.selectIndex.value]),
    );
  }
}

class NavigatioController extends GetxController{
  final Rx<int> selectIndex = 0.obs;

  final screens = [const HomeScreen(), const MainMenuScreen(), const DiabetesEducationPage(),  const AlarmScreen()];
}