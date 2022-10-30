import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingPost extends StatelessWidget {
  const LoadingPost({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      //create two text children
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          //align left
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //create a box with round corners inside a Shimmer
            Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.onSurface,
              highlightColor: Theme.of(context).colorScheme.onPrimary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.035),
                    ),
                  ),
                  const SizedBox(height: 13),
                  Container(
                    height: 18,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.035),
                    ),
                  ),
                  const SizedBox(height: 13),
                  Row(
                    children: [
                      //create a circle with a shimmer
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.035),
                        ),
                      ),
                      const SizedBox(width: 10),
                      //create a box with a shimmer
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 18,
                            width: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.035),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            height: 14,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.035),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 13),
                  Container(
                    height: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.035),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.035),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 18,
                    width: // 3/4 media width
                        MediaQuery.of(context).size.width * 0.75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.035),
                    ),
                  ),
                  SizedBox(height: 13),
                  // row with 3 circles on the left and 1 on the right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 34,
                            width: 34,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.035),
                            ),
                          ),
                          SizedBox(width: 30),
                          Container(
                            height: 34,
                            width: 34,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.035),
                            ),
                          ),
                          SizedBox(width: 30),
                          Container(
                            height: 34,
                            width: 34,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.035),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.035),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Shimmer.fromColors(
            //   baseColor: Theme.of(context).colorScheme.onSurface,
            //   highlightColor: Theme.of(context).colorScheme.onPrimary,
            //   child:
            // ),

            //create a row with a circle and a box
          ],
        ),
      ),
    );
  }
}
