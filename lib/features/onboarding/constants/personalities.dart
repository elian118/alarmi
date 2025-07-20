List<Personality> personalities = [
  const Personality(label: '무심한', message: '그래, 뭐든 알아서 할게'),
  const Personality(label: '다정한', message: '히히, 잘 부탁해!'),
  const Personality(label: '꼼꼼한', message: '음.. 실수는 없을거야'),
  const Personality(label: '엉뚱한', message: '뭔진 모르지만 좋아~'),
];

class Personality {
  final label;
  final message;

  const Personality({required this.label, required this.message});
}
