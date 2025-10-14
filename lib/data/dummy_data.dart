import 'package:app_situational_coach/models/day.dart';
import 'package:app_situational_coach/models/question.dart';
import 'package:app_situational_coach/models/scene.dart';
import 'package:app_situational_coach/data/dummy_data_scene_test.dart';
import 'package:app_situational_coach/data/dummy_data_journey_test.dart';

import '../models/journey.dart';
import '../models/character.dart';
import '../models/status.dart';

List<Journey> dummyJourneys = [journeyLow, journeyHigh];

// === 低怪組：Teacher / Cafe + Sushi =========================================
final Journey journeyLow = Journey(
  id: 'low_food_teacher',
  name: 'Café Sushi Lesson',
  day: 2,
  character: 'Teacher',
  description: '在咖啡廳跟著老師學壽司，專注在食材、步驟、味覺表達的正規英語。',
  learningGoal: '學習餐飲中高階詞彙並能清楚描述食材特性與烹飪步驟。',
  schedule: [
    // Day 1
    Day(title: 'Café Basics & Preferences', scenes: [
      Scene(
        id: '01-01',
        title: 'Menu & Preferences',
        location: 'Café',
        description: '閱讀菜單、表達偏好、處理替代與分量。',
        learningTheme: 'Menu Literacy',
        introContent: IntroContent(
          description: '學會談偏好與菜單閱讀的關鍵詞。',
          vocabulary: [
            'beverage',     // 飲品（比 drink 更正式）
            'preference',   // 偏好
            'portion',      // 份量
            'substitute',   // 替代品/替換
            'dietary',      // 飲食的（需求/限制）
          ],
          questions: lowScenePreTests['01-01']!
        ),
        conversationContent: ConversationContent(
          script: '''
You are a polite café teacher. 
Teaching Guide – Menu & Preferences

Tone & Style:
Teacher speaks calmly, clearly, and politely. Formal but gentle, gives short feedback like “Good, try again” or “Say it after me.”

Theme:
Menu literacy – ordering drinks and expressing preferences.
Key words: beverage, preference, portion, substitute, dietary.

Strategy:
Focus on recognition and repetition.

Teach key words with examples.

Model full sentences: “I prefer tea to coffee.”

Encourage polite phrases: “Can I have a smaller portion?”

Tips:
Use short sentences, wait for responses, correct gently, model naturally. Keep tone calm and professional.
          ''',
          messages: [],
        ),
        summaryContent: SummaryContent(
          summary: 'Your journey has come to an end. Now, let’s review what you’ve learned with a vocabulary quiz!',
          questions: lowScenePostTests['01-01']!,
        ),
      ),
      Scene(
        id: '01-02',
        title: 'Small Talk & Feedback',
        location: 'Café',
        description: '用禮貌英語進行寒暄與回饋。',
        learningTheme: 'Service Interaction',
        introContent: IntroContent(
          description: '強化禮貌對話與用餐體驗描寫。',
          vocabulary: [
            'courteous',    // 客氣、有禮
            'ambiance',     // 氛圍
            'recommendation', // 推薦
            'compliment',   // 讚美
            'satisfaction', // 滿意度
          ],
          questions: lowScenePreTests['01-02']!,
        ),
        conversationContent: ConversationContent(
          script: '',
          messages: [],
        ),
        summaryContent: SummaryContent(
          summary: '小測：服務互動用語！',
          questions: lowScenePostTests['01-02']!,
        ),
      ),
    ]),
    // Day 2
    Day(title: 'Sushi Prep & Plating', scenes: [
      Scene(
        id: '02-01',
        title: 'Sushi Prep: Fish & Rice',
        location: 'Café Kitchen',
        description: '處理食材、口感、鮮度與醃漬。',
        learningTheme: 'Preparation',
        introContent: IntroContent(
          description: '強化描述食材特性與處理動作。',
          vocabulary: [
            'ingredient',  // 食材
            'fillet',      // 魚片（動/名）
            'marinate',    // 醃漬（動詞）
            'texture',     // 口感
            'freshness',   // 新鮮度
          ],
          questions: lowScenePreTests['02-01']!,
        ),
        conversationContent: ConversationContent(
          script: '',
          messages: [],
        ),
        summaryContent: SummaryContent(
          summary: '小測：壽司前處理字彙！',
          questions: lowScenePostTests['02-01']!,
        ),
      ),
      Scene(
        id: '02-02',
        title: 'Rolling & Presentation',
        location: 'Café Counter',
        description: '捲壽司、擺盤、味覺平衡與風味描寫。',
        learningTheme: 'Plating & Flavor',
        introContent: IntroContent(
          description: '學會談擺盤與風味平衡。',
          vocabulary: [
            'assemble',      // 組合
            'garnish',       // 點綴物/裝飾
            'presentation',  // 擺盤呈現
            'balance',       // 平衡
            'savory',        // 鮮/鹹香
          ],
          questions: lowScenePreTests['02-02']!,
        ),
        conversationContent: ConversationContent(
          script: '',
          messages: [],
        ),
        summaryContent: SummaryContent(
          summary: '小測：擺盤與風味！',
          questions: lowScenePostTests['02-02']!,
        ),
      ),
    ]),
  ],
  bloomLevel: 1,
  status: JourneyStatus(day: 0, scene: 0, mode: 0),
  group: 'A',
  preTest: lowBizarrePreTest,
  postTest: lowBizarrePostTest
);

// === 高怪組：Trump / Disneyland + French（情境怪，但單字正常）===================
final Journey journeyHigh = Journey(
  id: 'high_food_trump',
  name: 'Disney French Session',
  day: 2,
  character: 'Trump',
  description: '在迪士尼樂園的臨時法式廚房裡跟著 Trump 學做菜，秀很瘋但詞彙很正經。',
  learningGoal: '用正規餐飲詞彙描述選材、烹飪技法與擺盤評論。',
  schedule: [
    // Day 1
    Day(title: 'Market & Bistro', scenes: [
      Scene(
        id: '01-01',
        title: 'Selecting Produce & Tools',
        location: 'Disney Market',
        description: '挑選食材與器具、注意衛生與醃料。',
        learningTheme: 'Sourcing',
        introContent: IntroContent(
          description: '用正式詞彙談選材與準備。',
          vocabulary: [
            'produce',    // 農產品/生鮮
            'selection',  // 選品
            'utensil',    // 器具
            'hygiene',    // 衛生
            'marinade',   // 醃料（名詞）
          ],
          questions: highScenePreTests['01-01']!,
        ),
        conversationContent: ConversationContent(
          script: '''
You are Donald Trump hosting a Disney cooking show.
ChatGPT 說：

Teaching Guide – Selecting Produce & Tools (Bloom L1)

Tone & Style:
Trump speaks loudly, confidently, and humorously. Uses exaggeration: “This is tremendous!” “Nobody does it better!” Keeps energy high but explains clearly.

Theme:
Scene: Trump at Disneyland Market teaching how to pick ingredients.
Focus words: produce, selection, utensil, hygiene, marinade.

Strategy:

Introduce each word dramatically.

Give simple examples: “Produce means fruits and vegetables.”

Use short, playful prompts to check comprehension.

Flow Example:
T: Welcome to the Disney Market! We’re finding the most tremendous produce. Do you know what “produce” means?
S: Fruits and vegetables.
T: Exactly! The best answer! Now, which one looks cleaner?
S: This one.
T: Great choice—perfect hygiene! You need hygiene to win at cooking. And the utensil—your secret weapon! A spoon, a whisk—tremendous tools!

Tips for AI Tutor:
Keep tone fun and bold.
Repeat key terms often.
Praise enthusiastically: “Fantastic!” “Incredible answer!”
Avoid politics; stay on food theme.
Short sentences, clear explanations, strong rhythm.
          ''',
          messages: [],
        ),
        summaryContent: SummaryContent(
          summary: '小測：選材與器具！',
          questions: highScenePostTests['01-01']!,
        ),
      ),
      Scene(
        id: '01-02',
        title: 'Bistro Ordering & Pairing',
        location: 'Disney Bistro',
        description: '訂位、前菜主菜概念、口感與餐酒搭配。',
        learningTheme: 'Dining Structure',
        introContent: IntroContent(
          description: '正式用餐流程與口味表達。',
          vocabulary: [
            'reservation', // 訂位
            'appetizer',   // 前菜
            'entree',      // 主菜
            'palate',      // 味覺/口味偏好
            'pairing',     // 搭配（常指餐酒）
          ],
          questions: highScenePreTests['01-02']!,
        ),
        conversationContent: ConversationContent(
          script: '',
          messages: [],
        ),
        summaryContent: SummaryContent(
          summary: '小測：用餐結構與搭配！',
          questions: highScenePostTests['01-02']!,
        ),
      ),
    ]),
    // Day 2
    Day(title: 'Techniques & Plating', scenes: [
      Scene(
        id: '02-01',
        title: 'Hot Techniques',
        location: 'Disney Kitchen',
        description: '實作煎、炒、小火燉、脫釉、打蛋器操作。',
        learningTheme: 'Techniques',
        introContent: IntroContent(
          description: '掌握核心熱處理技法的精準用語。',
          vocabulary: [
            'sauté',     // 快炒
            'simmer',    // 小火燉
            'sear',      // 大火快煎上色
            'deglaze',   // 脫釉
            'whisk',     // 打蛋器/打發
          ],
          questions: highScenePreTests['02-01']!,
        ),
        conversationContent: ConversationContent(
          script: '',
          messages: [],
        ),
        summaryContent: SummaryContent(
          summary: '小測：烹飪技法精準字！',
          questions: highScenePostTests['02-01']!,
        ),
      ),
      Scene(
        id: '02-02',
        title: 'Plating & Sensory Review',
        location: 'Disney Castle',
        description: '擺盤、口感一致性、對比、香氣與餘韻評論。',
        learningTheme: 'Critique',
        introContent: IntroContent(
          description: '用專業詞彙為菜色做感官評論。',
          vocabulary: [
            'plating',      // 擺盤（名詞）
            'consistency',  // 一致性（口感/濃度）
            'contrast',     // 對比
            'aroma',        // 香氣
            'aftertaste',   // 餘韻
          ],
          questions: highScenePreTests['02-02']!,
        ),
        conversationContent: ConversationContent(
          script: '',
          messages: [],
        ),
        summaryContent: SummaryContent(
          summary: '小測：專業擺盤與感官評論！',
          questions: highScenePostTests['02-02']!,
        ),
      ),
    ]),
  ],
  bloomLevel: 1,
  status: JourneyStatus(day: 0, scene: 0, mode: 0),
  group: 'B',
  preTest: highBizarrePreTest,
  postTest: lowBizarrePostTest
);

//-------------------------------------------------------------

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
    name: const LocalizedText(en: 'Trump', zh: '川普'),
    gender: const LocalizedText(en: 'Male', zh: '男生'),
    age: 70,
    imagePath: 'assets/images/trump/31.png',
    background: const LocalizedText(
      en: 'Current US president, eloquent, with clear likes and dislikes towards certain countries.',
      zh: '現任美國總統，口才犀利，對特定國家有明顯喜惡',
    ),
    personality: const LocalizedText(
      en: 'Confident, dramatic, straightforward',
      zh: '自信、戲劇化、直來直往',
    ),
    tone: const LocalizedText(
      en: 'Exaggerated, strong, American humor',
      zh: '誇張、強勢、美式幽默',
    ),
    slogan: '"Make America Great Again!"',
  ),
  Character(
    name: const LocalizedText(en: 'Teacher', zh: '老師'),
    gender: const LocalizedText(en: 'Female', zh: '女生'),
    age: 27,
    imagePath: 'assets/images/teacher/31.png',
    background: const LocalizedText(
      en: 'Simulated TOEFL speaking examiner, responsible for scenario-based assessments.',
      zh: '模擬托福補習班老師，負責情境對話的考察',
    ),
    personality: const LocalizedText(
      en: 'Rational, professional, slightly distant',
      zh: '理性、專業、略帶距離感',
    ),
    tone: const LocalizedText(
      en: 'Formal, organized, mildly pressuring',
      zh: '正式、有條理、輕微壓力感',
    ),
    slogan: '"Let’s see how you handle this!"',
  ),
  Character(
    name: const LocalizedText(en: 'American Boy', zh: '美國少年'),
    gender: const LocalizedText(en: 'Male', zh: '男生'),
    age: 10,
    imagePath: 'assets/images/american_boy/31.png',
    background: const LocalizedText(
      en: 'A sunny teenager from California who loves skateboarding and pop culture.',
      zh: '來自加州的陽光少年，喜歡滑板與流行文化',
    ),
    personality: const LocalizedText(
      en: 'Cheerful, laid-back, talkative',
      zh: '開朗、隨性、喜歡聊天',
    ),
    tone: const LocalizedText(
      en: 'Casual, American slang-filled',
      zh: '自然、美式口語、多slang',
    ),
    slogan: '"Dude, let’s hang out!"',
  ),
  Character(
    name: const LocalizedText(en: 'English Girl', zh: '英國少女'),
    gender: const LocalizedText(en: 'Female', zh: '女生'),
    age: 15,
    imagePath: 'assets/images/english_girl/31.png',
    background: const LocalizedText(
      en: 'A young lady from a prestigious family in London who loves reading and art.',
      zh: '倫敦名門出身的少女，喜歡閱讀與藝術',
    ),
    personality: const LocalizedText(
      en: 'Proud yet adorable, tough on the outside but soft-hearted, has refined taste, and values etiquette.',
      zh: '高傲可愛、嘴硬心軟、講究品味、重視禮儀',
    ),
    tone: const LocalizedText(
      en: 'British-style tsundere, sophisticated wording without being mean, playful tone.',
      zh: '英式傲嬌、用詞講究但不刻薄、語氣俏皮',
    ),
    slogan: '"Follow me, I know all the best places!"',
  ),
  Character(
    name: const LocalizedText(en: 'Harry Potter', zh: '哈利波特'),
    gender: const LocalizedText(en: 'Male', zh: '男生'),
    age: 17,
    imagePath: 'assets/images/harry_potter/31.png',
    background: const LocalizedText(
      en: 'The famous wizard from "Gryffindor" who fought "Voldemort".',
      zh: '來自葛來分多學院的著名巫師，曾與佛地魔對抗',
    ),
    personality: const LocalizedText(
      en: 'Brave, impulsive',
      zh: '勇敢、衝動',
    ),
    tone: const LocalizedText(
      en: 'often references "magic", "Hogwarts", "Dumbledore", "Quidditch", and "magic spells" like Expelliarmus.',
      zh: '常提到魔法、霍格華茲、鄧不利多、魁地奇，還會說出像「除你武器！」這樣的魔咒。',
    ),
    slogan: '"Welcome to my magic world!"',
  ),
];
