import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nochba/pages/auth/register/views/sign_up_app_bar_view.dart';
import 'package:nochba/pages/auth/register/views/sign_up_verified_view.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';

import 'sign_up_controller.dart';
import 'views/sign_up_step_1_view.dart';
import 'views/sign_up_step_2_view.dart';
import 'views/sign_up_step_3_view.dart';
import 'views/sign_up_step_4_view.dart';

class NewSignUpPage extends GetView<SignUpController> {
  const NewSignUpPage({Key? key /*, required this.onClicked*/})
      : super(key: key);
  //final VoidCallback onClicked;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SignUpStep1View(
          controller: controller,
          onPressedBack: () => controller.getBack(),
        ),
        SignUpStep2View(
          controller: controller,
          onPressedBack: () => controller.getBack(),
        ),
        SignUpStep3View(
          controller: controller,
          onPressedBack: () => controller.getBack(),
        ),
        
        SignUpStep4View(
          controller: controller,
          onPressedBack: () => controller.getBack(),
        ),
        SignUpVerifiedView(
          controller: controller,
          onPressedBack: () => controller.getBack(),
        ),

        // NewPostCategorySelectionView(),
        // NewPostSubcategorySelectionView(),
        // NewPostView(),
        //PublishedNewPostView(),
        // AppBarBigView(title: 'title', children: [
        //   Text('data1'),
        //   //button which got to next page
        //   TextButton(
        //     onPressed: () {
        //       controller.nextPage();
        //     },
        //     child: const Text('Next'),
        //   ),
        // ]),
        // AppBarBigView(title: 'title', children: [Text('data2')]),
        // AppBarBigView(title: 'title', children: [Text('data3')]),
        // AppBarBigView(title: 'title', children: [Text('data4')])
      ],
    );
  }
}
