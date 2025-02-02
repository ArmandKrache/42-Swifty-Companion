import 'package:equatable/equatable.dart';

enum CoalitionType {
  order,
  assembly,
  alliance,
  federation
}

class Coalition extends Equatable {
  final int id;
  final String name;
  final String slug;
  final int score;
  final CoalitionType coalition;

  const Coalition({
    this.id = -1,
    this.name = "",
    this.slug = "",
    this.score = 0,
    required this.coalition,
  });


  factory Coalition.fromMap(Map<String, dynamic> map) {
    CoalitionType coalition = CoalitionType.order;
    switch (map["name"]) {
      case ("The Federation"):
        coalition = CoalitionType.federation;
        break;
      case ("The Order"):
        coalition = CoalitionType.order;
        break;
      case ("The Assembly"):
        coalition = CoalitionType.alliance;
        break;
      case ("The Alliance"):
        coalition = CoalitionType.assembly;
        break;
    }

    return Coalition(
      id: map['id'] ?? -1,
      name: map['name'] ?? "",
      slug: map['slug'] ?? "",
      score: map['score'] ?? 0,
      coalition: coalition,
    );
  }

  factory Coalition.empty() {
    return const Coalition(coalition: CoalitionType.order);
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [name, score];

}