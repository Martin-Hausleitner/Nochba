class Tag {
  String id;
  final String tag;

  Tag({this.id = '', required this.tag});

  Map<String, dynamic> toJson() => {
    'id': id,
    'tag': tag,
  };

  static Tag fromJson(Map<String, dynamic> json) => 
  Tag(id: json['id'], tag: json['tag']);
}