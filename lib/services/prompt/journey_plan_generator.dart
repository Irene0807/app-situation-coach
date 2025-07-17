
//prompt 之後都要大改。。。現在先隨便弄

String getJourneyPlanGeneratorPrompt(String userInput) {
  return '''
Help me generate a journey plan based on the user's input.
If the user input is null or empty, create any journey plan you like.
We aim to enhance the user's English skills through this journey.

user's input:
$userInput

The journey plan should follow this format:

<<name>>
[Journey Name]

<<day>>
[Number of Days, contains only numbers]

<<character>>
[Companion, only one person, choose from: Trump, TOEFL Interviewer, American kid, England kid, Harry Potter]

<<description>>
[Simple description of the journey, only main locations and activities, no details, no schedule]

<<goal>>
[Learning goals, such as language skills or cultural understanding]

Tips:
- <<name>>, <<day>>, <<character>>, <<description>>, and <<goal>> shouldn't be changed.
- [] should be replaced with the actual content.
''';
}

/*

journey plan example:
"
  (旅行名稱)
    日式文化探索之旅：東京與京都的七日冒險

  (旅行天數)
    7天

  (旅伴)
    川普

  (旅行內容)
    此行將造訪日本兩大代表城市──東京與京都。
    以下是旅行中將涵蓋的主要地點與活動
      東京：淺草雷門、晴空塔、澀谷、新宿、原宿
      京都：伏見稻荷大社、金閣寺、祇園、傳統和服體驗

  (學習目標)
    學習基本的日常交流用語
    理解日本文化與禮儀
"

*/