import 'package:court_reserve_app/models/user.dart';
import 'package:flutter/material.dart';

class UserDetailsWidget extends StatelessWidget {
  final User user;
  const UserDetailsWidget({
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade200,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _text(
            "Account Details",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _text("Username:"),
              Flexible(child: _text(user.username)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _text("Name:"),
              Flexible(child: _text("${user.firstName} ${user.lastName}")),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _text("Email:"),
              Flexible(child: _text(user.email)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _text("Phone number:"),
              Flexible(child: _text(user.phoneNumber)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _text(String data, {TextStyle style = const TextStyle()}) {
    return Text(data, style: style);
  }
}
