import 'package:app_situational_coach/repositories/user_repository.dart';
import 'package:app_situational_coach/widgets/func_run_with_loading.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../states/setting_notifier.dart';

class PageSetting extends StatelessWidget {
  const PageSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final setting = Provider.of<SettingNotifier>(context, listen: true);
    final textController = TextEditingController(text: setting.userName);

    return Scaffold(
      backgroundColor: const Color(0xFFE6F4FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5970AF),
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(setting.isEditing ? Icons.check : Icons.edit,
                color: Colors.white),
            onPressed: () {
              if (setting.isEditing) {
                setting.userName = textController.text;
              }
              setting.isEditing = !setting.isEditing;
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 12),

          // Avatar & Name
          Row(
            children: [
              GestureDetector(
                onTap: setting.isEditing ? () {} : null,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: setting.avatarPath.isNotEmpty
                      ? AssetImage(setting.avatarPath)
                      : const AssetImage('assets/images/default_avatar.png'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: textController,
                  onChanged: (val) => setting.userName = val,
                  maxLength: 20,
                  enabled: setting.isEditing,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(
                    color: setting.isEditing ? Colors.grey : Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    labelStyle: TextStyle(
                      color: setting.isEditing ? Colors.grey : Colors.black,
                    ),
                    counterText: '',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Login Info
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: Text('Login Type: ${setting.loginType.name}'),
            subtitle: const Text('Account linked with your profile'),
            trailing: TextButton(
              onPressed: () => () {
                setting.logout();
                // 登出
                context.go('/auth');
              },
              child: const Text('Log Out', style: TextStyle(color: Colors.red)),
            ),
          ),

          const Divider(height: 32),

          // Nationality
          ListTile(
            leading: Icon(
              Icons.language,
              color: setting.isEditing ? Colors.grey : Colors.black,
            ),
            title: Text(
              'Nationality',
              style: TextStyle(
                  color: setting.isEditing ? Colors.grey : Colors.black),
            ),
            trailing: DropdownButton<String>(
              value: setting.nationality,
              onChanged: setting.isEditing
                  ? (val) => setting.nationality = val!
                  : null,
              items: ['Taiwan', 'Korea', 'Japan'].map((nation) {
                return DropdownMenuItem(value: nation, child: Text(nation));
              }).toList(),
            ),
          ),

          // Dark Mode
          SwitchListTile(
            value: setting.darkMode,
            onChanged:
                setting.isEditing ? (val) => setting.darkMode = val : null,
            title: Text(
              'Dark Mode',
              style: TextStyle(
                  color: setting.isEditing ? Colors.grey : Colors.black),
            ),
            secondary: Icon(
              Icons.dark_mode,
              color: setting.isEditing ? Colors.grey : Colors.black,
            ),
          ),

          // Voice
          SwitchListTile(
            value: setting.isVoiceEnabled,
            onChanged: setting.isEditing
                ? (val) => setting.isVoiceEnabled = val
                : null,
            title: Text(
              'Enable Voice',
              style: TextStyle(
                  color: setting.isEditing ? Colors.grey : Colors.black),
            ),
            secondary: Icon(
              Icons.record_voice_over,
              color: setting.isEditing ? Colors.grey : Colors.black,
            ),
          ),

          // Notification
          SwitchListTile(
            value: setting.isNotificationOn,
            onChanged: setting.isEditing
                ? (val) => setting.isNotificationOn = val
                : null,
            title: Text(
              'Enable Notifications',
              style: TextStyle(
                  color: setting.isEditing ? Colors.grey : Colors.black),
            ),
            secondary: Icon(
              Icons.notifications_active,
              color: setting.isEditing ? Colors.grey : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
