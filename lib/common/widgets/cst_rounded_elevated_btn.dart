import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';

class CstRoundedElevatedBtn extends StatelessWidget {
  final String label;
  final double height;
  final double? width;
  final void Function()? onPressed;

  const CstRoundedElevatedBtn({
    super.key,
    required this.label,
    required this.height,
    this.width,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? getWinWidth(context),
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.white.withValues(alpha: 0.5);
            }
            return Colors.white;
          }),
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.disabled)) {
              return Color(0xFF8EB4FF);
            }
            return Theme.of(context).primaryColor;
          }),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            // WidgetStateProperty.all 사용
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: Sizes.size14),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: Sizes.size18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
