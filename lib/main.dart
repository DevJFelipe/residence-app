import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/session_manager.dart';
import 'models/auth_models.dart';
import 'screens/admin_shell.dart';
import 'screens/user_shell.dart';
import 'screens/welcome/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const ResidenceApp());
}

class ResidenceApp extends StatelessWidget {
  const ResidenceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Residence',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEC5B13),
        ),
        textTheme: GoogleFonts.publicSansTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF8F6F6),
      ),
      home: const _SessionGate(),
    );
  }
}

class _SessionGate extends StatefulWidget {
  const _SessionGate();

  @override
  State<_SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<_SessionGate> {
  bool _checking = true;
  Widget? _target;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final session = SessionManager();
    final user = await session.getUser();

    Widget target;
    if (user != null && await session.getToken() != null) {
      final login = LoginResponse.fromJson(user);
      target = login.isAdmin ? const AdminShell() : const UserShell();
    } else {
      target = const WelcomeScreen();
    }

    if (!mounted) return;
    setState(() {
      _target = target;
      _checking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFEC5B13)),
        ),
      );
    }
    return _target!;
  }
}
