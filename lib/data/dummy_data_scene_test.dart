import '../models/question.dart';

/// ===============================
///  Low (Teacher / Café + Sushi)
/// ===============================

final Map<String, List<Question>> lowScenePreTests = {
  '01-01': [
    Question(
      questionText: "Translate \"鬆餅\" to English — what’s the correct word?",
      options: ['Syrup waffles', 'Pancakes', 'Sweet crackers', 'Cake rolls'],
      answerId: 1,
    ),
    Question(
      questionText: "How do you say \"炒蛋\" in English?",
      options: [
        'Scrambled eggs',
        'Boiled yolk',
        'Creamy custard',
        'Rolled omelette'
      ],
      answerId: 0,
    ),
    Question(
      questionText: "Choose the correct translation for \"薯餅\".",
      options: ['Potato bricks', 'Crispy hash', 'Hash browns', 'Golden fries'],
      answerId: 2,
    ),
    Question(
      questionText: "How do you say \"兩面煎但蛋黃半熟的蛋\" in English?",
      options: [
        'Over medium',
        'Middle fried yolk',
        'Half-ready sunny',
        'Soft skillet egg'
      ],
      answerId: 0,
    ),
    Question(
      questionText: "What does \"單面煎蛋\" mean in English?",
      options: [
        'Half-fried omelette',
        'Sunny-side up',
        'Crispy egg top',
        'Morning skillet'
      ],
      answerId: 1,
    ),
    Question(
      questionText: "Translate '煎蛋捲' into English. What's the correct word?",
      options: ['Scrambled egg', 'Omelette', 'Pancake', 'Crepe'],
      answerId: 1,
    ),
    Question(
      questionText: "At a diner, what is '培根' in English?",
      options: ['Bacon', 'Sausage', 'Ham', 'Steak'],
      answerId: 0,
    ),
  ],
  '01-02': [
    Question(
      questionText: "How would you say \"拿鐵\" in English?",
      options: ['placid', 'Latte', 'Single-origin', 'candor'],
      answerId: 1,
    ),
    Question(
      questionText: "Translate \"義式濃縮\" to English. Which one is correct?",
      options: ['Cold brew', 'hindrance', 'Espresso', 'lucid'],
      answerId: 2,
    ),
    Question(
      questionText: "Do you know the English for \"冷萃咖啡\"? Pick the right one.",
      options: ['Cold brew', 'rhetoric', 'Decaf', 'Latte'],
      answerId: 0,
    ),
    Question(
      questionText: "How do you say \"單一產區咖啡\" in English?",
      options: ['Single-origin', 'menagerie', 'Espresso', 'conjecture'],
      answerId: 0,
    ),
    Question(
      questionText:
          "If someone orders \"低因咖啡\", what are they asking for in English?",
      options: ['Single-origin', 'Decaf', 'Latte', 'tapestry'],
      answerId: 1,
    ),
    Question(
      questionText: "Translate '摩卡' into English. Which one is correct?",
      options: ['Mocha', 'Latte', 'Espresso', 'Macchiato'],
      answerId: 0,
    ),
    Question(
      questionText: "You see '卡布奇諾' on a menu. What is it in English?",
      options: ['Americano', 'Cappuccino', 'Mocha', 'Flat white'],
      answerId: 1,
    ),
  ],
  '02-01': [
    Question(
      questionText:
          "Translate \"奶油起司抹醬\" into English. What's the correct word?",
      options: [
        'Cheese whip',
        'Cream cheese',
        'Butter jam',
        'Fresh milk spread',
      ],
      answerId: 1,
    ),
    Question(
      questionText: "How would you say \"原味貝果\" in English?",
      options: ['Sesame bagel', 'Plain bagel', 'Bagel roll', 'Wheat donut'],
      answerId: 1,
    ),
    Question(
      questionText:
          "If someone orders a \"芝麻口味的貝果\", which bagel are they asking for?",
      options: [
        'Plain bagel',
        'Toasted roll',
        'Cinnamon bagel',
        'Sesame bagel',
      ],
      answerId: 3,
    ),
    Question(
      questionText: "What's the English name for \"燻鮭魚抹醬\"?",
      options: [
        'Smoked salmon spread',
        'Salmon butter',
        'Creamy fish dip',
        'Seafood jam'
      ],
      answerId: 0,
    ),
    Question(
      questionText:
          "You see \"煙燻鮭魚切片(百吉圈常用配料)\" on a menu. Which English word matches it?",
      options: ['Salmon roll', 'Fish slices', 'Lox', 'Cured tuna'],
      answerId: 2,
    ),
    Question(
      questionText: "Which English word means '藍莓'?",
      options: ['Blueberry', 'Raspberry', 'Cranberry', 'Blackberry'],
      answerId: 0,
    ),
    Question(
      questionText: "When you see '洋蔥貝果', how do you say '洋蔥' in English?",
      options: ['Onion', 'Garlic', 'Scallion', 'Chili'],
      answerId: 0,
    ),
  ],
  '02-02': [
    Question(
      questionText: "Hungry already? How do you say \"早午餐\" in English?",
      options: [
        'Supper',
        'Tea break',
        'Midnight snack',
        'Brunch',
      ],
      answerId: 3,
    ),
    Question(
      questionText: "Chef exam! What is the English word for \"白醬\"?",
      options: ['Cream sauce', 'Béchamel', 'Milk roux', 'Velouté'],
      answerId: 1,
    ),
    Question(
      questionText:
          "Translate this cooking term: \"蒜味蛋黃醬\". Which one is correct?",
      options: [
        'Tartar sauce',
        'Garlic dip',
        'Egg mayo dressing',
        'Aioli',
      ],
      answerId: 3,
    ),
    Question(
      questionText:
          "In a restaurant, how would you translate \"菜單描述\" into English?",
      options: [
        'Order summary',
        'Menu description',
        'Customer review',
        'Meal notice'
      ],
      answerId: 1,
    ),
    Question(
      questionText:
          "Fancy French cuisine? How do you say \"發酵鮮奶油\" in English?",
      options: [
        'Heavy cream',
        'Custard cream',
        'Crème fraîche',
        'Fermented butter'
      ],
      answerId: 2,
    ),
    Question(
      questionText: "Translate '荷蘭醬' into English.",
      options: ['Hollandaise', 'Aioli', 'Béchamel', 'Mayonnaise'],
      answerId: 0,
    ),
    Question(
      questionText: "How do you say '酪梨' in English?",
      options: ['Avocado', 'Mango', 'Melon', 'Kiwi'],
      answerId: 0,
    ),
  ],
};

final Map<String, List<Question>> lowScenePostTests = {
  '01-01': [
    Question(
      questionText:
          "I'm ordering breakfast. What does 'scrambled eggs' mean in Chinese?",
      options: ['炒蛋', '陽光', '堅果', '湯匙'],
      answerId: 0,
    ),
    Question(
      questionText:
          "What does 'pancakes' mean in Chinese? I want something sweet for breakfast.",
      options: [
        '燈塔',
        '外套',
        '奶油麵包',
        '鬆餅',
      ],
      answerId: 3,
    ),
    Question(
      questionText:
          "At the diner, I said I want my eggs 'sunny-side up'. What does that mean in Chinese?",
      options: ['太陽蛋', '炒高麗菜', '烤土司', '馬鈴薯泥'],
      answerId: 0,
    ),
    Question(
      questionText: "I'm hungry! What are 'hash browns' in Chinese?",
      options: ['杏仁片', '薯餅', '奶茶', '蕃茄片'],
      answerId: 1,
    ),
    Question(
      questionText:
          "How do you want your eggs? What does 'over medium' mean in Chinese?",
      options: ['堅硬的石頭', '豆漿', '七分熟煎蛋', '水煮蛋'],
      answerId: 2,
    ),
    Question(
      questionText: "You ordered an 'omelette' for breakfast. What does it mean in Chinese?",
      options: ['煎蛋捲', '炒飯', '薯條', '鬆餅'],
      answerId: 0,
    ),
    Question(
      questionText: "What does 'bacon' mean in Chinese?",
      options: ['火腿', '雞腿', '培根', '麵包'],
      answerId: 2,
    ),
  ],
  '01-02': [
    Question(
      questionText:
          "I'm at a café ordering a drink. What does 'latte' mean in Chinese?",
      options: [
        '綠茶',
        '葡萄汁',
        '海洋',
        '拿鐵',
      ],
      answerId: 3,
    ),
    Question(
      questionText:
          "You need a strong morning boost. What does 'espresso' mean in Chinese?",
      options: ['濃縮咖啡', '紙箱', '沙漠', '番茄汁'],
      answerId: 0,
    ),
    Question(
      questionText:
          "On a hot day, I prefer 'cold brew'. What is its Chinese meaning?",
      options: ['地毯', '冷萃咖啡', '冰箱', '花園'],
      answerId: 1,
    ),
    Question(
      questionText:
          "Before bed, I drink 'decaf'. What does it mean in Chinese?",
      options: ['衛星', '無咖啡因咖啡', '運動鞋', '藍色小屋'],
      answerId: 1,
    ),
    Question(
      questionText:
          "This café serves 'single-origin' coffee. What is the Chinese meaning?",
      options: [
        '火山口',
        '郵局',
        '香蕉奶昔',
        '單一產區',
      ],
      answerId: 3,
    ),
    Question(
      questionText: "I love drinking 'mocha'. What does it mean in Chinese?",
      options: ['摩卡咖啡', '奶茶', '果汁', '熱可可'],
      answerId: 0,
    ),
    Question(
      questionText: "Your friend ordered a 'cappuccino'. What is it in Chinese?",
      options: ['拿鐵', '卡布奇諾', '黑咖啡', '冷萃'],
      answerId: 1,
    ),
  ],
  '02-01': [
    Question(
      questionText:
          "At the café, you ordered a *plain bagel*. What does 'plain bagel' mean in Chinese?",
      options: ['奶油麵包', '煎鬆餅', '原味貝果', '黑糖甜甜圈'],
      answerId: 2,
    ),
    Question(
      questionText:
          "I spread some *cream cheese* on my bread. What does 'cream cheese' mean in Chinese?",
      options: [
        '花生奶霜',
        '優格醬',
        '椰奶抹醬',
        '奶油乳酪',
      ],
      answerId: 3,
    ),
    Question(
      questionText:
          "He bought a *sesame bagel* for breakfast. What does 'sesame bagel' mean in Chinese?",
      options: ['蜂蜜麵包', '芝麻貝果', '葡萄乾吐司', '奶油可頌'],
      answerId: 1,
    ),
    Question(
      questionText:
          "She loves *smoked salmon spread* on her toast. What does it mean in Chinese?",
      options: ['煙燻鮭魚抹醬', '醃檸檬乳霜', '香草奶油醬', '鮪魚沙拉醬'],
      answerId: 0,
    ),
    Question(
      questionText:
          "They served *lox* on a bagel. What does 'lox' mean in Chinese?",
      options: ['醃製鮭魚片', '煎火腿', '烤牛肉片', '煙燻雞絲'],
      answerId: 0,
    ),
    Question(
      questionText: "This bagel has 'blueberry'. What does that mean in Chinese?",
      options: ['藍莓', '草莓', '櫻桃', '哈密瓜'],
      answerId: 0,
    ),
    Question(
      questionText: "What does 'onion' mean in Chinese?",
      options: ['洋蔥', '蒜頭', '蔥', '青椒'],
      answerId: 0,
    ),
  ],
  '02-02': [
    Question(
      questionText:
          "You're on vacation and wake up late. What does 'brunch' mean in Chinese?",
      options: ['小吃', '早午餐', '宵夜', '套餐'],
      answerId: 1,
    ),
    Question(
      questionText:
          "At a restaurant, you read a long 'menu description'. What is the Chinese meaning of this phrase?",
      options: ['菜單描述', '點餐服務', '廚師特輯', '顧客回饋'],
      answerId: 0,
    ),
    Question(
      questionText:
          "In cooking class, the chef teaches 'béchamel'. What does it mean in Chinese?",
      options: ['黑胡椒', '蒜末', '白醬', '烤盤'],
      answerId: 2,
    ),
    Question(
      questionText:
          "This sauce goes great with fries—what does 'aioli' mean in Chinese?",
      options: ['咖哩粉', '番茄丁', '蒜味美乃滋', '醃檸檬'],
      answerId: 2,
    ),
    Question(
      questionText:
          "The recipe says to add 'crème fraîche'. What is the Chinese meaning?",
      options: ['煎餅糊', '法式鮮奶油', '牛骨湯', '奶油起司'],
      answerId: 1,
    ),
    Question(
      questionText: "What does 'hollandaise' mean in Chinese?",
      options: ['荷蘭醬', '蒜味奶油', '白醬', '優格醬'],
      answerId: 0,
    ),
    Question(
      questionText: "She added 'avocado' to her toast. What does that mean in Chinese?",
      options: ['香蕉', '酪梨', '鳳梨', '芒果'],
      answerId: 1,
    ),
  ],
};

/// ===============================
///  High (Trump / Disney + French)
/// ===============================

final Map<String, List<Question>> highScenePreTests = {
  '01-01': [
    Question(
      questionText: "How would you say \"楊桃\" in English?",
      options: ['Starfruit', 'Grapefruit', 'Persimmon', 'Carambola'],
      answerId: 0,
    ),
    Question(
      questionText: "Translate \"海藻\" to English. Do you know the word?",
      options: ['Kelp', 'Seaweed', 'Seashell', 'Coral'],
      answerId: 1,
    ),
    Question(
      questionText: "What is the correct English for \"野生山藥\"?",
      options: ['Wild yam', 'Sweet potato', 'Cassava', 'Taro root'],
      answerId: 0,
    ),
    Question(
      questionText:
          "If someone loves growing \"多肉植物\", what is the English word for it?",
      options: ['Shrub', 'Succulent', 'Vine', 'Bonsai'],
      answerId: 1,
    ),
    Question(
      questionText: "How do you say \"樹薯根\" in English?",
      options: ['Lotus root', 'Sugar beet', 'Tapioca root', 'Arrowroot'],
      answerId: 2,
    ),
    Question(
      questionText: "Translate '椰子' into English.",
      options: ['Coconut', 'Mango', 'Banana', 'Palm'],
      answerId: 0,
    ),
    Question(
      questionText: "How do you say '木瓜' in English?",
      options: ['Papaya', 'Peach', 'Guava', 'Lychee'],
      answerId: 0,
    ),
  ],
  '01-02': [
    Question(
      questionText: "How would you translate \"鞭打\" into English?",
      options: ['Platform', 'Lash', 'Carve', 'Frost'],
      answerId: 1,
    ),
    Question(
      questionText: "What is the English word for \"月台\"?",
      options: ['Platform', 'Canyon', 'Ribbon', 'Shelter'],
      answerId: 0,
    ),
    Question(
      questionText: "Translate \"確保安全\" to English. Which word fits best?",
      options: ['Secure', 'Melt', 'Bracelet', 'Tumble'],
      answerId: 0,
    ),
    Question(
      questionText: "Do you know how to say \"壁爐前的地面\" in English?",
      options: [
        'Lantern',
        'Harvest',
        'Coconut',
        'Hearth',
      ],
      answerId: 3,
    ),
    Question(
      questionText: "What does \"扁斧\" translate to in English?",
      options: ['Canvas', 'Galaxy', 'Adze', 'Shutter'],
      answerId: 2,
    ),
    Question(
      questionText: "Translate '繩子' into English.",
      options: ['Rope', 'Thread', 'String', 'Cord'],
      answerId: 0,
    ),
    Question(
      questionText: "In building a shelter, what is the English word for '竿子'?",
      options: ['Pole', 'Bar', 'Stick', 'Rod'],
      answerId: 0,
    ),
  ],
  '02-01': [
    Question(
      questionText: "In cooking instructions, how do you say『折疊』in English?",
      options: ['Slice', 'Fold', 'Crush', 'Whisk'],
      answerId: 1,
    ),
    Question(
      questionText:
          "To make dough, you must『揉麵』first. What's the correct verb in English?",
      options: ['Stir', 'Chop', 'Peel', 'Knead'],
      answerId: 3,
    ),
    Question(
      questionText: "When making dumplings, what do we call the『外皮』in English?",
      options: ['Wrapper', 'Shell', 'Crust', 'Skin'],
      answerId: 0,
    ),
    Question(
      questionText:
          "For buns or dumplings, the『內餡』is known as what in English?",
      options: ['Stuff', 'Filling', 'Paste', 'Mix'],
      answerId: 1,
    ),
    Question(
      questionText: "In bread or wine making, how do you say『發酵』in English?",
      options: ['Ferment', 'Defrost', 'Season', 'Blend'],
      answerId: 0,
    ),
    Question(
      questionText: "How do you say '蒸' in English?",
      options: ['Steam', 'Boil', 'Bake', 'Fry'],
      answerId: 0,
    ),
    Question(
      questionText: "Translate '麵團' into English.",
      options: ['Dough', 'Bread', 'Crust', 'Paste'],
      answerId: 0,
    ),
  ],
  '02-02': [
    Question(
      questionText: "How would you say \"酥脆的\" in English?",
      options: ['spicy', 'crisp', 'soft', 'chewy'],
      answerId: 1,
    ),
    Question(
      questionText: "Translate \"辛辣的\" into English. Which one is correct?",
      options: ['bitter', 'tasteless', 'spicy', 'creamy'],
      answerId: 2,
    ),
    Question(
      questionText: "Do you know the English word for \"甜鹹的\"?",
      options: ['savory-sweet', 'plain', 'rich', 'fluffy'],
      answerId: 0,
    ),
    Question(
      questionText: "What does \"泥土味的\" translate to in English?",
      options: ['earthy', 'zesty', 'oily', 'watery'],
      answerId: 0,
    ),
    Question(
      questionText: "How to say \"清新又帶勁的\" in English?",
      options: ['salty', 'zesty', 'starchy', 'sticky'],
      answerId: 1,
    ),
    Question(
      questionText: "When describing food, what does '芳香的' translate to in English?",
      options: ['Aromatic', 'Fragrant', 'Spicy', 'Sweet'],
      answerId: 0,
    ),
    Question(
      questionText: "Translate '嫩的' into English.",
      options: ['Tender', 'Soft', 'Juicy', 'Chewy'],
      answerId: 0,
    ),
  ],
};



final Map<String, List<Question>> highScenePostTests = {
  '01-01': [
    Question(
      questionText:
          "You're at a tropical market. What does 'starfruit' mean in Chinese?",
      options: ['海星果', '楊桃', '地瓜葉', '燈籠果'],
      answerId: 1,
    ),
    Question(
      questionText:
          "You find something green by the beach. What does 'seaweed' mean in Chinese?",
      options: ['海草', '洋蔥', '海藻', '青苔'],
      answerId: 2,
    ),
    Question(
      questionText:
          "Grandma is cooking a mountain dish. What does 'wild yam' mean in Chinese?",
      options: ['山藥', '野山芋', '蓮藕', '牛蒡'],
      answerId: 0,
    ),
    Question(
      questionText:
          "In a plant shop, you hear: This is a 'succulent'. What does it mean in Chinese?",
      options: ['盆景', '仙人掌', '多肉植物', '含水植物'],
      answerId: 2,
    ),
    Question(
      questionText:
          "A dessert vendor says the ingredient is 'tapioca root'. What is its Chinese meaning?",
      options: ['樹薯', '芋頭', '木薯根', '葛根'],
      answerId: 3,
    ),
    Question(
      questionText: "You found a 'coconut' on the beach. What does it mean in Chinese?",
      options: ['芒果', '椰子', '鳳梨', '香瓜'],
      answerId: 1,
    ),
    Question(
      questionText: "What does 'papaya' mean in Chinese?",
      options: ['蘋果', '木瓜', '奇異果', '橘子'],
      answerId: 1,
    ),
  ],
  '01-02': [
    Question(
      questionText:
          "You see a movie scene where someone gets hit by a whip. What does the word 'lash' mean in Chinese?",
      options: ['鞭打', '棉被', '磁鐵', '香氣'],
      answerId: 0,
    ),
    Question(
      questionText:
          "At the train station, people wait for their ride on the 'platform'. What is the Chinese meaning of 'platform'?",
      options: ['平台', '音量', '海報', '鯨魚'],
      answerId: 0,
    ),
    Question(
      questionText:
          "If you want to make your house safe, you must 'secure' it. What does 'secure' mean in Chinese?",
      options: ['搖晃', '移動', '保護、固定', '釀造'],
      answerId: 2,
    ),
    Question(
      questionText:
          "In old houses, a family might sit by the warm 'hearth'. What does 'hearth' mean in Chinese?",
      options: ['灶台 / 炉床', '雕刻', '象牙', '長廊'],
      answerId: 0,
    ),
    Question(
      questionText:
          "A craftsman uses an 'adze' to shape wood. What is the Chinese of 'adze'?",
      options: ['魚叉', '扁斧', '羅盤', '翼龍'],
      answerId: 1,
    ),
    Question(
      questionText: "What does 'rope' mean in Chinese?",
      options: ['繩子', '鐵鍊', '電線', '木條'],
      answerId: 0,
    ),
    Question(
      questionText: "You tied the tent to a 'pole'. What does that mean in Chinese?",
      options: ['石頭', '棍子 / 竿子', '木屑', '繩索'],
      answerId: 1,
    ),
  ],
  '02-01': [
    Question(
      questionText:
          "In cooking class, the teacher said we need to *fold* the dough gently. What does 'fold' mean in Chinese?",
      options: ['浸泡', '折疊', '雕刻', '熄滅'],
      answerId: 1,
    ),
    Question(
      questionText:
          "To make bread, we must *knead* the dough for a smooth texture. What does 'knead' mean in Chinese?",
      options: ['烘烤', '揉捏', '灑鹽', '削皮'],
      answerId: 1,
    ),
    Question(
      questionText:
          "To make dumplings, you first place meat on the *wrapper*. What does 'wrapper' mean in Chinese?",
      options: ['外皮', '鍋鏟', '湯匙', '砂糖'],
      answerId: 0,
    ),
    Question(
      questionText:
          "The chef said the *filling* must be juicy. What does 'filling' mean in Chinese?",
      options: [
        '調味料',
        '碗盤',
        '火焰',
        '內餡',
      ],
      answerId: 3,
    ),
    Question(
      questionText:
          "To make yogurt, you must let the milk *ferment*. What does 'ferment' mean in Chinese?",
      options: [
        '沸騰',
        '冷凍',
        '漂洗',
        '發酵',
      ],
      answerId: 3,
    ),
    Question(
      questionText: "The chef said to 'steam' the buns. What does it mean in Chinese?",
      options: ['蒸', '烤', '炸', '煮'],
      answerId: 0,
    ),
    Question(
      questionText: "What does 'dough' mean in Chinese?",
      options: ['麵團', '醬汁', '麵粉', '餅皮'],
      answerId: 0,
    ),
  ],
  '02-02': [
    Question(
      questionText:
          "On the menu it says the fries are 'crisp'. What does 'crisp' mean in Chinese?",
      options: ['沉重的', '疲倦的', '脆的', '溼潤的'],
      answerId: 2,
    ),
    Question(
      questionText:
          "This curry tastes really 'spicy'! What does 'spicy' mean in Chinese?",
      options: ['緩慢的', '微弱的', '辛辣的', '空洞的'],
      answerId: 2,
    ),
    Question(
      questionText:
          "The sauce has a 'savory-sweet' flavor. What does 'savory-sweet' mean in Chinese?",
      options: [
        '灰灰的',
        '苦澀的',
        '巨大的',
        '香甜的',
      ],
      answerId: 3,
    ),
    Question(
      questionText:
          "The soup has an 'earthy' aroma. What does 'earthy' mean in Chinese?",
      options: [
        '結冰的',
        '柔軟的',
        '透明的',
        '泥土味的',
      ],
      answerId: 3,
    ),
    Question(
      questionText:
          "This lemonade tastes very 'zesty'! What does 'zesty' mean in Chinese?",
      options: ['刺激又帶勁的', '寒冷的', '寬廣的', '尖銳的'],
      answerId: 0,
    ),
    Question(
      questionText: "The soup smells 'aromatic'. What does that mean in Chinese?",
      options: ['辣的', '芳香的', '酸的', '苦的'],
      answerId: 1,
    ),
    Question(
      questionText: "This meat is so 'tender'. What does it mean in Chinese?",
      options: ['堅硬的', '乾的', '嫩的', '濕的'],
      answerId: 2,
    ),
  ],
};
