import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/navigation/main_shell.dart';
import 'features/auth/login_screen.dart';

void main() {
  runApp(const ClientFlowApp());
}

class ClientFlowApp extends StatefulWidget {
  const ClientFlowApp({super.key});

  @override
  State<ClientFlowApp> createState() => _ClientFlowAppState();
}

class _ClientFlowAppState extends State<ClientFlowApp> {
  bool _isLoggedIn = false;
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
      _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _onLogin() {
    setState(() => _isLoggedIn = true);
  }

  void _onLogout() {
    setState(() => _isLoggedIn = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClientFlow Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: _isLoggedIn
          ? MainShell(
        onLogout: _onLogout,
        onToggleTheme: _toggleTheme,
        isDark: _themeMode == ThemeMode.dark,
      )
          : LoginScreen(onLogin: _onLogin),
    );
  }
}