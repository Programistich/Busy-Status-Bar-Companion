import 'package:flutter/material.dart';

class ConnectedTitleWidget extends StatelessWidget {
  final String name;
  const ConnectedTitleWidget({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 16.0,
        ),
        SizedBox(
          height: 20.0,
          width: double.infinity,
          child: Row(
            children: [
              Text('Connected to $name'),
            ],
          ),
        ),
        const SizedBox(
          height: 16.0,
        ),
      ],
    );
  }
}
