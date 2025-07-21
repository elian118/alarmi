List<Personality> personalities = [
  const Personality(key: 'Indifferent', label: '무심한', message: '그래, 뭐든 알아서 할게'),
  const Personality(key: 'Friendly', label: '다정한', message: '히히, 잘 부탁해!'),
  const Personality(key: 'Meticulous', label: '꼼꼼한', message: '음.. 실수는 없을거야'),
  const Personality(key: 'Goofy', label: '엉뚱한', message: '뭔진 모르지만 좋아~'),
];

class Personality {
  final String key;
  final String label;
  final String message;

  const Personality({
    required this.key,
    required this.label,
    required this.message,
  });
}
