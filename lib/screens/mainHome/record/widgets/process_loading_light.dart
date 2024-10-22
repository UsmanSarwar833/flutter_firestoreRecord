import 'package:flutter/material.dart';

class ProcessLoadingLight extends StatelessWidget{
  const ProcessLoadingLight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(color: const Color.fromRGBO(0, 0, 0, 0.6),
        child: const Center(
          child: SizedBox(width: 50,height: 50,
              child: CircularProgressIndicator()),
        ));
  }
}