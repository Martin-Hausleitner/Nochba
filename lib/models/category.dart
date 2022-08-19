class Category {
  String id;
  final String category;

  Category({this.id = '', required this.category});

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
  };

  static Category fromJson(Map<String, dynamic> json) => 
  Category(id: json['id'], category: json['category']);
}

enum CategoryOptions {
  None,
  Message,
  Question,
  Appeal,
  Warning,
  Recommendation,
  Found,
  Lending,
  Event,
  Search,
  Help,
  Lost
}