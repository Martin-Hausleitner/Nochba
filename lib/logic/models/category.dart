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
      CategoryOptions categoryOption) {
    if (subCategoriesOfSearch.contains(categoryOption)) {
      return CategoryModul.search;
    } else if (subCategoriesOfMessage.contains(categoryOption)) {
      return CategoryModul.message;
    } else if (subCategoriesOfEvent.contains(categoryOption)) {
      return CategoryModul.event;
    } else if (subCategoriesOfLending.contains(categoryOption)) {
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
    if (CategoryOptions.Message.name == category) {
      return CategoryOptions.Message;
    } else if (CategoryOptions.Question.name == category) {
      return CategoryOptions.Question;
    } else if (CategoryOptions.Appeal.name == category) {
      return CategoryOptions.Appeal;
    } else if (CategoryOptions.Warning.name == category) {
      return CategoryOptions.Warning;
    } else if (CategoryOptions.Recommendation.name == category) {
      return CategoryOptions.Recommendation;
    } else if (CategoryOptions.Found.name == category) {
      return CategoryOptions.Found;
    } else if (CategoryOptions.Search.name == category) {
      return CategoryOptions.Search;
    } else if (CategoryOptions.Help.name == category) {
      return CategoryOptions.Help;
    } else if (CategoryOptions.Lost.name == category) {
      return CategoryOptions.Lost;
    } else if (CategoryOptions.Lending.name == category) {
      return CategoryOptions.Lending;
    } else if (CategoryOptions.Event.name == category) {
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
