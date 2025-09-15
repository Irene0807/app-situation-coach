import 'package:app_situational_coach/states/journey_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/user_notifier.dart';
import 'package:go_router/go_router.dart';

// Avatar 大頭貼要改（懶得讓使用者改 但可以預設好玩一點的圖片讓他選）
class PageSetting extends StatefulWidget {
  const PageSetting({super.key});

  @override
  State<PageSetting> createState() => _PageSettingState();
}

class _PageSettingState extends State<PageSetting> {
  bool isEditing = false;
  late TextEditingController textController;

  late String account;
  late String nationality;
  late bool darkMode;
  late bool isNotificationOn;

  @override
  void initState() {
    super.initState();
    final userNotifier = context.read<UserNotifier>();
    if (userNotifier.user != null) {
      account = userNotifier.user!.account;
      nationality = userNotifier.user!.nationality;
      darkMode = userNotifier.user!.darkMode;
      isNotificationOn = userNotifier.user!.isNotificationOn;
    }
    textController = TextEditingController(text: account);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // 這個寫法可能不太好 起碼之後要加上logout時的loading狀態什麼的...
  void logout() async {
    Provider.of<JourneyListNotifier>(context, listen: false).reset();
    await Provider.of<UserNotifier>(context, listen: false).logout();
    if (mounted) context.go('/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F4FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5970AF),
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon:
                Icon(isEditing ? Icons.check : Icons.edit, color: Colors.white),
            onPressed: () {
              if (isEditing) {
                Provider.of<UserNotifier>(context, listen: false)
                    .updateSetting(nationality, darkMode, isNotificationOn);
              }
              setState(() {
                isEditing = !isEditing;
              });
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 12),

          // User 個資
          Row(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage:
                    AssetImage('assets/images/journey_start_background.jpg'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: textController,
                  maxLength: 20,
                  // enabled: isEditing,
                  enabled: false,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(
                    // color: isEditing ? Colors.grey : Colors.black,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    labelStyle: TextStyle(
                      // color: isEditing ? Colors.grey : Colors.black,
                      color: Colors.black,
                    ),
                    counterText: '',
                    border: const OutlineInputBorder(),
                  ),
                  // onSubmitted: (val) {
                  //   if (isEditing) {
                  //     // user.setUser(id: user.userId, name: val);
                  //   }
                  // },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          ListTile(
            leading: const Icon(Icons.account_circle),
            title: Text(account),
            subtitle: const Text('Account linked with your profile'),
            trailing: TextButton(
              onPressed: () => logout(),
              child: const Text('Log Out', style: TextStyle(color: Colors.red)),
            ),
          ),

          const Divider(height: 32),

          // Nationality
          ListTile(
            leading: Icon(Icons.language,
                color: isEditing ? Colors.grey : Colors.black),
            title: Text('Nationality',
                style:
                    TextStyle(color: isEditing ? Colors.grey : Colors.black)),
            trailing: DropdownButton<String>(
              value: nationality,
              onChanged: isEditing ? (val) => nationality = val! : null,
              items: ['Taiwan', 'Korea', 'Japan'].map((nation) {
                return DropdownMenuItem(value: nation, child: Text(nation));
              }).toList(),
            ),
          ),

          // Dark Mode
          SwitchListTile(
            value: darkMode,
            onChanged: isEditing ? (val) => darkMode = val : null,
            title: Text('Dark Mode',
                style:
                    TextStyle(color: isEditing ? Colors.grey : Colors.black)),
            secondary: Icon(Icons.dark_mode,
                color: isEditing ? Colors.grey : Colors.black),
          ),

          // Notifications
          SwitchListTile(
            value: isNotificationOn,
            onChanged: isEditing ? (val) => isNotificationOn = val : null,
            title: Text('Enable Notifications',
                style:
                    TextStyle(color: isEditing ? Colors.grey : Colors.black)),
            secondary: Icon(Icons.notifications_active,
                color: isEditing ? Colors.grey : Colors.black),
          ),
        ],
      ),
    );
  }
}
