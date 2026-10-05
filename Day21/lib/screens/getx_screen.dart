import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../app_router.dart';
import '../controllers/app_controller.dart';

class GetXScreen extends StatelessWidget {
  const GetXScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('GetX Example'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Icon(
              Icons.settings,
              size: 50,
            ),

            const SizedBox(height: 15),

            const Text(
              'GetX State Management',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            // Counter
            Obx(
                  () => Text(
                'Counter: ${controller.count.value}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (controller.count.value > 0) {
                      controller.count.value--;
                    }
                  },
                  child: const Text('-'),
                ),

                const SizedBox(width: 15),

                ElevatedButton(
                  onPressed: controller.increment,
                  child: const Text('+'),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Package selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Reactive Package Selection',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Obx(
                          () => DropdownButton<String>(
                        value: controller.selectedPackage.value,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(
                            value: 'GetX',
                            child: Text('GetX'),
                          ),
                          DropdownMenuItem(
                            value: 'Dio',
                            child: Text('Dio'),
                          ),
                          DropdownMenuItem(
                            value: 'Hive',
                            child: Text('Hive'),
                          ),
                          DropdownMenuItem(
                            value: 'Freezed',
                            child: Text('Freezed'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectPackage(value);
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    Obx(
                          () => Text(
                        'Selected: ${controller.selectedPackage.value}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Go to Product Details
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  const ProductDetailsRoute(
                    id: '42',
                  ).go(context);
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text(
                  'Go to Details',
                ),
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'GetX is used here for reactive state management.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}