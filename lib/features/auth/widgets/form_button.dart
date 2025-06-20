import 'package:alarmi/common/consts/sizes.dart';
import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  const FormButton({
    super.key,
    required this.disabled,
    this.text = '', // optional field with default value
  });

  final bool disabled; // 런타임 상수(final)는 빌드타임 상수(const) 보다 늦게 선언돼도 상관 없다.
  final String text;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      // Container -> AnimatedContainer : 스타일 적용시간만 지정하면 애니메이션 효과 자동 적용되는 컨테이너
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(vertical: Sizes.size16),
        duration: const Duration(milliseconds: 500), // 컨테이너 스타일 전환시간
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.size5),
          // color: disabled // _username.isEmpty
          //     ? isDarkMode(context)
          //         ? Colors.grey.shade800
          //         : Theme.of(context).disabledColor
          //     : Theme.of(context).primaryColor,
          color: Theme.of(context).primaryColor,
        ),
        // 텍스트 전환 효과를 AnimatedContainer 주기에 맞춤
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 500), // 텍스트 스타일 전환시간
          style: TextStyle(
            color:
                disabled // _username.isEmpty
                    ? Colors.grey
                    : Colors.white,
            fontWeight: FontWeight.w600,
          ),
          child: Text(
            text.isNotEmpty ? text : 'Next',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
