import 'package:equatable/equatable.dart';
import 'package:swifty_companion/src/domain/models/event/event.dart';

class EventListResponse extends Equatable {
  final List<Event> events;


  const EventListResponse({
    required this.events,
  });


  factory EventListResponse.fromMap(List<dynamic> items) {
    return EventListResponse(
      events: List<Event>.from((items).map<dynamic>((element) {
        return Event.fromMap(element);
      })),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [events];

}