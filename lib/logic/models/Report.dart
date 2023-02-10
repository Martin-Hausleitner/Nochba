import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nochba/logic/interfaces/IModel.dart';

enum ReportType { none, user, post, comment }

class Report implements IModel {
  @override
  String id;
  final String fromUser;
  final String reportedId;
  final ReportType type;
  final String reason;
  final Timestamp createdAt;
  final bool visible;

  Report({
    this.id = '',
    required this.fromUser,
    required this.reportedId,
    required this.type,
    required this.reason,
    required this.createdAt,
    this.visible = true,
  });

  @override
  Map<String, dynamic> toJson() => {
        'fromUser': fromUser,
        'reportedId': reportedId,
        'type': type.name,
        'reason': reason,
        'createdAt': createdAt,
        'visible': visible,
      };

  factory Report.fromJson(String id, Map<String, dynamic> json) => Report(
        id: id,
        fromUser: json['fromUser'],
        reportedId: json['reportedId'],
        type: getReportType(json['type']),
        reason: json['reason'],
        createdAt: json['createdAt'],
        visible: json['visible'],
      );

  static ReportType getReportType(String keyword) {
    if (keyword == ReportType.user.name) {
      return ReportType.user;
    } else if (keyword == ReportType.post.name) {
      return ReportType.post;
    } else if (keyword == ReportType.comment.name) {
      return ReportType.comment;
    } else {
      return ReportType.none;
    }
  }

  static List<String> reasonsForReport = <String>[
    'Unangebrachter Inhalt',
    'Belästigung',
    'Betrug',
    'Spam',
    'Sonstiges'
  ];
}
