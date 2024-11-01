import 'package:court_reserve_app/models/tennis_court.dart';
import 'package:court_reserve_app/widgets/tennis_court_card.dart';
import 'package:flutter/material.dart';

class TennisCourtCardList extends StatelessWidget {
  final List<TennisCourt> tennisCourtList;
  final Function(TennisCourt) onTennisCourt;
  final Function(TennisCourt)? onEdit;
  const TennisCourtCardList({
    required this.tennisCourtList,
    required this.onTennisCourt,
    this.onEdit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: tennisCourtList
          .map((tennisCourt) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TennisCourtCard(
                  tennisCourt: tennisCourt,
                  onTennisCourt: onTennisCourt,
                  onEdit: onEdit,
                ),
              ))
          .toList(),
    );
  }
}
