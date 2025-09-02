import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repositories/user_repository.dart';
import '../models/user.dart';

class PageAuthentication extends StatefulWidget {
  final void Function(User user)? onAuthenticated;

  const PageAuthentication({super.key, this.onAuthenticated});

  @override
  State<PageAuthentication> createState() => _PageAuthenticationState();
}

class _PageAuthenticationState extends State<PageAuthentication> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
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
    // 代處理
    final repo = UserRepository(
      authService: Provider.of(context, listen: false),
      dbService: Provider.of(context, listen: false),
    );

    try {
      if (_isLogin) {
        await repo.loginWithEmail(
            email: _emailCtrl.text.trim(), password: _passwordCtrl.text);
      } else {
        final age = int.tryParse(_ageCtrl.text.trim()) ?? 0;
        await repo.registerWithEmail(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
          name: _nameCtrl.text.trim(),
          age: age,
        );
      }

      final appUser = await repo.getCurrentAppUser();
      final message = _isLogin ? '登入成功' : '註冊成功';
      if (widget.onAuthenticated != null && appUser != null) {
        widget.onAuthenticated!(appUser);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('發生錯誤：$e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? '登入' : '註冊'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _isLogin = !_isLogin;
              });
            },
            child: Text(_isLogin ? '切換到註冊' : '切換到登入',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (!_isLogin)
                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(labelText: '姓名'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? '請輸入姓名' : null,
                ),
              if (!_isLogin)
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
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return '請輸入 email';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim()))
                    return 'email 格式錯誤';
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordCtrl,
                decoration: InputDecoration(labelText: '密碼'),
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return '請輸入密碼';
                  if (v.length < 6) return '密碼至少 6 個字元';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: Text(_isLogin ? '登入' : '註冊'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
