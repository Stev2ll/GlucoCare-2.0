import 'package:get/get.dart';
import 'package:gluco_care/src/features/authentication/controllers/signup/network_manager.dart';

class GeneralBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(NetworkManager());
  }

}