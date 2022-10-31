import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../navigation/route.dart';

class WifiButtonWidget extends StatelessWidget {
  const WifiButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 30.0,
      child: ElevatedButton(
        onPressed: () => context.push(NavigationRoute.wifiScreen),
        child: const Text('Wifi'),
      ),
    );
  }
}
