import 'package:get/get.dart';

class AppController extends GetxController {
  // Counter
  final RxInt count = 0.obs;

  // Selected package
  final RxString selectedPackage = 'GetX'.obs;

  // Increase counter
  void increment() {
    count.value++;
  }

  // Decrease counter
  void decrement() {
    if (count.value > 0) {
      count.value--;
    }
  }

  // Select package
  void selectPackage(String name) {
    selectedPackage.value = name;
  }
}