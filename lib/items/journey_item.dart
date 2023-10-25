import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/models/Journey.dart';
import 'package:flutter/material.dart';

class JourneyItem extends StatelessWidget {
  final Journey journey;
  const JourneyItem({super.key, required this.journey});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          border: Border.all(
              width: 1, color: const Color.fromARGB(255, 232, 232, 232)),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                child:
                    const Icon(Icons.time_to_leave, color: AppColors.mainColor),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${journey.origin} - ${journey.destination}',
                    style: textStyleTitle(17),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Start at ${journey.startTime}',
                    style: textStyleTitle(13),
                  )
                ],
              ),
            ],
          ),
          GestureDetector(
              child: const Icon(
            Icons.cancel,
            color: AppColors.mainColor,
          ))
        ],
      ),
    );
  }
}
