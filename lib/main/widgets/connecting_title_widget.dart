import 'package:flutter/material.dart';

class ConnectingTitleWidget extends StatelessWidget {
  const ConnectingTitleWidget({Key? key}) : super(key: key);

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
            children: const [
              Text('Connecting'),
              SizedBox(width: 10.0),
              SizedBox(
                height: 20.0,
                width: 20.0,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
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
