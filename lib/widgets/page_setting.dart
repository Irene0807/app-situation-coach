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

  // 要換成db資料
  String nationality = 'Taiwan';
  bool darkMode = false;
  bool isNotificationOn = true;

  @override
  void initState() {
    super.initState();
    final userNotifier = context.read<UserNotifier>();
    textController = TextEditingController(text: '待db匯入');
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // 這個寫法可能不太好 起碼之後要加上logout時的loading狀態什麼的...
  void logout() async {
    final user = Provider.of<UserNotifier>(context, listen: false);
    await user.logout();
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
                // user.setUser(id: user.userId, name: textController.text);
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
                    AssetImage('assets/images/home_person.png'), // 預設大頭貼
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: textController,
                  maxLength: 20,
                  enabled: isEditing,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(
                    color: isEditing ? Colors.grey : Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    labelStyle: TextStyle(
                      color: isEditing ? Colors.grey : Colors.black,
                    ),
                    counterText: '',
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (val) {
                    if (isEditing) {
                      // user.setUser(id: user.userId, name: val);
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          ListTile(
            leading: const Icon(Icons.account_circle),
            title: Text(
                '待db匯入'), // 'User ID: ${user.userId.isNotEmpty ? user.userId : "Not logged in"}'
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
