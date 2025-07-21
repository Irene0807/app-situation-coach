import 'gemini.dart';

// 標記一下: 這兩個都是Irene的gemini_key

// 呼叫gemini流程：做呼叫的agent -> geminiA(gemini_instance.dart) -> Gemini(gemini.dart)

/*
這裡定義如 geminiA,B,C...等 instance
  - 這裡呼叫 [gemini.dart的Gemini class]
  - 可以在這裡選擇要用哪個key的Gemini
  - [別的地方] 使用這裡：final response = await geminiA.sendPrompt(prompt);
*/

// geminiA: 生成shcedule
final geminiA = Gemini('AIzaSyB5M_n84f36X_P5LIZ-3pgRHdTOwUrVe0Q'); 

// geminiB: 生成respond用 
final geminiB = Gemini('AIzaSyDXG6c-9PyKz_CCV34imRaBccpI4KJwva4');
