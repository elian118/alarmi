import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';

class CstImageSwitch extends StatefulWidget {
  final bool value;
  final void Function(bool) onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final String thumbIconPath;
  final Color? thumbIconColor; // 아이콘 색상 추가 (옵션)

  const CstImageSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.thumbIconPath,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.thumbIconColor,
  });

  @override
  State<CstImageSwitch> createState() => _CstImageSwitchState();
}

class _CstImageSwitchState extends State<CstImageSwitch> {
  final UniqueKey _animatedContainerKey = UniqueKey();
  final UniqueKey _animatedAlignKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    bool isSvg(String path) => path.toLowerCase().endsWith('.svg');

    Widget buildThumbIcon() {
      if (isSvg(widget.thumbIconPath)) {
        return SvgPicture.asset(
          widget.thumbIconPath,
          width: 24,
          height: 16,
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(
            widget.thumbIconColor ?? Colors.white,
            BlendMode.srcIn,
          ),
        );
      } else {
        // PNG, JPG 등 비 SVG 이미지
        return Image.asset(
          widget.thumbIconPath,
          width: 24,
          height: 16,
          color: widget.thumbIconColor,
        );
      }
    }

    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: KeyedSubtree(
        key: widget.key,
        child: AnimatedContainer(
          key: _animatedContainerKey,
          duration: Duration(milliseconds: 400),
          height: 28.0,
          width: 52.0,
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color:
                widget.value
                    ? widget.activeColor ??
                        Theme.of(context).colorScheme.primary
                    : widget.inactiveColor ??
                        Theme.of(context).colorScheme.inverseSurface,
          ),
          curve: Curves.easeInOut,
          child: AnimatedAlign(
            key: _animatedAlignKey,
            duration: 400.ms,
            curve: Curves.easeInOut,
            alignment:
                widget.value ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                height: 26.0,
                width: 26.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.thumbColor ?? Colors.transparent,
                ),
                child: Center(child: buildThumbIcon()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
