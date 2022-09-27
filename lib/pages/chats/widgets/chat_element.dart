import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:locoo/shared/ui/locoo_circle_avatar.dart';

class ChatElement extends StatelessWidget {
  final String? imageUrl;
  final String roomName;
  final String lastMessage;
  final String? time;
  final VoidCallback? onTapped;
  final int? notificationCount;

  const ChatElement({
    Key? key,
    this.imageUrl,
    required this.roomName,
    required this.lastMessage,
    this.time,
    this.onTapped,
    this.notificationCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            // top
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LocooCircleAvatar(
                // imageUrl: authorImage,
                radius: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  //start
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      //space between
                      //start
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            roomName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.3,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.88),
                                    ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              FlutterRemix.time_line,
                              size: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.4),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 2),
                              child: Row(
                                children: [
                                  Text(
                                    '2',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.4),
                                        ),
                                  ),
                                  Text(
                                    'min',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.4),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lastMessage,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.6),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        if (notificationCount != null)
                          // if the notification count is larger then 99 show 99+ else show container
                          if (notificationCount! > 99)
                            Container(
                              height: 20,
                              width: 32,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  '99+',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            )
                          else
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  notificationCount.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ),
                        // Container(
                        //   height: 22,
                        //   width: 22,
                        //   decoration: BoxDecoration(
                        //     color: Theme.of(context).primaryColor,
                        //     borderRadius: BorderRadius.circular(120),
                        //   ),
                        //   child: Center(
                        //     child: Text(
                        //       notificationCount.toString(),
                        //       style: Theme.of(context)
                        //           .textTheme
                        //           .bodySmall
                        //           ?.copyWith(
                        //             color: Theme.of(context)
                        //                 .colorScheme
                        //                 .onSecondary,
                        //             fontSize: 10,
                        //             fontWeight: FontWeight.w600,
                        //           ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),

                    // show row when accecptButtonOnPressed or declineButtonOnPressed is not null
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Container(
              height: 0.8,
              width: 15,
              color: Colors.transparent,
            ),
            Expanded(
              child: Container(
                height: 0.8,
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.06),
              ),
            ),
            Container(
              height: 0.8,
              width: 15,
              color: Colors.transparent,
            ),
          ],
        ),
      ],
    );
  }
}
