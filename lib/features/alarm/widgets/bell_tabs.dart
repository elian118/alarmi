import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/raw_data/bells.dart';
import 'package:alarmi/features/alarm/models/bell.dart';
import 'package:alarmi/features/alarm/widgets/bell_tab.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class BellTabs extends StatefulWidget {
  final String? selectedBellId;
  final double volume;
  final Function(String? bellId) onChangeCurrentPlyingBellId;

  const BellTabs({
    super.key,
    required this.volume,
    required this.selectedBellId,
    required this.onChangeCurrentPlyingBellId,
  });

  @override
  State<BellTabs> createState() => _BellTabsState();
}

class _BellTabsState extends State<BellTabs> with TickerProviderStateMixin {
  late final TabController _bellTabController;
  late final AudioPlayer _audioPlayer;
  String? _currentPlayingBellId;

  @override
  void initState() {
    _currentPlayingBellId = widget.selectedBellId;
    _bellTabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: getInitialIndex(_currentPlayingBellId),
    );
    _audioPlayer = AudioPlayer();
    _audioPlayer.setLoopMode(LoopMode.one);

    if (widget.selectedBellId != null) {
      autoPlayBell(bells.where((b) => b.id == widget.selectedBellId).first);
    }

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

  int getInitialIndex(String? currentPlayingBellId) {
    String bellCategory =
        currentPlayingBellId != null
            ? bells
                .where((bell) => bell.id == currentPlayingBellId)
                .first
                .category
            : 'default';

    print(bellCategory);

    switch (bellCategory) {
      case 'default':
        return 0;
      case 'signal':
        return 1;
      case 'nature':
        return 2;
      case 'energy':
        return 3;
      default:
        return 0;
    }
  }

  void playBell(String filePath) {
    _audioPlayer.stop();
    _audioPlayer.setAsset(filePath);
    _audioPlayer.play();
    _audioPlayer.setVolume(widget.volume);
  }

  void autoPlayBell(Bell bellToToggle) {
    playBell(bellToToggle.path);
    _currentPlayingBellId = bellToToggle.id;
  }

  Future<void> _playPauseBell(Bell bellToToggle) async {
    setState(() {
      if (_currentPlayingBellId == bellToToggle.id) {
        _audioPlayer.stop();
        _currentPlayingBellId = null;
      } else {
        autoPlayBell(bellToToggle);
      }
    });

    widget.onChangeCurrentPlyingBellId(_currentPlayingBellId);
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
                              bellId: b.id,
                              title: b.name,
                              selectedBellId: widget.selectedBellId,
                              isPlaying: _currentPlayingBellId == b.id,
                              onPlayPause: () => _playPauseBell(b),
                              onChangeCurrentPlyingBellId:
                                  widget.onChangeCurrentPlyingBellId,
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
