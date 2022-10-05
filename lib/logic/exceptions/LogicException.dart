import 'package:nochba/logic/exceptions/LogicExceptionType.dart';

class LogicException implements Exception {
  const LogicException(this.type, {this.message});

  final LogicExceptionType type;
  final String? message;
}
