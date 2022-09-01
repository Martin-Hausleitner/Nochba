import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  // add onPressedInfo
  // final VoidCallback onPressedInfo;

  const CategoryTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
                SizedBox(height: 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                ),
              ],
            ),
          ),
          //icon button information-line
          // Positioned(
          //   bottom: 0,
          //   right: 0,
          //   child: IconButton(
          //     splashRadius: 10,
          //     icon: Icon(
          //       FlutterRemix.information_line,
          //       color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
          //       size: 20,
          //     ),
          //     onPressed: onPressedInfo,
          //   ),
          // ),
        ],
      ),
    );
  }
}