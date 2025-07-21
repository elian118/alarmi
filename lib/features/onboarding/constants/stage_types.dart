List<Stage> stageTypes = [
  Stage(index: 0, type: 'narration'),
  Stage(index: 1, type: 'narration'),
  Stage(index: 2, type: 'message'),
  Stage(index: 3, type: 'input'),
  Stage(index: 4, type: 'message'),
  Stage(index: 5, type: 'message'),
  Stage(index: 6, type: 'message'),
  Stage(index: 7, type: 'narration'),
  Stage(index: 8, type: 'narration'),
  Stage(index: 9, type: 'message'),
  Stage(index: 10, type: 'message'),
  Stage(index: 11, type: 'message'),
  Stage(index: 12, type: 'message'),
];

class Stage {
  final int index;
  final String type;

  Stage({required this.index, required this.type});
}
