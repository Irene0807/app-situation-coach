import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/setting_notifier.dart';

class PageSetting extends StatelessWidget {
  const PageSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final setting = context.watch<SettingNotifier>();
    final textController = TextEditingController(text: setting.userName);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C0A24),
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(setting.isEditing ? Icons.check : Icons.edit, color: Colors.white),
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
                  decoration: const InputDecoration(
                    labelText: 'Your Name',
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
              onPressed: () => setting.logout(),
              child: const Text('Log Out', style: TextStyle(color: Colors.red)),
            ),
          ),

          const Divider(height: 32),

          // Nationality
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Nationality'),
            trailing: DropdownButton<String>(
              value: setting.nationality,
              onChanged: setting.isEditing ? (val) => setting.nationality = val! : null,
              items: ['Taiwan', 'Korea', 'Japan'].map((nation) {
                return DropdownMenuItem(value: nation, child: Text(nation));
              }).toList(),
            ),
          ),

          // Dark Mode
          SwitchListTile(
            value: setting.darkMode,
            onChanged: setting.isEditing ? (val) => setting.darkMode = val : null,
            title: const Text('Dark Mode'),
            secondary: const Icon(Icons.dark_mode),
          ),

          // Voice
          SwitchListTile(
            value: setting.isVoiceEnabled,
            onChanged: setting.isEditing ? (val) => setting.isVoiceEnabled = val : null,
            title: const Text('Enable Voice'),
            secondary: const Icon(Icons.record_voice_over),
          ),

          // Notification
          SwitchListTile(
            value: setting.isNotificationOn,
            onChanged: setting.isEditing ? (val) => setting.isNotificationOn = val : null,
            title: const Text('Enable Notifications'),
            secondary: const Icon(Icons.notifications_active),
          ),
        ],
      ),
    );
  }
}
