import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nochba/logic/models/category.dart';

class CategoryBadge extends StatelessWidget {
  final CategoryOptions category;

  const CategoryBadge({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    switch (category) {
      // case CategoryOptions.Message:
      //   backgroundColor = Colors.blue[100]!;
      //   textColor = Colors.blue[800]!;
      //   break;
      case CategoryOptions.Question:
        backgroundColor = Colors.blue[100]!;
        textColor = Colors.blue[800]!;
        break;
      case CategoryOptions.Appeal:
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[800]!;
        break;
      case CategoryOptions.Warning:
        backgroundColor = Colors.amber[100]!;
        textColor = Colors.amber[800]!;
        break;
      case CategoryOptions.Recommendation:
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[800]!;
        break;
      case CategoryOptions.Found:
        backgroundColor = Colors.teal[100]!;
        textColor = Colors.teal[800]!;
        break;
      // case CategoryOptions.Search:
      //   backgroundColor = Colors.orange[100]!;
      //   textColor = Colors.orange[800]!;
      //   break;
      case CategoryOptions.Help:
        backgroundColor = Colors.lightBlue[100]!;
        textColor = Colors.lightBlue[800]!;
        break;
      case CategoryOptions.Lost:
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[800]!;
        break;
      case CategoryOptions.Lending:
        backgroundColor = Colors.lightBlue[100]!;
        textColor = Colors.lightBlue[800]!;
        break;
      case CategoryOptions.Event:
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[800]!;
        break;
      default:
        backgroundColor = Colors.grey[100]!;
        textColor = Colors.grey[800]!;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        CategoryModul.getCategoryName(category),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
