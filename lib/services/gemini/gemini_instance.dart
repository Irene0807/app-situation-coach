import 'gemini.dart';

// 呼叫gemini流程：做呼叫的agent -> geminiA(gemini_instance.dart) -> Gemini(gemini.dart)
/*
這裡定義如 geminiA,B,C...等 instance
  - 這裡呼叫 [gemini.dart的Gemini class]
  - 可以在這裡選擇要用哪個key的Gemini
  - [別的地方] 使用這裡：final response = await geminiA.sendPrompt(prompt);
*/

// geminiA
final geminiA = GeminiAuto([

  //irene - 1
  'AIzaSyABkzI_k_tcCuPdBve695o8MPgnO_vANmA', //1
  'AIzaSyDXG6c-9PyKz_CCV34imRaBccpI4KJwva4', //2
  'AIzaSyB5M_n84f36X_P5LIZ-3pgRHdTOwUrVe0Q', //3
  'AIzaSyCt5QmNwLkT0knCr-2yx8osUIeOclKPh5o', //4
  'AIzaSyDojRXuK4jVyDYWGF9JoP6DuHCHcXDkXrQ', //5
  'AIzaSyDs7PSmhRj2FSQ9er894euSlVIZOBJ_eM0', //6
  'AIzaSyDovtn7n-5rRxTBr6V3bTEgXwWFsBaf0p8', //7
  'AIzaSyDmv_b_ny6B5EVswbueLl77qbA9rNfVuyI', //8
  'AIzaSyB2OxUCEEPWLVVyrspek6LxAE10GkSCoq0', //9
  'AIzaSyBnaUu1ltEDRGulrMKsSg6bscDlQV61aG8', //10
  'AIzaSyA6Rgn1pItIMeErxOCZNYvObIDHKs3Aw84', //11
  'AIzaSyBpnYXfalFctV6OAudQCBr3AQ6WpSkNWZY', //12
  'AIzaSyAajSXig_RgesJMJ_IKZLiQYng4OybaWkE', //13
  'AIzaSyC-pakQPAkEwCH__jKliiaE3HflrBQk2QA', //14
  'AIzaSyC-pakQPAkEwCH__jKliiaE3HflrBQk2QA', //15

  // irene-2
  'AIzaSyC6iDJ6dQB5-5icbG9OxXmBBKOn3nnnEyA', //1
  'AIzaSyAo65h4lR9r4EpTX1Bpm2rhjPnF8tdV2HY', //2
  'AIzaSyBV3ABMMDoB-QtTOp_jrz2hemY1ldGANpY', //3
  'AIzaSyCSPueUQLrHREBZpuwDBVrEUmtP7rcJsFs', //4
  'AIzaSyCVOOKEFm98ED-Nz-WDPBEsQEQv3QBjIAg', //5
  'AIzaSyBlbqbEAum-bdqvLQa93WWahQNesNBTFgE', //6
  'AIzaSyCBmMYnjkWXAGh62nswydNiA_z469jyfvE', //7
  'AIzaSyCCuWSK-3t53UrygGUhHR0iLkqQWTctiwo', //8
  'AIzaSyAl0X9TJU_ByYPW3riA60x-zDjcRtnIrCY', //9
  'AIzaSyD6XqwWrWXcgYNctx8J-aNS-rhCjrJmctc', //10


  // 'AIzaSyCdLVSHgloBxBzS2FWC-IhHEBhDA0Gi2TE',
  // 'AIzaSyAP5c_Qn9zBKRKBc0l-yd0GvAzQjCEFVCY',
  // 'AIzaSyB-IKyPXBD0FF4VhwwaFs8uwuXsKi2dcpE',
  // 'AIzaSyDojRXuK4jVyDYWGF9JoP6DuHCHcXDkXrQ',
  // 'AIzaSyCt5QmNwLkT0knCr-2yx8osUIeOclKPh5o'
]);

// geminiB
final geminiB = GeminiAuto([

  // irene - 3
  // 'AIzaSyD2Ulo3CWb8Krxalyf2lGD9kKdFgb0JEyM', //1
  // 'AIzaSyDd1z8M_Y78DcphFtjPGQpUCOIB45Sotzk', //2
  // 'AIzaSyCm7voQL24Ju7lD1Dr8iQsDMzfoC2rchio', //3
  // 'AIzaSyCm7voQL24Ju7lD1Dr8iQsDMzfoC2rchio', //4
  // 'AIzaSyBHa8aV7f988AAX3c4mKsR0Yytagzv6t8Y', //5
  // 'AIzaSyBlTWRtCkJZHp4XEkvouZp6Y2WZhXQstoM', //6
  // 'AIzaSyDDNdrETGyQ0j9gVXLTRw6EGMjiXz1aqVc', //7
  // 'AIzaSyBj7aKV-mi7Qbvzvnm2NdSorknpAjFOXUY', //8
  // 'AIzaSyBDllDLQInR1cnHrIEbRIyZFRIwOR_BKBw', //9
  // 'AIzaSyCZ9etGcMGQjIDoK5F7RbiLdLqxSWvuYNs', //10

  // coach
  'AIzaSyDVIzbHaXoFzfo_dJAySexoZlK848q0ZVY', //1
  'AIzaSyB7Juo6QfE6O4UzqxfOFw_LrbOJOVORRZM', //2
  'AIzaSyA6IYOM1bVcBjP9jlLCCjLbNQfliFzI9BE', //3
  'AIzaSyCJMmyOsOHyF56eC9cXnu7i6HUetlYMF1Y', //4
  'AIzaSyDmERFtAb4yAEBF0vqd0a1gb_B8K5Hhxgc', //5
  'AIzaSyDrWvvCAMaucWbp2scs9hCuWI0aaG0f5AE', //6
  'AIzaSyDwQ7dgdPfQGbEPaWV0sJskhvUQSVUKGPQ', //7
  'AIzaSyCjrlcMzBdvGGAkAMpoHBYa6MrNyCNAwqA', //8
  'AIzaSyCWbOsJIx98c7Fb9wX2bVKqHdheSBivYi4', //9
  'AIzaSyCgJl5QeTTHrqCa3gEgzU_vTXZelSgE3L0', //10

  // 'AIzaSyCNrf1R34xDfxmc6QzqU9J7l2O79lSBUNE',
  // 'AIzaSyCRpqIcc4Wf5Z1gqnSP23W7PT9ykgGE_IQ',
  // 'AIzaSyBcnlABFm99VVqdjd6tRzt5HwuY9sdDwnU',
  // 'AIzaSyDtAQ1HuYYo2DDTKfI-puJBNootAeWzFRI'

  // jay 
  'AIzaSyC9ysvzTh9H6n0nNG7MmiMFfOtCkOZw9tE', //1
  'AIzaSyDjNlbMVvneKxUz3LttxJ9l5BDgJuuHudU', //2
  'AIzaSyCYHwWAyBtPbEtQTixgKn8nG2Ah9tLGSEQ', //3
  'AIzaSyAK_WsOYR4b1YL6me6tmKmmMDV8jS8WW80', //4
  'AIzaSyD7BZO5rZZ4dSsj0m2tu5kJDWDZF3HhkBM', //5

  // jay nthu
  'AIzaSyC5lariCP470Axagl3oPtVouKt_vnt-4C4', //1
  'AIzaSyDfUmA78XsR6P2qW5gu3sMSyelqZcjSNM4', //2
  'AIzaSyCyxiEuCraJB6NW8l2fGuCWZ-g6xjv0Z_w', //3
  'AIzaSyD5S7cPlOFTreMd50JnP6R2HaxLoxjtDQE', //4
  'AIzaSyA3NgcG4nCMZfYBuNE6GzazIB2phOKf0rc', //5
  'AIzaSyCmt1tbnfj_K383yTMcCjvoOx8k5e3MkJM', //6
  'AIzaSyBh_uaAJr1qz3gYlYngiiVQCIkcm4kBCOc', //7
  'AIzaSyCQ6nDNcCNRV7EiABM2j1YaStFuLRKtjkw', //8
  'AIzaSyCPGIwJGsCAUsxYw0KRbHMGd7Onc8ZD4mQ', //9
  'AIzaSyCWMZcbLob2C1uk6gz9Eb8NheMyXu6FQdo', //10

  // vio
  'AIzaSyCDSYfgZ3t8g-QV-9Bzu7DM2-Eo50Y4j9M', //1
  'AIzaSyCLpO8PpIJvquZG5y0jBrWjTpxrNfJacuA', //2
  'AIzaSyB6maQKTB7V3niSpydMjehmiDvDPL6RAtw', //3
  'AIzaSyDs8juq-55LikDVIj9K6GDiEGXk5UXmT5w', //4
  'AIzaSyB5gm1Y3bz6qUzdVzofukA7fl9ZWRPYo_g', //5
  'AIzaSyDCwCm-n4IOcfebzJr-7LObHL4NunnvLRU', //6
  'AIzaSyDqVMOoHEw6IrcjKXC_5rClxX8CRWp817k', //7
  'AIzaSyA8Lfo45uvrhPGJ8457Y1_9hTCnUBhgi-0', //8
  'AIzaSyDP-ckRBMTzvVwLZusq-1b2vCtOVqWwR_M', //9
  'AIzaSyCOPLK_aI6x1-fAqhHOJDy0gtQfW4lPJUQ', //10

]);
