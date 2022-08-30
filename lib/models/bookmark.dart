class BookMark {
  String id;
  final List<String> posts;

  BookMark({this.id = '', required this.posts});

  Map<String, dynamic> toJson() => {
    'id': id,
    'posts': posts,
  };

  static BookMark fromJson(Map<String, dynamic> json) => 
  BookMark(id: json['id'], posts: List.castFrom<dynamic, String>(json['posts']));
}