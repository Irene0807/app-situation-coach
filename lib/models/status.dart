import '../models/journey.dart';

// 下面有介紹旅行頁面順序

/*
超級重點強調:
  設計理念: day, scene, mode配合使用者介面的天數等數值 故以1為基準
  問題:    coding時 list裡面都是以0為基準

  解決方法: 一般使用沒毛病 一旦將day, scene, mode放到list裡作為參數 ***記得-1***
*/

class JourneyStatus {
  int day;
  int scene;
  int mode; // 1: intro // 2: conversation // 3: summary

  // JourneyStatus預設從(-3 -3 -3)開始
  JourneyStatus({
    int? day,
    int? scene,
    int? mode,
  })  : day = -3, // 從前冊頁面開始
        scene = -3,
        mode = -3;

  bool goNextStatus(Journey j) {
    if (day == -3 && scene == -3 && mode == -3) {
      // 前測頁面 -> 旅行封面
      day = 0;
      scene = 0;
      mode = 0;
      return true;
    } else if (day == j.schedule.length &&
        scene == j.schedule[day - 1].scenes.length &&
        mode == 3) {
      // 最後一頁 -> 結束頁面
      day = 4;
      scene = 4;
      mode = 4;
      return true;
    } else if (day == 4 && scene == 4 && mode == 4) {
      // 結束頁面 -> 後測頁面
      day = -2;
      scene = -2;
      mode = -2;
      return true;
    } else if (day == -2 && scene == -2 && mode == -2) {
      // 後測頁面 -> 旅行已完成
      day = -1;
      scene = -1;
      mode = -1;
      return false;
    } else if (day == 0 ||
        (scene == j.schedule[day - 1].scenes.length && mode == 3)) {
      day++;
      scene = 0;
      mode = 0;
      return true;
    } else if (scene == 0 || mode == 3) {
      scene++;
      mode = 0;
      return true;
    } else {
      mode++;
      return true;
    }
  }

  bool isCompleted() {
    return (day == -1 && scene == -1 && mode == -1);
  }
}

/*
以一個兩天的旅行為例 (day, scene, mode)

(-3,-3,-3): 前測頁面

(0, 0, 0): 旅行封面       // 整個旅行的封面
  (1, 0, 0): 天數頁面     // 目錄的概念 每過一天會揭露下一天的旅行名稱
    (1, 1, 0): 場景頁面   // 目錄的概念 每過一個場景會揭露下一個場景名稱 //也可簡單介紹該場景
      (1, 1, 1): 旅行頁面 // 單字介紹
      (1, 1, 2): 旅行頁面 // 和ai對話
      (1, 1, 3): 旅行頁面 // scene總結 + 題目考試
    (1, 2, 0): 場景頁面
      (1, 2, 1): 旅行頁面 
      (1, 2, 2): 旅行頁面 
      (1, 2, 3): 旅行頁面 
  (2, 0 ,0): 天數頁面
    (2, 1, 0): 場景頁面
      (2, 1, 1): 旅行頁面 
      (2, 1, 2): 旅行頁面
      (2, 1, 3): 旅行頁面
(4, 4, 4): 結束頁面

(-2,-2,-2): 後測頁面

(-1,-1,-1): 旅行已完成
*/
