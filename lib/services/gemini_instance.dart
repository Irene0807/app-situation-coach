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
final geminiA = Gemini('AIzaSyDs7PSmhRj2FSQ9er894euSlVIZOBJ_eM0');
// 舊key 用起來卡卡的 可能要調整
// AIzaSyDXG6c-9PyKz_CCV34imRaBccpI4KJwva4
// AIzaSyAHkrfvYN0AYUkPReEEXk7pub3faaV8EFY
// AIzaSyBcnh2eozUoF8NEF8Y-XLmu7n9o1YS3Da0

// geminiB: 生成respond用
final geminiB = Gemini('AIzaSyDovtn7n-5rRxTBr6V3bTEgXwWFsBaf0p8');
// 備用：
// AIzaSyB5M_n84f36X_P5LIZ-3pgRHdTOwUrVe0Q
// AIzaSyA33CmwNM2VVLrQYrNv0-6tl4NUp8hglao
// AIzaSyCLVKQ4hbi9V4WrQfVvPcOz7lOrpv145ws
