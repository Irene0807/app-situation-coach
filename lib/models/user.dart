
// 待辦 app被關閉時isLogin要設為false 登入時要檢查isLogin

class UserData {
  // signIn時的資料
  final String account; // 去除"gmail.com"的帳號

  // 標記資料
  bool isAccountCreated; // 是否填完create_account的資料

  // setting的資料
  String nationality;
  bool darkMode;
  bool isNotificationOn;

  UserData({
    // signIn時的資料
    required this.account,
    // 標記資料
    this.isAccountCreated = false,
    // setting的資料
    this.nationality = 'Taiwan',
    this.darkMode = false,
    this.isNotificationOn = true,
  });
}