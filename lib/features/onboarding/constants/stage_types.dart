List<Stage> stageTypes = [
  Stage(index: 0, type: 'narration', isClickable: true),
  Stage(index: 1, type: 'narration', isClickable: true),
  Stage(index: 2, type: 'message', isClickable: false),
  Stage(index: 3, type: 'input', isClickable: false),
  Stage(index: 4, type: 'message', isClickable: true),
  Stage(index: 5, type: 'message', isClickable: true),
  Stage(index: 6, type: 'message', isClickable: true),
  Stage(index: 7, type: 'narration', isClickable: false),
  Stage(index: 8, type: 'narration', isClickable: false),
  Stage(index: 9, type: 'message', isClickable: true),
  Stage(index: 10, type: 'message', isClickable: false),
  Stage(index: 11, type: 'message', isClickable: false),
  Stage(index: 12, type: 'message', isClickable: false),
];

class Stage {
  final int index;
  final String type;
  final bool isClickable;

  Stage({required this.index, required this.type, required this.isClickable});
}
