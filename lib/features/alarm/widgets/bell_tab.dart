import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:marquee/marquee.dart';

class BellTab extends StatefulWidget {
  final String title;
  final String? selectedBellId;
  final String bellId;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final Function(String? bellId) onChangeCurrentPlyingBellId;

  const BellTab({
    super.key,
    required this.title,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onChangeCurrentPlyingBellId,
    this.selectedBellId,
    required this.bellId,
  });

  @override
  State<BellTab> createState() => _BellTabState();
}

class _BellTabState extends State<BellTab> with TickerProviderStateMixin {
  late final AnimationController _playPauseController = AnimationController(
    vsync: this,
    duration: 500.ms,
  );

  @override
  void initState() {
    // 선택된 벨소리가 있는 경우 플레이 상태로 변경
    if (widget.selectedBellId != null &&
        widget.selectedBellId == widget.bellId) {
      _playPauseController.forward();
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BellTab oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isPlaying != oldWidget.isPlaying) {
      widget.isPlaying
          ? _playPauseController.forward()
          : _playPauseController.reverse();
    }
  }

  @override
  void dispose() {
    _playPauseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPlayPause,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
      ),
      child: AnimatedBuilder(
        animation: _playPauseController,
        builder: (context, child) {
          final double currentAlpha = 0.07 * _playPauseController.value;
          final Color iconContainerColor = Colors.white.withValues(
            alpha:
                _playPauseController.value < 0.1
                    ? 0.1
                    : _playPauseController.value,
          );

          return AnimatedContainer(
            duration: 0.5.ms,
            curve: Curves.easeInOut,
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: currentAlpha),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 25,
              children: [
                Container(
                  height: 30,
                  width: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: currentAlpha),
                  ),
                  child: Text('🐷'),
                ),
                Expanded(
                  child:
                      widget.isPlaying
                          ? Marquee(
                            text: widget.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            blankSpace: getWinWidth(context) * 0.6,
                          )
                          : Text(
                            widget.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                ),
                // 재생아이콘 유지? / 제거?
                Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: iconContainerColor,
                    shape: BoxShape.circle,
                  ),
                  child: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: _playPauseController,
                    size: 20,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
