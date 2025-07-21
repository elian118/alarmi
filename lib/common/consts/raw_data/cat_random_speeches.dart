List<RandomSpeech> randomSpeech = [
  RandomSpeech(
    personality: 'Indifferent',
    message: ['시간 체크 하고 있는거지?', '시간 체크 하고 있는거지?'],
  ), // 무심한
  RandomSpeech(personality: 'Friendly', message: ['난 네 편이야!']), // 다정한
  RandomSpeech(
    personality: 'Meticulous',
    message: ['시간은 금이야!', '졸려도 해야할 일을 잊지 말자!'],
  ), // 꼼꼼한
  RandomSpeech(
    personality: 'Goofy',
    message: ['시간? 그거 그냥 숫자야~', '하늘에 고양이 구름 보여?', '헤헤~ 나 졸려', '오늘은 뒹굴뒹굴~'],
  ), // 엉뚱한
];

class RandomSpeech {
  final String personality;
  final List<String> message;

  RandomSpeech({required this.personality, required this.message});
}
