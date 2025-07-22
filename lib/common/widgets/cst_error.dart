import 'package:flutter/material.dart';

class CstError extends StatelessWidget {
  final String? errorMessage;
  final Object error;

  const CstError({super.key, required this.error, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '${errorMessage ?? '오류가 발생했습니다.'} $error',
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
