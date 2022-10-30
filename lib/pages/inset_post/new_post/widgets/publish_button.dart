import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nochba/pages/inset_post/new_post/new_post_controller.dart';

class PublishButton extends StatefulWidget {
  final bool isPublishing;
  const PublishButton({
    Key? key,
    required this.controller,
    this.isPublishing = false,
  }) : super(key: key);

  final NewPostController controller;

  @override
  _PublishButtonState createState() => _PublishButtonState();
}

//creete a state class _PublishButtonState which is a bool isLoading and when its true show a circular progress indicator
class _PublishButtonState extends State<PublishButton> {
  @override
  Widget build(BuildContext context) {
    return //when isloading is false show button when true show a container and inside a loading button

        widget.isPublishing
            ? // show a container primery color and inside a circular progress indicator in white color and 12 radius
            Container(
                // round corders 12
                // max height and width
                height: 50,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).primaryColor,

                  //height 60
                ),

                child: Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              )
            : ElevatedButton.icon(
                onPressed: //controller.addPost() and go to
                    () {
                  widget.controller.addPost();
                  // controller.pageController.nextPage(
                  //     duration: const Duration(milliseconds: 1),
                  //     curve: Curves.easeInOut);
                  //controller.jumpToPage(4);
                  //close keyboard
                  FocusScope.of(context).unfocus();
                  // Get.to(PublishedNewPostView());
                },
                icon: Icon(
                  Icons.done_outlined,
                ),
                label: Text(
                  'Veröffentlichen',
                  style: Theme.of(context).textTheme.button?.copyWith(
                        color: Theme.of(context)
                            .buttonTheme
                            .colorScheme
                            ?.onPrimary,
                        letterSpacing: -0.07,
                      ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  minimumSize: const Size.fromHeight(60),
                  shadowColor: Colors.transparent,
                  // primary: Theme.of(context).buttonTheme.colorScheme?.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                ),
              );
  }
}
