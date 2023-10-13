import 'package:animation_login_samples/all_controllers/home_controller.dart';
import 'package:get/get.dart';

class ControllerBindings extends Bindings{
  @override
  void dependencies() {
    Get.put(HomeController());
    // TODO: implement dependencies
  }

}