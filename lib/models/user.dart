import 'package:app_situational_coach/models/account_data.dart';
import 'package:app_situational_coach/models/journey.dart';

// 待辦 app被關閉時isLogin要設為false 登入時要檢查isLogin

class UserData {
  // signIn時的資料
  final String account; // 去除"gmail.com"的帳號

  // 標記資料
  bool isLogin; // 是否已登入 避免多裝置同時登入
  bool isAccountCreated; // 是否填完create_account的資料

  // create_account時的資料
  AccountData? accountData;

  // setting的資料
  String nationality;
  bool darkMode;
  bool isNotificationOn;

  // journey資料
  List<Journey> journeys;

  UserData({
    // signIn時的資料
    required this.account,
    // 標記資料
    this.isLogin = true,
    this.isAccountCreated = false,
    // create_account時的資料
    this.accountData,
    // setting的資料
    this.nationality = 'Taiwan',
    this.darkMode = false,
    this.isNotificationOn = true,
    // journey資料
    this.journeys = const [],
  });
}
