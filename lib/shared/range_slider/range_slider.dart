import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Slider1 extends StatelessWidget {
  const Slider1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SliderController sx = Get.put(SliderController());

    return SizedBox(
      child: Column(children: [
        Obx(
          () => SliderTheme(
            data: const SliderThemeData(
              trackHeight: 5,
            ),
            child: Slider(
              value: sx.range.value,
              min: 0.0, //initialized it to a double
              max: 255.0, //initialized it to a double
              thumbColor: Colors.white,
              activeColor: Theme.of(context).primaryColor,
              inactiveColor: Colors.grey.shade300,
              divisions: 7,

              label: sx.range.round().toString(),
              onChanged: (double value) {
                sx.setRange(value);
              },
            ),
          ),
        )
      ]),
    );
  }
}

class SliderController extends GetxController {
  Rx<double> range = 255.0.obs; //again initialized it to a Rx<double>

  void setRange(double range) {
    this.range.value = range; //updating the value of Rx Variable.
  }
}
