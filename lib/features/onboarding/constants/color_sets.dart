import 'dart:ui';

List<ColorSet> colorSets = [
  const ColorSet(color: Color(0xffF9B9FF), colorName: '핑크색'),
  const ColorSet(color: Color(0xffFFFFFF), colorName: '흰색'),
  const ColorSet(color: Color(0xff9E9E9E), colorName: '검은색'),
  const ColorSet(color: Color(0xffFFF7B3), colorName: '노란색'),
  const ColorSet(color: Color(0xff563FFF), colorName: '보라색'),
];

class ColorSet {
  final Color color;
  final String colorName;

  const ColorSet({required this.color, required this.colorName});
}
