import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:locoo/shared/ui/locoo_circle_avatar.dart';

class NotificationElement extends StatelessWidget {
  final String? imageUrl;
  final String authorName;
  final String notificationText;
  final String time;
  final VoidCallback? acceptButtonOnPressed;
  final VoidCallback? declineButtonOnPressed;

  const NotificationElement({
    Key? key,
    this.imageUrl,
    required this.authorName,
    required this.notificationText,
    required this.time,
    this.acceptButtonOnPressed,
    this.declineButtonOnPressed,
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
                          child:
                              // Text(
                              //   authorName,
                              //   maxLines: 2,
                              //   overflow: TextOverflow.ellipsis,
                              //   style: Theme.of(context).textTheme.titleSmall,
                              // ),
                              Text(
                            authorName,
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
                      height: 5,
                    ),
                    Text(
                      notificationText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                    ),

                    // show row when accecptButtonOnPressed or declineButtonOnPressed is not null
                    if (acceptButtonOnPressed != null ||
                        declineButtonOnPressed != null)
                      Padding(
                        padding: // top 8
                            const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: acceptButtonOnPressed,
                              icon: Icon(
                                FlutterRemix.check_line,
                                size: 16,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              label: Text(
                                'Akzeptieren',
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .buttonTheme
                                          .colorScheme
                                          ?.onPrimary,
                                      letterSpacing: 0.1,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),

                                shadowColor: Colors.transparent,
                                // primary: Theme.of(context).buttonTheme.colorScheme?.primary,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            OutlinedButton.icon(
                              onPressed: declineButtonOnPressed,
                              icon: Icon(
                                FlutterRemix.close_line,
                                size: 16,
                                // color: Theme.of(context)
                                //     .buttonTheme
                                //     .colorScheme
                                //     ?.onPrimary,
                              ),
                              label: Text(
                                'Ablehmen',
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    ?.copyWith(
                                      // color: Theme.of(context)
                                      //     .buttonTheme
                                      //     .colorScheme
                                      //     ?.onPrimary,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.8),
                                      letterSpacing: 0.1,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              //padding 1
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),

                                // primary: Theme.of(context).buttonTheme.colorScheme?.primary,
                              ),
                            ),
                          ],
                        ),
                      )
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
