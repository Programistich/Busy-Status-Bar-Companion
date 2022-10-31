import 'package:flutter/material.dart';

import '../model/wifi_list.dart';

class WifiItemWidget extends StatefulWidget {
  final Wifi wifi;
  final Function(Wifi, String) onConnect;
  String password = "";

  WifiItemWidget({
    required this.wifi,
    required this.onConnect,
    Key? key,
  }) : super(key: key);
  @override
  _WifiItemWidget createState() => _WifiItemWidget();
}

class _WifiItemWidget extends State<WifiItemWidget> {
  final TextEditingController _textFieldController = TextEditingController();

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Connect to ${widget.wifi.name}'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  widget.password = value;
                });
              },
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: "Password"),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Cancel'),
                onPressed: () {
                  setState(() {
                    widget.password = "";
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                child: const Text('Connect'),
                onPressed: () {
                  setState(() {
                    widget.onConnect(widget.wifi, widget.password);
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          const Icon(Icons.wifi),
          Text(widget.wifi.name),
          const Spacer(),
          SizedBox(
            height: 30.0,
            child: ElevatedButton(
              onPressed: () => _displayTextInputDialog(context),
              child: const Text('Connect'),
            ),
          ),
        ],
      ),
    );
  }
}
