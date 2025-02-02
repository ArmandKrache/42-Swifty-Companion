import 'package:equatable/equatable.dart';
import 'package:swifty_companion/src/domain/models/coalition/coalition.dart';

class CampusCoalitionListResponse extends Equatable {
  final List<Coalition> coalitions;


  const CampusCoalitionListResponse({
    required this.coalitions,
  });


  factory CampusCoalitionListResponse.fromMap(List<dynamic> items) {
    //logger.d(items);
    Map<String, dynamic> campus = items.first;
    return CampusCoalitionListResponse(
      coalitions: List<Coalition>.from((campus["coalitions"]).map<dynamic>((element) {
        return Coalition.fromMap(element);
      }))..sort((a, b) => b.score - a.score),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [coalitions];

}