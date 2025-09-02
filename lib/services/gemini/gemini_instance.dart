import 'gemini.dart';

// 標記一下: 目前以下都是Irene的gemini_key
// 我開了五個都爛掉，所以先換gemini 2.0 flash是可行的，如果之後有其他問題再調整

// 呼叫gemini流程：做呼叫的agent -> geminiA(gemini_instance.dart) -> Gemini(gemini.dart)
/*
這裡定義如 geminiA,B,C...等 instance
  - 這裡呼叫 [gemini.dart的Gemini class]
  - 可以在這裡選擇要用哪個key的Gemini
  - [別的地方] 使用這裡：final response = await geminiA.sendPrompt(prompt);
*/

// geminiA
final geminiA = GeminiAuto([
  'AIzaSyCdLVSHgloBxBzS2FWC-IhHEBhDA0Gi2TE',
  'AIzaSyAP5c_Qn9zBKRKBc0l-yd0GvAzQjCEFVCY',
  'AIzaSyB-IKyPXBD0FF4VhwwaFs8uwuXsKi2dcpE',
  'AIzaSyDojRXuK4jVyDYWGF9JoP6DuHCHcXDkXrQ',
  'AIzaSyCt5QmNwLkT0knCr-2yx8osUIeOclKPh5o'
]);

// geminiB
final geminiB = GeminiAuto([
  'AIzaSyCNrf1R34xDfxmc6QzqU9J7l2O79lSBUNE',
  'AIzaSyCRpqIcc4Wf5Z1gqnSP23W7PT9ykgGE_IQ',
  'AIzaSyBcnlABFm99VVqdjd6tRzt5HwuY9sdDwnU',
  'AIzaSyDtAQ1HuYYo2DDTKfI-puJBNootAeWzFRI'

]);
