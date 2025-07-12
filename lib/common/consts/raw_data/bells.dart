import 'package:alarmi/features/alarm/models/bell.dart';

List<Bell> bells = [
  // 'default'
  Bell(
    id: 'test',
    category: 'default',
    name: 'Test',
    path: 'assets/audios/default/res_test.mp3',
  ),
  Bell(
    id: 'basic_introduction_uk_drill',
    category: 'default',
    name: 'Basic introduction uk drill',
    path: 'assets/audios/default/res_basic_introduction_uk_drill.mp3',
  ),
  Bell(
    id: 'common_goal',
    category: 'default',
    name: 'Common goal',
    path: 'assets/audios/default/res_common_goal.mp3',
  ),
  Bell(
    id: 'space',
    category: 'default',
    name: 'Space',
    path: 'assets/audios/default/res_space.mp3',
  ),

  // 'signal'
  Bell(
    id: 'clip_01_turn_it_up',
    category: 'signal',
    name: 'clip 01 turn it up',
    path: 'assets/audios/signal/res_clip_01_turn_it_up.mp3',
  ),
  Bell(
    id: 'clip_04_intro',
    category: 'signal',
    name: 'clip 04 intro',
    path: 'assets/audios/signal/res_clip_04_intro.mp3',
  ),
  Bell(
    id: 'clip_06_headlines',
    category: 'signal',
    name: 'clip 06 headlines',
    path: 'assets/audios/signal/res_clip_06_headlines.mp3',
  ),
  Bell(
    id: 'clip_09_good_morning',
    category: 'signal',
    name: 'clip 09 good morning',
    path: 'assets/audios/signal/res_clip_09_good_morning.mp3',
  ),
  Bell(
    id: 'clip_10_drippling_drops_short',
    category: 'signal',
    name: 'clip 10 drippling drops short',
    path: 'assets/audios/signal/res_clip_10_drippling_drops_short.mp3',
  ),

  // 'nature'
  Bell(
    id: 'mountain_path',
    category: 'nature',
    name: 'Mountain path',
    path: 'assets/audios/nature/res_mountain_path.mp3',
  ),
  Bell(
    id: 'nature_investigation',
    category: 'nature',
    name: 'Nature investigation',
    path: 'assets/audios/nature/res_nature_investigation.mp3',
  ),
  Bell(
    id: 'sleep_of_nature_short_pixabay',
    category: 'nature',
    name: 'Sleep of nature short pixabay',
    path: 'assets/audios/nature/res_sleep_of_nature_short_pixabay.mp3',
  ),
  Bell(
    id: 'warm_campfire',
    category: 'nature',
    name: 'Warm campfire',
    path: 'assets/audios/nature/res_warm_campfire.mp3',
  ),

  // 'energy'
  Bell(
    id: 'dont_talk',
    category: 'energy',
    name: 'Don\'t talk',
    path: 'assets/audios/energy/res_dont_talk.mp3',
  ),
  Bell(
    id: 'guitar_electro_sport_trailer',
    category: 'energy',
    name: 'Guitar electro sport trailer',
    path: 'assets/audios/energy/res_guitar_electro_sport_trailer.mp3',
  ),
  Bell(
    id: 'movement',
    category: 'energy',
    name: 'Movement',
    path: 'assets/audios/energy/res_movement.mp3',
  ),
  Bell(
    id: 'my_punch',
    category: 'energy',
    name: 'My punch',
    path: 'assets/audios/energy/res_my_punch.mp3',
  ),
  Bell(
    id: 'street_customs',
    category: 'energy',
    name: 'Street customs',
    path: 'assets/audios/energy/res_street_customs.mp3',
  ),
];

List<String> bellCategories = ['default', 'signal', 'nature', 'energy'];

List<String> bellIcons = ['🐷', '🐷', '🐷', '🐷', '🐷', '🐷', '🐷'];
