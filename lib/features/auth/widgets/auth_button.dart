import 'package:alarmi/common/consts/sizes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AuthButton extends StatelessWidget {
  final FaIcon icon;
  final String text;
  final GestureTapCallback? onTapHandler;

  const AuthButton({
    Key? key,
    required this.text,
    required this.icon,
    this.onTapHandler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapHandler,
      // 부모 위젯 크기에 따른 상대적 사이즈를 지정할 수 있는 Box 위젯
      // 부모 대비 높이(heightFactor), 너비(widthFactor)
      child: FractionallySizedBox(
        widthFactor: 1, // 부모 위젯 크기를 1로 설정
        child: Container(
          padding: const EdgeInsets.all(Sizes.size14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200, width: Sizes.size1),
          ),
          // Stack -> 밑에서부터 위로 자식들을 겹쳐 쌓는 위젯
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: icon,
              ), // Stack 내 특정 요소 정렬만 바꿔 줌
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: Sizes.size16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
