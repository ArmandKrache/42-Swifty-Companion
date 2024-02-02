
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swifty_companion/src/config/app_assets.dart';
import 'package:swifty_companion/src/config/app_colors.dart';
import 'package:swifty_companion/src/config/app_strings.dart';
import 'package:swifty_companion/src/config/config.dart';
import 'package:swifty_companion/src/domain/models/event/event.dart';

String _formatDateAndStartingHour(DateTime start) {
  return "${start.day}/${start.month}/${start.year} - ${start.hour}:${start.minute}${start.minute == 0 ? "0" : ""}";
}

String _formatDeltaBetweenStartAndEnd(DateTime start, DateTime end) {
  Duration delta = end.difference(start);
  if (delta.inHours < 2) {
    return "${delta.inMinutes} ${tr("utils.minutes")}";
  }
  return "${delta.inHours} ${delta.inHours <= 1 ? tr("utils.hour") : tr("utils.hours")}";
}

class EventCardWidget extends StatelessWidget {
  final Event event;

  const EventCardWidget({
    super.key,
    required this.event
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppColors.event;
    switch (event.kind) {
      case ("partnership"):
        borderColor = AppColors.eventPartnership;
        break;
      case ("association"):
        borderColor = AppColors.eventAssociation;
        break;
      case ("extern"):
        borderColor = AppColors.eventExtern;
        break;
    }


    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.grey.withOpacity(0.05)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(text: TextSpan(
            children: [
              TextSpan(text: AppStrings.getEventKind(event.kind), style: TextStyle(fontWeight: FontWeight.bold, color: borderColor),),
              TextSpan(text:  " - ${event.name}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, height: 1.5),),
            ],
          ),
          ),
          const SizedBox(height: 8,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, size: 16,),
              const SizedBox(width: 4,),
              Expanded(child: Text(event.location))
            ],
          ),
          const SizedBox(height: 8,),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 16,),
              const SizedBox(width: 4,),
              Text(_formatDateAndStartingHour(event.start)),
              const Expanded(child: SizedBox()),
              const Icon(Icons.hourglass_empty_outlined, size: 16,),
              const SizedBox(width: 4,),
              Text(_formatDeltaBetweenStartAndEnd(event.start, event.end)),
            ],
          ),
        ],
      ),
    );
  }
}