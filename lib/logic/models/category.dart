/*class Category {
  String id;
  final String category;

  Category({this.id = '', required this.category});

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
  };

  static Category fromJson(Map<String, dynamic> json) => 
  Category(id: json['id'], category: json['category']);
}*/

class CategoryModul {
  static CategoryOptions message = CategoryOptions.Message;
  static CategoryOptions search = CategoryOptions.Search;
  static CategoryOptions lending = CategoryOptions.Lending;
  static CategoryOptions event = CategoryOptions.Event;

  static List<CategoryOptions> subCategoriesOfMessage = [CategoryOptions.Question, CategoryOptions.Appeal, CategoryOptions.Warning, CategoryOptions.Recommendation, CategoryOptions.Found];
  static List<CategoryOptions> subCategoriesOfSearch = [CategoryOptions.Help, CategoryOptions.Lost];
  static List<CategoryOptions> subCategoriesOfLending = [];
  static List<CategoryOptions> subCategoriesOfEvent = [];

  static List<CategoryOptions> subCategories = subCategoriesOfMessage + subCategoriesOfSearch + subCategoriesOfLending + subCategoriesOfEvent;

  static getCategoryOptionByName(String category) {
    if(CategoryOptions.Message.name.toString() == category) {
      return CategoryOptions.Message;
    } else if(CategoryOptions.Question.name.toString() == category) {
      return CategoryOptions.Question;
    } else if(CategoryOptions.Appeal.name.toString() == category) {
      return CategoryOptions.Appeal;
    } else if(CategoryOptions.Warning.name.toString() == category) {
      return CategoryOptions.Warning;
    } else if(CategoryOptions.Recommendation.name.toString() == category) {
      return CategoryOptions.Recommendation;
    } else if(CategoryOptions.Found.name.toString() == category) {
      return CategoryOptions.Found;
    } else if(CategoryOptions.Search.name.toString() == category) {
      return CategoryOptions.Search;
    } else if(CategoryOptions.Help.name.toString() == category) {
      return CategoryOptions.Help;
    } else if(CategoryOptions.Lost.name.toString() == category) {
      return CategoryOptions.Lost;
    } else if(CategoryOptions.Lending.name.toString() == category) {
      return CategoryOptions.Lending;
    } else if(CategoryOptions.Event.name.toString() == category) {
      return CategoryOptions.Event;
    } else {
      return CategoryOptions.Other;
    }
  }
}

enum CategoryOptions {
  None,
  Message,
    Question,
    Appeal,
    Warning,
    Recommendation,
    Found,
  Search,
    Help,
    Lost,
  Lending,
  Event,
  Other
}