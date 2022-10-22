import 'package:busy_status_bar/tos/widgets/connect_button.dart';
import 'package:flutter/material.dart';

class TosPage extends StatelessWidget {
  const TosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connect Screen')),
      body: const ConnectButtonWidget(),
    );
  }
}
