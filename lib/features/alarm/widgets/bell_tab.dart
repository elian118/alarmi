import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BellTab extends StatefulWidget {
  final String title;

  const BellTab({super.key, required this.title});

  @override
  State<BellTab> createState() => _BellTabState();
}

class _BellTabState extends State<BellTab> with TickerProviderStateMixin {
  late final AnimationController _playPauseController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 500),
  );

  void _onPlayPauseTap() {
    _playPauseController.isCompleted
        ? _playPauseController.reverse()
        : _playPauseController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _onPlayPauseTap,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
      ),
      child: AnimatedBuilder(
        animation: _playPauseController,
        builder: (context, child) {
          final double currentAlpha = 0.07 * _playPauseController.value;

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
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: AnimatedIcon(
                    icon: AnimatedIcons.pause_play,
                    progress: _playPauseController,
                    size: 20,
                  ),
                ),
              ],
            ),
          );
        },
        // child: ,
      ),
    );
  }
}
