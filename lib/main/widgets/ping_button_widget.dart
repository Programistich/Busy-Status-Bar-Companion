import 'package:busy_status_bar/main/bloc/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PingButtonWidget extends StatelessWidget {
  const PingButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainBloc>();
    return SizedBox(
      width: double.infinity,
      height: 30.0,
      child: ElevatedButton(
        onPressed: () => bloc..add(MainEventPing()),
        child: const Text('Ping'),
      ),
    );
  }
}
