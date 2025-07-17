
//prompt 之後都要大改。。。現在先隨便弄

String getJourneyScheduleGeneratorPrompt(String plan) {
  return '''
Help me generate a detailed journey schedule based on the journey plan:

$plan

The journey schedule should follow this format:

<<day_1/title>> <<[Day 1 Title]>>

<<day_1/scene_1/title>> <<[Scene 1 Title]>>
<<day_1/scene_1/location>> <<[Location]>>
<<day_1/scene_1/theme>> <<[The learning theme of the scene]>>
<<day_1/scene_1/dialogue>> <<[The dialogue topics for the scene]>>

<<day_1/scene_2/title>> <<[Scene 2 Title]>>
<<day_1/scene_2/location>> <<[Location]>>
<<day_1/scene_2/theme>> <<[The learning theme of the scene]>>
<<day_1/scene_2/dialogue>> <<[The dialogue topics for the scene]>>

<<day_2/title>> <<[Day 2 Title]>>

...

Tips:
- The word in the brackets <<>> shouldn't be changed.
- [] should be replaced with the actual content.
- Each day should have 2 to 4 scenes.
''';
}

/*

journey schedule example:
"
  (第一天) 抵達東京：啟程與初體驗
    (場景一) 機場入境
      (地點) 日本成田機場
      (主題) 機場英語
      (對話內容) 入境問答、詢問行李轉盤位置

    (場景二) 飯店Check-in
      (地點) 淺草地區飯店
      (主題) 住宿英語
      (對話內容) 報到入住、確認預訂、要求備品

    (場景三) 晚餐初體驗
      (地點) 居酒屋
      (主題) 餐廳英語
      (對話內容) 點餐、詢問推薦、了解特色料理

  (第二天)

  ...

"

*/