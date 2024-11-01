import 'package:flutter/material.dart';

class AppPopup extends StatelessWidget {
  final String title;
  final String content;
  final Widget? child;

  const AppPopup({
    required this.title,
    required this.content,
    this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 40),
              Expanded(
                  child: Text(
                title,
                textAlign: TextAlign.center,
              )),
              SizedBox(
                width: 40,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              )
            ],
          ),
          Divider(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(content),
          ),
          const SizedBox(height: 30),
          if (child != null) ...[
            child!,
            const SizedBox(height: 15),
          ],
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
