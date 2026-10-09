import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class FailureWithMsg extends Failure {
  final String msg;

  FailureWithMsg(this.msg);
  @override
  List<Object?> get props => [msg];

  @override
  String toString() {
    return msg;
  }
}
