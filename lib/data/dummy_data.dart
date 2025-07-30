import 'package:app_situational_coach/models/day.dart';
import 'package:app_situational_coach/models/question.dart';
import 'package:app_situational_coach/models/scene.dart';

import '../models/journey.dart';
import '../models/character.dart';
import '../models/status.dart';

List<Journey> dummyJourneys = [
  Journey(
      id: '1',
      name: 'Seoul Shopping',
      day: 3,
      character: 'Trump',
      description: '在首爾的購物之旅，體驗當地文化和美食。',
      learningGoal: '學習如何在購物時使用英語交流。',
      schedule: [
        Day(title: 'Shopping & Asking', scenes: [
          Scene(
              title: 'Grocery Shopping',
              location: 'Market',
              description:
                  'Pick up a cart, find items on your list, check labels and prices, ask staff if needed, then pay at checkout. Don’t forget your bags and receipt.',
              learningTheme: 'Basic Transactions',
              // 第一個scene會在創建journey的同時建立好
              introContent: IntroContent(
                  description:
                      'Welcome to the market—a lively place for buying fruits, snacks, and daily items! Today, we\'ll practice basic transaction vocabulary to help you ask questions, read labels, and communicate while shopping in English.',
                  vocabulary: [
                    'cart',
                    'aisle',
                    'shelf',
                    'label',
                    'price',
                    'discount',
                    'receipt',
                    'cashier',
                    'checkout',
                    'bag',
                    // 'item',
                    // 'quantity',
                    // 'barcode',
                    // 'total',
                    // 'change',
                    // 'credit card',
                    // 'debit card',
                    // 'cash',
                    // 'refund',
                    // 'exchange',
                    // 'customer',
                    // 'employee',
                    // 'ask for help',
                    // 'payment',
                    // 'scan',
                    // 'queue',
                    // 'on sale',
                    // 'out of stock',
                    // 'buy one get one free',
                    'self-checkout'
                  ]),
              conversationContent: ConversationContent(script: '''
You are Trump.You act as a friendly shop assistan at a grocery store. 
Your job is to guide the learner through a realistic shopping conversation. 
Make sure to use simple vocabulary and encourage them to improve their thinking.

Start with a warm greeting, then ask what they are looking for.
Make sure to talk like Trump and focus on shopping at a grocery store in korea.
At the end, help them check out and say goodbye.
                ''',
                messages: [],
                ),
              summaryContent: SummaryContent(
                summary:
                    'Your grocery shopping journey has come to an end. Now, let’s review what you’ve learned with a vocabulary quiz!',
                questions: [
                  Question(
                    questionText:
                        'What do you use to carry items while shopping?',
                    options: ['Basket', 'Bag', 'Trolley', 'Box'],
                    answerId: 2,
                  ),
                  Question(
                    questionText:
                        'Where do you find different product categories in a supermarket?',
                    options: ['Counter', 'Shelf', 'Aisle', 'Register'],
                    answerId: 2,
                  ),
                  Question(
                    questionText:
                        'What is the place where you pay for your items?',
                    options: ['Cashier', 'Checkout', 'Stockroom', 'Warehouse'],
                    answerId: 1,
                  ),
                  Question(
                    questionText:
                        'What is the small note you get after paying?',
                    options: ['Bill', 'Receipt', 'Tag', 'Label'],
                    answerId: 1,
                  ),
                  Question(
                    questionText:
                        'Which of the following means “a price reduction”?',
                    options: ['Sale', 'Tax', 'Cost', 'Item'],
                    answerId: 0,
                  ),
                  Question(
                    questionText:
                        'What do you usually check to know how much a product costs?',
                    options: ['Logo', 'Barcode', 'Label', 'Manual'],
                    answerId: 2,
                  ),
                ],
              )),
          Scene(
            title: 'Asking for Directions',
            location: 'On the road',
            description:
                'Ask someone or use a map app to find the nearest subway station. Follow signs, walk in the right direction, and watch for subway symbols. When you arrive, check the entrance, buy a ticket if needed, and get ready to board the train.',
            learningTheme: 'Navigation',
          ),
        ]),
        Day(title: 'Ording & Cloth shopping', scenes: [
          Scene(
            title: 'Ordering at a Café',
            location: 'Breakfast shop',
            description:
                'Go to the counter, look at the menu, and choose your coffee and breakfast. Tell the cashier your order clearly and politely. Pay with cash or card. Wait for your food and drink, then take them when your name or number is called. Enjoy your meal!',
            learningTheme: 'Food & Drinks',
          ),
          Scene(
            title: 'Shopping for Clothes',
            location: 'Clothing store',
            description:
                'Go to a clothing store and browse the racks for styles you like. When you find something, ask a staff member, “Do you have this in a different size or color?” Try it on in the fitting room if available. Choose what fits best, then pay at the counter.',
            learningTheme: 'Fashion & Sizes',
          ),
        ]),
        Day(title: 'Hotel & Texi', scenes: [
          Scene(
            title: 'Hotel Check-In',
            location: 'in the Hotel',
            description:
                'Go to the hotel front desk and say you’d like to check in. Provide your name and ID or booking confirmation. Ask politely about amenities by saying, “Do you have Wi-Fi?” or “Is breakfast included?” Get your room key, directions to your room, and enjoy your stay.',
            learningTheme: 'Travel Accommodation',
          ),
          Scene(
            title: 'Calling a Taxi',
            location: 'Taxi',
            description:
                'When calling a taxi, clearly say your destination address or a well-known place nearby. For example, “Please take me to Central Park.” When the ride ends, tell the driver how you want to pay, such as “I will pay by cash” or “Do you accept credit cards?”',
            learningTheme: 'Transportation',
          ),
        ])
      ],
      bloomLevel: 1,
      status: JourneyStatus(day: 0, scene: 0, mode: 0)),
  Journey(
      id: '2',
      name: 'Job Interview',
      day: 1,
      character: 'Trump',
      description: '模擬一次英語工作面試，提升口語表達能力。',
      learningGoal: '學習如何在面試中自信地表達自己。',
      schedule: [],
      bloomLevel: 1,
      status: JourneyStatus(day: -1, scene: -1, mode: -1)),
  Journey(
      id: '3',
      name: 'Taipei Night Market',
      day: 1,
      character: 'Trump',
      description: '在台北夜市體驗當地小吃和文化。',
      learningGoal: '學習如何在日常生活中使用英語進行交流',
      schedule: [],
      bloomLevel: 1,
      status: JourneyStatus(day: 0, scene: 0, mode: 0)),
  Journey(
      id: '4',
      name: 'Tokyo Vacation',
      day: 1,
      character: 'Trump',
      description: '在東京的假期，探索城市和文化。',
      learningGoal: '學習如何在旅遊中使用英語進行溝通。',
      schedule: [],
      bloomLevel: 1,
      status: JourneyStatus(day: -1, scene: -1, mode: -1)),
  Journey(
      id: '5',
      name: 'Hong Kong Business Trip',
      day: 1,
      character: 'Trump',
      description: '在香港的商務旅行，與當地商人交流。',
      learningGoal: '學習如何在商務場合使用英語。',
      schedule: [],
      bloomLevel: 1,
      status: JourneyStatus(day: 0, scene: 0, mode: 0)),
  Journey(
      id: '6',
      name: 'Shanghai Conference',
      day: 1,
      character: 'Trump',
      description: '參加上海的國際會議，與各國代表交流。',
      learningGoal: '學習如何在正式場合使用英語。',
      schedule: [],
      bloomLevel: 1,
      status: JourneyStatus(day: -1, scene: -1, mode: -1)),
  Journey(
      id: '7',
      name: 'Singapore Expo',
      day: 1,
      character: 'Trump',
      description: '在新加坡的博覽會上展示產品，與客戶交流。',
      learningGoal: '學習如何在展覽中使用英語進行推銷和交流。',
      schedule: [],
      bloomLevel: 1,
      status: JourneyStatus(day: 0, scene: 0, mode: 0)),
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
