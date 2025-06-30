import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/raw_data/bells.dart';
import 'package:alarmi/features/alarm/models/bell.dart';
import 'package:alarmi/features/alarm/widgets/bell_tab.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class BellTabs extends StatefulWidget {
  final double volume;
  const BellTabs({super.key, required this.volume});

  @override
  State<BellTabs> createState() => _BellTabsState();
}

class _BellTabsState extends State<BellTabs> with TickerProviderStateMixin {
  late final TabController _bellTabController;
  late final AudioPlayer _audioPlayer;
  String? _currentPlayingBellId;

  @override
  void initState() {
    _bellTabController = TabController(length: 4, vsync: this);
    _audioPlayer = AudioPlayer();
    _audioPlayer.setLoopMode(LoopMode.one);

    super.initState();
  }

  @override
  void dispose() {
    _bellTabController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant BellTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.volume != widget.volume) {
      _audioPlayer.setVolume(widget.volume);
    }
  }

  Future<void> _playPauseBell(Bell bellToToggle) async {
    setState(() {
      if (_currentPlayingBellId == bellToToggle.id) {
        _audioPlayer.stop();
        _currentPlayingBellId = null;
      } else {
        _audioPlayer.stop();
        _audioPlayer.setAsset(bellToToggle.path);
        _audioPlayer.play();
        _audioPlayer.setVolume(widget.volume);

        _currentPlayingBellId = bellToToggle.id;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TabBar(
            controller: _bellTabController,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            unselectedLabelColor: Colors.white.withValues(alpha: 0.5),
            dividerHeight: 0,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            indicator: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(10),
            ),
            // indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(text: '기본'),
              Tab(text: '신호음'),
              Tab(text: '자연'),
              Tab(text: '에너지'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _bellTabController,
            children: [
              ...bellCategories.map(
                (category) => SingleChildScrollView(
                  child: Column(
                    spacing: 14,
                    children: [
                      Gaps.v12,
                      ...bells
                          .where((bell) => bell.category == category)
                          .map(
                            (b) => BellTab(
                              title: b.name,
                              isPlaying: _currentPlayingBellId == b.id,
                              onPlayPause: () => _playPauseBell(b),
                            ),
                          ),
                      Gaps.v12,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
