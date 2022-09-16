// create a PostBadge class with a blue badge and text 'New'

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:locoo/logic/models/category.dart';

/*enum Category {
  mitteilung,
  suche,
  warnung,
}*/

class CategoryBadge extends StatelessWidget {
  //creat a enum with Mitteilung und suche
  final CategoryOptions category;

  const CategoryBadge({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // return a text with a gray border with rounded corners and a padding left 5 right 5
      padding: const EdgeInsets.only(top: 2.7, bottom: 3, left: 11, right: 11),
      // add a border to the right side of the text

      decoration: BoxDecoration(
        //add a border to the right

        //background color is blue
        color: //when the category is  Mitteilung return a color of Colors.blue[100], when the category is suche return a color of Colors.green[100], when the category is warnung return a color of Colors.red[100]
            category == CategoryModul.message || CategoryModul.subCategoriesOfMessage.contains(category)
                ? Colors.blue[100] : 
            category == CategoryModul.search || CategoryModul.subCategoriesOfSearch.contains(category)
                ? Colors.green[100] :
            category == CategoryModul.event || CategoryModul.subCategoriesOfEvent.contains(category)
                ? Colors.red[100] :
            category == CategoryModul.lending || CategoryModul.subCategoriesOfLending.contains(category)
                ? Colors.orange[100] :
                Colors.grey[100],

        borderRadius: BorderRadius.circular(10),
      ),

      // return a text with a fontSize of 12 with a fontWeight of FontWeight.w600 and a color of Colors.white and a child of Text with a text of 'New'
      child: Text(
        //weth the category is Mitteilung return a text of 'Mitteilung', when the category is suche return a text of 'Suche', when the category is warnung return a text of 'Warnung'
        /*category == Category.mitteilung
            ? 'Mitteilung'
            : category == Category.suche
                ? 'Suche'
                : 'Warnung',*/
        category.name.toString(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: //when the category is  Mitteilung return a color of Colors.blue[900], when the category is suche return a color of Colors.white, when the category is leihen return a color of Colors.red
              category == CategoryModul.message || CategoryModul.subCategoriesOfMessage.contains(category)
                ? Colors.blue[800] : 
              category == CategoryModul.search || CategoryModul.subCategoriesOfSearch.contains(category)
                ? Colors.green[800] :
              category == CategoryModul.event || CategoryModul.subCategoriesOfEvent.contains(category)
                ? Colors.red[800] :
              category == CategoryModul.lending || CategoryModul.subCategoriesOfLending.contains(category)
                ? Colors.orange[800] :
                Colors.grey[800],
        ),
        // return a text with a fontSize of 12 with a fontWeight of FontWeight.w600 and a color of Colors.white and a child of Text with a text of 'New'
      ),
    );
  }
}
