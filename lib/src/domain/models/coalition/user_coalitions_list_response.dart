import 'package:equatable/equatable.dart';
import 'package:swifty_companion/src/domain/models/coalition/coalition.dart';

class UserCoalitionListResponse extends Equatable {
  final List<Coalition> coalitions;


  const UserCoalitionListResponse({
    required this.coalitions,
  });


  factory UserCoalitionListResponse.fromMap(List<dynamic> map) {
    //logger.d(items);
    return UserCoalitionListResponse(
      coalitions: List<Coalition>.from((map).map<dynamic>((element) {
        return Coalition.fromMap(element);
      }))..sort((a, b) => b.score - a.score),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [coalitions];

}