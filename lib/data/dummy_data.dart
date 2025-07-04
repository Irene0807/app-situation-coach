import '../models/journey.dart';
import '../models/character.dart';

List<Journey> dummyJourneys = [
  Journey(id: '1', name: 'Seoul Shopping', character: 'Trump', isCompleted: false),
  Journey(id: '2', name: 'Job Interview', character: 'Trump', isCompleted: true),
  Journey(id: '3', name: 'Taipei Night Market', character: 'Trump', isCompleted: false),
  Journey(id: '4', name: 'Tokyo Vacation', character: 'Trump', isCompleted: true),
  Journey(id: '5', name: 'Hong Kong Business Trip', character: 'Trump', isCompleted: false),
  Journey(id: '6', name: 'Shanghai Conference', character: 'Trump', isCompleted: true),
  Journey(id: '7', name: 'Singapore Expo', character: 'Trump', isCompleted: false),
  Journey(id: '8', name: 'Bangkok Tour', character: 'Trump', isCompleted: true),
  Journey(id: '9', name: 'America Adventure', character: 'Trump', isCompleted: false),
];

const int dummyDialogCount = 6;
const int dummyLoginDays = 4;

const Map<String, double> dummyEnglishAbilities = {
  'Fluency': 68,
  'Pronunciation': 72,
  'Vocabulary': 61,
  'Grammar': 78,
  'Comprehensibility': 70,
  'Confidence': 83,
};

final List<Character> characters = [
  Character(
    name: 'Trump',
    gender: '男生',
    age: 70,
    imagePath: 'assets/images/trump.png',
    background: '現任美國總統，口才犀利，對特定國家有明顯喜惡。',
    personality: '自信、戲劇化、直來直往',
    tone: '誇張、強勢、美式幽默',
    slogan: '"Make America Great Again!"',
  ),
  Character(
    name: 'TOEFL Interviewer',
    gender: '女生',
    age: 16,
    imagePath: 'assets/images/home_person.png',
    background: '模擬托福口試考官，負責情境對話的考察。',
    personality: '理性、專業、略帶距離感',
    tone: '正式、有條理、輕微壓力感',
    slogan: '"Let’s see how you handle this!"',
  ),
  Character(
    name: 'American Kid',
    gender: '男生',
    age: 18,
    imagePath: 'assets/images/home_person.png',
    background: '來自加州的陽光少年，喜歡滑板與流行文化。',
    personality: '開朗、隨性、喜歡聊天',
    tone: '自然、美式口語、多slang',
    slogan: '"Dude, let’s hang out!"',
  ),
  Character(
    name: 'England Kid',
    gender: '女生',
    age: 17,
    imagePath: 'assets/images/home_person.png',
    background: '倫敦長大的少女，語氣優雅，熱愛文學。',
    personality: '溫柔、有禮貌、聰明',
    tone: '英式優雅、標準英音、有邏輯性',
    slogan: '"Hello, would you like some tea?"',
  ),
  Character(
    name: 'Harry Potter',
    gender: '男生',
    age: 19,
    imagePath: 'assets/images/home_person.png',
    background: '魔法世界的代表人物，善良又有正義感。',
    personality: '勇敢、謙遜、有正義感',
    tone: '英式發音、誠懇、略帶魔幻色彩',
    slogan: '"Welcome to my magic world!"',
  ),
];