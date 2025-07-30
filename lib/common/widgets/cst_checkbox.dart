import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CstCheckbox extends StatefulWidget {
  final bool value; // 현재 체크박스의 상태 (체크됨/안됨)
  final ValueChanged<bool?> onChanged; // 상태 변경 시 호출될 콜백 함수
  final Color uncheckedColor; // 체크되지 않았을 때의 배경색
  final Color checkedColor; // 체크되었을 때의 배경색
  final Color checkIconColor; // 체크 아이콘의 색상
  final double size; // 체크박스의 전체 크기
  final double borderRadius; // 모서리 둥글기 반경 (size에 비례하여 자동 계산될 수 있음)

  const CstCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.uncheckedColor = const Color(0xFF5D81AE), // 예시 이미지의 색상
    this.checkedColor = Colors.blueAccent, // 체크되었을 때 기본색
    this.checkIconColor = Colors.white, // 체크 아이콘 기본색
    this.size = 32.0, // 기본 크기
    this.borderRadius = 8.0, // 기본 모서리 둥글기 (크기에 맞춰 조절)
  });

  @override
  _CstCheckboxState createState() => _CstCheckboxState();
}

class _CstCheckboxState extends State<CstCheckbox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 탭 이벤트를 감지하는 위젯
      onTap: () {
        // 현재 value의 반대 값을 onChanged 콜백으로 전달
        widget.onChanged(!widget.value);
      },
      child: AnimatedContainer(
        // 상태 변화에 애니메이션을 적용할 컨테이너
        duration: 200.ms, // 애니메이션 지속 시간
        curve: Curves.easeInOut, // 애니메이션 커브
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          // 체크 상태에 따라 배경색 변경
          color: widget.value ? widget.checkedColor : widget.uncheckedColor,
          // 모서리 둥글게 처리
          borderRadius: BorderRadius.circular(widget.borderRadius),
          // 테두리 선이 필요하면 여기에 border 속성 추가 (현재는 없음)
        ),
        child:
            widget
                    .value // 체크되었을 때만 체크 아이콘 표시
                ? Icon(
                  Icons.check,
                  size: widget.size * 0.7, // 아이콘 크기는 체크박스 크기에 비례하여 조절
                  color: widget.checkIconColor, // 체크 아이콘 색상
                )
                : null, // 체크되지 않았을 때는 아무것도 표시하지 않음
      ),
    );
  }
}
