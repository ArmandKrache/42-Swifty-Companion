import 'package:equatable/equatable.dart';
import 'package:swifty_companion/src/config/config.dart';

class Student extends Equatable {
  final int id;
  final String email;
  final String login;
  final String displayName;
  final String picture;

  const Student({
    required this.id,
    required this.email,
    required this.login,
    required this.displayName,
    required this.picture,
  });


  factory Student.fromMap(Map<String, dynamic> map) {
    logger.d(map);
    return Student(
      id: map['id'] ?? -1,
      email: map['email'] ?? "",
      login: map['login'] ?? "",
      displayName: map['displayname'] ?? "",
      picture: map['image']?['link'] ?? "",
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [login];

}