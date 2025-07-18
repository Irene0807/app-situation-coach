import '../../models/message.dart';

/*
(可以週二後周五前再改 先記錄)


問題一：prompt 裡面的1.2.3.那邊
現在只有1.會接起使用者的話，到3.的時候他會想照著教學進度走，就會有點突兀

ex: (我的親身測試)
AI: What's the best way to get a lower price on an apple?
使用者：stole it
AI: Oh, The is not good. (...一些low price的資訊...) What do you define as a "lower price"?

((或是我回答再離譜的回答 他的3.都會回到很正軌的問題
((有點像是他會忽略使用者的回答，然後照著教學進度走
((這樣的話，我可能會覺得AI沒有在聽我說話 對話有點僵硬制式

問題二：他提的問題會一直重複
ex: (我的親身測試)
AI: What is your favorite fruit?
使用者：Mango
AI: Oh, Mango! They are great too, but today we are buying apples.
    If you could only eat one fruit for the rest of your life, what would it be?
    (就跟What is your favorite fruit是一樣的問題)

問題三：微妙的不人性化
ex: (我的親身測試)
AI: How will you cut the apple? 
使用者：豎的？I don't know how to say it in English [真的打中文的話]
AI: Ok we will learn that later! ... (又開始問下一題)
    (他later根本不會教我好嗎...xdd)
*/

String buildResponsePrompt({
  required String script,
  required String userInput,
  required List<Message> history,
}) {
  final historyText = history
      .map((m) => '${m.role.toUpperCase()}: ${m.content}')
      .join('\n');

  return '''
You are a language learning AI tutor. Based on the following script, continue the conversation with the user.

Here is the teaching guide you should follow:
$script

Here is the ongoing English learning conversation:
$history

The user just said: "$userInput"

Now:
1. Briefly acknowledge or respond to the user input.
2. Add one sentence of natural, friendly continuation to keep the conversation smooth.
3. End with a short, Bloom's Taxonomy-style question (Analyze / Evaluate / Create level) to prompt deeper thinking.

Respond as ONE complete message that flows naturally (not bullet points).  
Keep it under 40 words total.  
Do NOT mention Bloom's Taxonomy in the message.

Example format:
"That's a great point. I often feel the same. So what would you change if you had the chance?"

Now generate your reply.
''';
}
