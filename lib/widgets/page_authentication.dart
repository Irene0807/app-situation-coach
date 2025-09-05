import 'package:app_situational_coach/services/authentication.dart';
import 'package:app_situational_coach/services/database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../repositories/user_repository.dart';

class PageAuthentication extends StatefulWidget {
  const PageAuthentication({super.key});

  @override
  State<PageAuthentication> createState() => _PageAuthenticationState();
}

class _PageAuthenticationState extends State<PageAuthentication> {
  final _formKey = GlobalKey<FormState>();
  bool _loginSwitch = true;
  bool _loading = false;

  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final repo = Provider.of<UserRepository>(context, listen: false);

    try {
      if (_loginSwitch) {
        await repo.loginWithEmail(
            email: '${_emailCtrl.text}@gmail.com'.trim(),
            password: _passwordCtrl.text);
      } else {
        final age = int.tryParse(_ageCtrl.text.trim()) ?? 0;
        await repo.registerWithEmail(
          email: '${_emailCtrl.text}@gmail.com'.trim(),
          password: _passwordCtrl.text,
          name: _nameCtrl.text.trim(),
          age: age,
        );
      }

      final appUser = repo.getCurrentUserId();
      if (appUser != null) {
        if (mounted) context.go('/home');
      } else {
        return;
      }
    } catch (e) {
      print('發生錯誤：$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_loginSwitch ? '登入' : '註冊'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _loginSwitch = !_loginSwitch;
              });
            },
            child: Text(_loginSwitch ? '切換到註冊' : '切換到登入',
                style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (!_loginSwitch)
                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(labelText: '姓名'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? '請輸入姓名' : null,
                ),
              if (!_loginSwitch)
                TextFormField(
                  controller: _ageCtrl,
                  decoration: InputDecoration(labelText: '年齡'),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return '請輸入年齡';
                    final n = int.tryParse(v.trim());
                    if (n == null || n <= 0) return '請輸入有效年齡';
                    return null;
                  },
                ),
              TextFormField(
                controller: _emailCtrl,
                decoration: InputDecoration(labelText: '帳號'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return '請輸入帳號';
                  if (v.length < 6) return '帳號至少 6 個字元';
                  final reg = RegExp(r'^[a-zA-Z0-9]+$');
                  if (!reg.hasMatch(v)) return '帳號只能包含英文與數字';
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordCtrl,
                decoration: InputDecoration(labelText: '密碼'),
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return '請輸入密碼';
                  if (v.length < 8) return '密碼至少 8 個字元';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: Text(_loginSwitch ? '登入' : '註冊'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
