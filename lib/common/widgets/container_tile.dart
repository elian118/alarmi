import 'package:flutter/material.dart';

class ContainerTile extends StatelessWidget {
  final Widget child;

  const ContainerTile({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      width: size.width * 0.45,
      height: size.width * 0.45,
      child: Center(child: child),
    );
  }
}
