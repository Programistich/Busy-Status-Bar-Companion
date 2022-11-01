import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/main_bloc.dart';

class SetBusyWidget extends StatelessWidget {
  const SetBusyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainBloc>();
    return SizedBox(
      width: double.infinity,
      height: 30.0,
      child: ElevatedButton(
        onPressed: () => bloc..add(MainEventBusy()),
        child: const Text('Set Busy'),
      ),
    );
  }
}
