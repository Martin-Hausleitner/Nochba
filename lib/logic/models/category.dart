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

  static List<CategoryOptions> subCategoriesOfMessage = [
    CategoryOptions.Question,
    CategoryOptions.Appeal,
    CategoryOptions.Warning,
    CategoryOptions.Recommendation,
    CategoryOptions.Found
  ];
  static List<CategoryOptions> subCategoriesOfSearch = [
    CategoryOptions.Help,
    CategoryOptions.Lost
  ];
  static List<CategoryOptions> subCategoriesOfLending = [];
  static List<CategoryOptions> subCategoriesOfEvent = [];

  static List<CategoryOptions> mainCategories = [
    message,
    search,
    lending,
    event
  ];

  static List<CategoryOptions> subCategories = subCategoriesOfMessage +
      subCategoriesOfSearch +
      subCategoriesOfLending +
      subCategoriesOfEvent;

  static bool isMainCategory(CategoryOptions categoryOptions) {
    return mainCategories.contains(categoryOptions);
  }

  static bool isSubCategory(CategoryOptions categoryOptions) {
    return subCategories.contains(categoryOptions);
  }

  static CategoryOptions getMainCategoryOfSubCategory(
      CategoryOptions categoryOptions) {
    if (subCategoriesOfSearch.contains(categoryOptions)) {
      return CategoryModul.search;
    } else if (subCategoriesOfMessage.contains(categoryOptions)) {
      return CategoryModul.message;
    } else if (subCategoriesOfEvent.contains(categoryOptions)) {
      return CategoryModul.event;
    } else if (subCategoriesOfLending.contains(categoryOptions)) {
      return CategoryModul.lending;
    } else {
      return CategoryOptions.None;
    }
  }

  static List<CategoryOptions> getSubCategoriesOfMainCategory(
      CategoryOptions categoryOptions) {
    if (categoryOptions == CategoryModul.message) {
      return CategoryModul.subCategoriesOfMessage;
    } else if (categoryOptions == CategoryModul.search) {
      return CategoryModul.subCategoriesOfSearch;
    } else if (categoryOptions == CategoryModul.event) {
      return CategoryModul.subCategoriesOfEvent;
    } else if (categoryOptions == CategoryModul.lending) {
      return CategoryModul.subCategoriesOfLending;
    } else {
      return [];
    }
  }

  static CategoryOptions getCategoryOptionByName(String category) {
    if (CategoryOptions.Message.name.toString() == category) {
      return CategoryOptions.Message;
    } else if (CategoryOptions.Question.name.toString() == category) {
      return CategoryOptions.Question;
    } else if (CategoryOptions.Appeal.name.toString() == category) {
      return CategoryOptions.Appeal;
    } else if (CategoryOptions.Warning.name.toString() == category) {
      return CategoryOptions.Warning;
    } else if (CategoryOptions.Recommendation.name.toString() == category) {
      return CategoryOptions.Recommendation;
    } else if (CategoryOptions.Found.name.toString() == category) {
      return CategoryOptions.Found;
    } else if (CategoryOptions.Search.name.toString() == category) {
      return CategoryOptions.Search;
    } else if (CategoryOptions.Help.name.toString() == category) {
      return CategoryOptions.Help;
    } else if (CategoryOptions.Lost.name.toString() == category) {
      return CategoryOptions.Lost;
    } else if (CategoryOptions.Lending.name.toString() == category) {
      return CategoryOptions.Lending;
    } else if (CategoryOptions.Event.name.toString() == category) {
      return CategoryOptions.Event;
    } else {
      return CategoryOptions.None;
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
