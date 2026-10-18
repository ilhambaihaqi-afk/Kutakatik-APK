import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DiamondScreen(),
    );
  }
}

// =============================================================
// KOMPONEN IKON VEKTOR & CLIPPERS
// =============================================================

class FigmaBellIcon extends StatelessWidget {
  final double size;
  final Color color;
  const FigmaBellIcon({super.key, this.size = 24, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _BellPainter(color: color),
    );
  }
}

class _BellPainter extends CustomPainter {
  final Color color;
  _BellPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final ui.Path path = ui.Path();
    path.moveTo(size.width * 0.5, size.height * 0.15);
    path.cubicTo(
      size.width * 0.3, size.height * 0.15,
      size.width * 0.2, size.height * 0.4,
      size.width * 0.2, size.height * 0.65,
    );
    path.lineTo(size.width * 0.1, size.height * 0.75);
    path.lineTo(size.width * 0.9, size.height * 0.75);
    path.lineTo(size.width * 0.8, size.height * 0.65);
    path.cubicTo(
      size.width * 0.8, size.height * 0.4,
      size.width * 0.7, size.height * 0.15,
      size.width * 0.5, size.height * 0.15,
    );
    path.moveTo(size.width * 0.5, size.height * 0.15);
    path.lineTo(size.width * 0.5, size.height * 0.08);

    canvas.drawPath(path, paint);

    final Paint clapperPaint = Paint()..color = color..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width * 0.5, size.height * 0.78), radius: size.width * 0.12),
      0, math.pi, true, clapperPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HeaderWaveClipper extends CustomClipper<ui.Path> {
  @override
  ui.Path getClip(Size size) {
    ui.Path path = ui.Path();
    path.lineTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.35, size.height * 1.0, size.width, size.height * 0.45);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<ui.Path> oldClipper) => false;
}

class TopLeftDarkClipper extends CustomClipper<ui.Path> {
  @override
  ui.Path getClip(Size size) {
    ui.Path path = ui.Path();
    path.lineTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.35, size.height * 0.9, size.width * 0.7, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<ui.Path> oldClipper) => false;
}

class RightSideWaveClipper extends CustomClipper<ui.Path> {
  @override
  ui.Path getClip(Size size) {
    ui.Path path = ui.Path();
    path.moveTo(size.width, size.height * 0.28);
    path.cubicTo(
      size.width * 0.22, size.height * 0.50,
      size.width * 0.35, size.height * 0.72,
      size.width, size.height * 0.92,
    );
    path.lineTo(size.width, size.height * 0.28);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<ui.Path> oldClipper) => false;
}

class LandingWaveClipper extends CustomClipper<ui.Path> {
  @override
  ui.Path getClip(Size size) {
    ui.Path path = ui.Path();
    path.moveTo(0, size.height * 0.38);
    path.cubicTo(
      size.width * 0.75, size.height * 0.42,
      size.width * 0.15, size.height * 0.78,
      size.width, size.height * 0.88,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<ui.Path> oldClipper) => false;
}

Widget buildLogoKutakatik({double fontSize = 36}) {
  final TextStyle logoTextStyle = TextStyle(
    color: Colors.white,
    fontSize: fontSize,
    fontWeight: FontWeight.w900,
    letterSpacing: 0.5,
  );

  Widget buildHandlebar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: fontSize * 0.48,
          height: 3,
          decoration: BoxDecoration(
            color: const Color(0xFF1E88E5),
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
        Container(width: 2, height: 5, color: const Color(0xFF1E88E5)),
      ],
    );
  }

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('Ku', style: logoTextStyle),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildHandlebar(),
              const SizedBox(height: 2),
              Text('t', style: logoTextStyle),
            ],
          ),
          Text('aka', style: logoTextStyle),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildHandlebar(),
              const SizedBox(height: 2),
              Text('t', style: logoTextStyle),
            ],
          ),
          Text('ik', style: logoTextStyle),
        ],
      ),
      const SizedBox(height: 6),
      const Text(
        'Deteksi masalah motor awam dalam satu KLIK',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 10,
          fontStyle: FontStyle.italic,
          letterSpacing: 0.2,
        ),
      ),
    ],
  );
}

// -------------------------------------------------------------
// SLIDE 1: BELAH KETUPAT KECIL
// -------------------------------------------------------------
class DiamondScreen extends StatelessWidget {
  const DiamondScreen({super.key});

  void _nextPage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) => const CircleScreenSmall(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap: () => _nextPage(context),
          child: Hero(
            tag: 'blue_shape',
            child: Transform.rotate(
              angle: 45 * math.pi / 180,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFA4C8E8), Color(0xFF3E6894), Color(0xFF0F233D), Color(0xFF050D18)],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// SLIDE 2: LINGKARAN KECIL
// -------------------------------------------------------------
class CircleScreenSmall extends StatelessWidget {
  const CircleScreenSmall({super.key});

  void _nextPage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) => const CircleScreenLarge(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap: () => _nextPage(context),
          child: Hero(
            tag: 'blue_shape',
            child: Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFA4C8E8), Color(0xFF3E6894), Color(0xFF0F233D), Color(0xFF050D18)],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// SLIDE 3: LINGKARAN BESAR
// -------------------------------------------------------------
class CircleScreenLarge extends StatelessWidget {
  const CircleScreenLarge({super.key});

  void _nextPage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) => const WelcomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap: () => _nextPage(context),
          child: Hero(
            tag: 'blue_shape',
            child: Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFA4C8E8), Color(0xFF3E6894), Color(0xFF0F233D), Color(0xFF050D18)],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// SLIDE 4: SELAMAT DATANG TIK
// -------------------------------------------------------------
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _nextPage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) => const WaveHeaderScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => _nextPage(context),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF7A9BB8), Color(0xFF3A5B78), Color(0xFF0E2238)],
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Selamat Datang',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 10),
                Hero(
                  tag: 'blue_shape',
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [Color(0xFFA4C8E8), Color(0xFF1B385A)]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// SLIDE 5: HEADER WAVE ATAS
// -------------------------------------------------------------
class WaveHeaderScreen extends StatelessWidget {
  const WaveHeaderScreen({super.key});

  void _nextPage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) => const SideWaveScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => _nextPage(context),
        child: Stack(
          children: [
            ClipPath(
              clipper: HeaderWaveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.45,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF7A9BB8), Color(0xFF2C4A6F), Color(0xFF0F233D)],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// SLIDE 6: SIDE WAVE
// -------------------------------------------------------------
class SideWaveScreen extends StatelessWidget {
  const SideWaveScreen({super.key});

  void _nextPage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) => const KutakatikLandingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => _nextPage(context),
        child: Stack(
          children: [
            ClipPath(
              clipper: TopLeftDarkClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0E1A29), Color(0xFF050D18)],
                  ),
                ),
              ),
            ),
            ClipPath(
              clipper: RightSideWaveClipper(),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xFF8BAECF), Color(0xFF38587A), Color(0xFF13283E)],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// SLIDE 7: LANDING SCREEN KUTAKATIK
// -------------------------------------------------------------
class KutakatikLandingScreen extends StatelessWidget {
  const KutakatikLandingScreen({super.key});

  void _nextPage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF90B2D2), Color(0xFF4C6E90), Color(0xFF192C42)],
              ),
            ),
          ),
          ClipPath(
            clipper: LandingWaveClipper(),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF132335), Color(0xFF09121C)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 5),
                    buildLogoKutakatik(fontSize: 42),
                    const Spacer(flex: 5),
                    GestureDetector(
                      onTap: () => _nextPage(context),
                      child: Container(
                        width: 210,
                        height: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(21),
                          border: Border.all(color: const Color(0x4BFFFFFF), width: 1),
                          color: const Color(0xA0162738),
                        ),
                        child: const Center(
                          child: Text(
                            'Selamat Datang',
                            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.3),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// SLIDE 8: LOGIN SCREEN
// -------------------------------------------------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _goToHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
      ),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFA1C4E4), Color(0xFF53789E), Color(0xFF1B324D), Color(0xFF0E1A29)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              children: [
                const SizedBox(height: 50),
                buildLogoKutakatik(fontSize: 36),
                const SizedBox(height: 35),
                const Text(
                  'Selamat Datang\nKembali',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600, height: 1.3),
                ),
                const SizedBox(height: 40),
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0x334B688A),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
                  ),
                  child: TextField(
                    controller: _idController,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'ID          :',
                      hintStyle: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0x334B688A),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'PASSWORD :',
                      hintStyle: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.white70, size: 19),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 600),
                            pageBuilder: (context, animation, secondaryAnimation) => const RegisterScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
                          ),
                        );
                      },
                      child: const Text('REGIST ?', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                GestureDetector(
                  onTap: () => _goToHome(context),
                  child: Container(
                    width: 125,
                    height: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(color: const Color(0x59FFFFFF), width: 1),
                      color: const Color(0x66294363),
                    ),
                    child: const Center(
                      child: Text('MULAI', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// SLIDE 9: REGISTER SCREEN
// -------------------------------------------------------------
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword1 = true;
  bool _obscurePassword2 = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _password1Controller = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();

  void _goToHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
      ),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _password1Controller.dispose();
    _password2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFA1C4E4), Color(0xFF53789E), Color(0xFF1B324D), Color(0xFF0E1A29)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_downward_rounded, color: Colors.white, size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 10),
                buildLogoKutakatik(fontSize: 36),
                const SizedBox(height: 30),
                const Text(
                  'BUAT\nAKUN PERTAMA MU !',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700, height: 1.3, letterSpacing: 0.5),
                ),
                const SizedBox(height: 35),
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0x334B688A),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
                  ),
                  child: TextField(
                    controller: _usernameController,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Username :',
                      hintStyle: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0x334B688A),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
                  ),
                  child: TextField(
                    controller: _password1Controller,
                    obscureText: _obscurePassword1,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Password :',
                      hintStyle: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword1 ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.white70, size: 19),
                        onPressed: () => setState(() => _obscurePassword1 = !_obscurePassword1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0x334B688A),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
                  ),
                  child: TextField(
                    controller: _password2Controller,
                    obscureText: _obscurePassword2,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Konfirmasi Password :',
                      hintStyle: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword2 ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.white70, size: 19),
                        onPressed: () => setState(() => _obscurePassword2 = !_obscurePassword2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () => _goToHome(context),
                  child: Container(
                    width: 125,
                    height: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(color: const Color(0x59FFFFFF), width: 1),
                      color: const Color(0x66294363),
                    ),
                    child: const Center(
                      child: Text('MULAI', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// SLIDE 10: HOME SCREEN / DASHBOARD UTAMA
// -------------------------------------------------------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final String _motorImageUrl = 'https://i.ibb.co.com/N27NyspG/Save-Clip-App-566151794-18300678439268089-8088480460540424159-n.jpg';
  final String _cvtImageUrl = 'https://i.ibb.co.com/60qqLNSf/Save-Clip-App-567552174-18300678466268089-5744902995844593677-n.jpg';
  final String _listrikImageUrl = 'https://i.ibb.co.com/fzFnw7sD/Save-Clip-App-569398449-18300678334268089-1166997920832915489-n.jpg';
  final String _rodaImageUrl = 'https://i.ibb.co.com/vCtJJP2R/Save-Clip-App-569268939-18300678493268089-6253589217219705468-n.jpg';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTutorialDialog();
    });
  }

  void _showTutorialDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF13283E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Colors.white30, width: 1),
          ),
          title: const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.amber, size: 22),
              SizedBox(width: 8),
              Text(
                'Panduan Penggunaan',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Selamat datang di Kutakatik! Berikut panduan singkat mengenai apa yang harus Anda lakukan:',
                  style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.4),
                ),
                SizedBox(height: 12),
                _TutorialStep(
                  number: '1',
                  title: 'Pilih Masalah Motor',
                  description: 'Di halaman Utama, klik gambar CVT, Listrik, atau Roda untuk mendiagnosa masalah kendaraan Anda.',
                ),
                SizedBox(height: 10),
                _TutorialStep(
                  number: '2',
                  title: 'Cek Pengingat Oli',
                  description: 'Klik ikon Kalender di menu bawah untuk mengatur dan memantau jadwal ganti oli kendaraan.',
                ),
                SizedBox(height: 10),
                _TutorialStep(
                  number: '3',
                  title: 'Minta Bantuan / Call GIS',
                  description: 'Klik ikon Bintang di menu bawah untuk mengaktifkan GIS Maps, melihat teman di sekitar, dan mengirim pesan darurat.',
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF38587A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Saya Mengerti', style: TextStyle(color: Colors.white, fontSize: 11)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImage(String url, {double width = double.infinity, double height = double.infinity, BoxFit fit = BoxFit.cover}) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFF2C3E50),
          child: const Center(
            child: Icon(Icons.image_not_supported_outlined, color: Colors.white54, size: 28),
          ),
        );
      },
    );
  }

  Widget _buildCategoryItem(String label, String imageUrl, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 90,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: _buildImage(imageUrl),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _onNavTapped(int index) {
    if (index == 1) {
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) => const OilCalendarScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
        ),
      );
    } else if (index == 2) {
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) => const ConnectedScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
        ),
      );
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFA6CBE8), Color(0xFF53789E), Color(0xFF182D46), Color(0xFF0D1826)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('HELLO', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 1.0)),
                              SizedBox(height: 2),
                              Text('ILHAM', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 0.8)),
                            ],
                          ),
                          GestureDetector(
                            onTap: _showTutorialDialog,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white12,
                              ),
                              child: const Icon(Icons.help_outline_rounded, color: Colors.white, size: 22),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0x334B688A),
                          borderRadius: BorderRadius.circular(21),
                          border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
                        ),
                        child: const TextField(
                          style: TextStyle(color: Colors.white, fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Cari...',
                            hintStyle: TextStyle(color: Colors.white70, fontSize: 12),
                            prefixIcon: Icon(Icons.search, color: Colors.white70, size: 20),
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color(0x3D355273),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('HONDA VARIO\nLED OLD', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800, height: 1.25)),
                                  const SizedBox(height: 10),
                                  const Text(
                                    '• Mesin 125cc PGM-FI eSP\n• Tahun : 2015-2018\n• Transmisi : Otomatis, V-Matic\n• Sistem Bahan Bakar Injeksi (PGM-FI)',
                                    style: TextStyle(color: Colors.white70, fontSize: 9.0, height: 1.4),
                                  ),
                                  const SizedBox(height: 14),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(0x66FFFFFF), width: 1),
                                      color: const Color(0x401E3550),
                                    ),
                                    child: const Text('UBAH', style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 4,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox(height: 115, child: _buildImage(_motorImageUrl)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0x66FFFFFF), width: 1),
                            color: const Color(0x551E3857),
                          ),
                          child: const Text('APA MASALAH MU ?', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCategoryItem(
                            'cvt',
                            _cvtImageUrl,
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 600),
                                  pageBuilder: (context, animation, secondaryAnimation) => const CvtDetailScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
                                ),
                              );
                            },
                          ),
                          _buildCategoryItem(
                            'listrik',
                            _listrikImageUrl,
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 600),
                                  pageBuilder: (context, animation, secondaryAnimation) => const ListrikDetailScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
                                ),
                              );
                            },
                          ),
                          _buildCategoryItem(
                            'roda',
                            _rodaImageUrl,
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 600),
                                  pageBuilder: (context, animation, secondaryAnimation) => const RodaDetailScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Jika Anda menemukan kendala di kendaraan kamu, dan membutuhkan solusi tinggal tekan gambar. Contoh: pilih cvt jika kendaraan kamu sering bergetar atau gredek, tekan listrik jika ada kendala di kelistrikan motor.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white60, fontSize: 9.0, height: 1.45),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Container(
                height: 56,
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0x66182C44),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.home_rounded, color: _selectedIndex == 0 ? Colors.white : Colors.white38, size: 22),
                      onPressed: () => _onNavTapped(0),
                    ),
                    IconButton(
                      icon: Icon(Icons.format_list_bulleted_rounded, color: _selectedIndex == 1 ? Colors.white : Colors.white38, size: 22),
                      onPressed: () => _onNavTapped(1),
                    ),
                    IconButton(
                      icon: Icon(Icons.star_border_rounded, color: _selectedIndex == 2 ? Colors.white : Colors.white38, size: 22),
                      onPressed: () => _onNavTapped(2),
                    ),
                    IconButton(
                      icon: Icon(Icons.person_outline_rounded, color: _selectedIndex == 3 ? Colors.white : Colors.white38, size: 22),
                      onPressed: () => _onNavTapped(3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TutorialStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _TutorialStep({required this.number, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF38587A)),
          child: Center(
            child: Text(number, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(description, style: const TextStyle(color: Colors.white60, fontSize: 9.5, height: 1.35)),
            ],
          ),
        ),
      ],
    );
  }
}

// -------------------------------------------------------------
// SLIDE 11: CVT DETAIL SCREEN
// -------------------------------------------------------------
class CvtDetailScreen extends StatefulWidget {
  const CvtDetailScreen({super.key});

  @override
  State<CvtDetailScreen> createState() => _CvtDetailScreenState();
}

class _CvtDetailScreenState extends State<CvtDetailScreen> {
  int _selectedIndex = 0;

  final String _cvtImageUrl = 'https://i.ibb.co.com/60qqLNSf/Save-Clip-App-567552174-18300678466268089-5744902995844593677-n.jpg';

  Widget _buildImage(String url, {double width = double.infinity, double height = double.infinity, BoxFit fit = BoxFit.cover}) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFF2C3E50),
          child: const Center(
            child: Icon(Icons.image_not_supported_outlined, color: Colors.white54, size: 28),
          ),
        );
      },
    );
  }

  Widget _buildProblemButton(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0x334B688A),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600, height: 1.3),
        ),
      ),
    );
  }

  void _onNavTapped(int index) {
    if (index == 0) {
      Navigator.pop(context);
    } else if (index == 1) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) => const OilCalendarScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
        ),
      );
    } else if (index == 2) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) => const ConnectedScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
        ),
      );
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFA6CBE8), Color(0xFF53789E), Color(0xFF182D46), Color(0xFF0D1826)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Text('CVT', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: 1.0)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(19),
                          child: _buildImage(_cvtImageUrl, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'CVT adalah sistem transmisi otomatis yang digunakan pada motor matic yang berfungsi untuk merubah perbandingan putaran mesin ke roda belakang secara otomatis tanpa perlu memindahkan gigi manual.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 10, height: 1.45),
                      ),
                      const SizedBox(height: 28),
                      const Text('Cari tau masalah mu.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                      const SizedBox(height: 18),
                      _buildProblemButton('Motor Bergetar Saat Tarikan Awal'),
                      _buildProblemButton('Tarikan Motor Lemot dan Mesin Menggerung'),
                      _buildProblemButton('Muncul Suara Kasar'),
                      const SizedBox(height: 18),
                      const Text(
                        'Apakah motor Anda saat ini sedang mengalami salah satu dari ketiga gejala di atas?',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white60, fontSize: 9.5, height: 1.4),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Container(
                height: 56,
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0x66182C44),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.home_rounded, color: _selectedIndex == 0 ? Colors.white : Colors.white38, size: 22),
                      onPressed: () => _onNavTapped(0),
                    ),
                    IconButton(
                      icon: Icon(Icons.format_list_bulleted_rounded, color: _selectedIndex == 1 ? Colors.white : Colors.white38, size: 22),
                      onPressed: () => _onNavTapped(1),
                    ),
                    IconButton(
                      icon: Icon(Icons.star_border_rounded, color: _selectedIndex == 2 ? Colors.white : Colors.white38, size: 22),
                      onPressed: () => _onNavTapped(2),
                    ),
                    IconButton(
                      icon: Icon(Icons.person_outline_rounded, color: _selectedIndex == 3 ? Colors.white : Colors.white38, size: 22),
                      onPressed: () => _onNavTapped(3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// SLIDE 12: LISTRIK DETAIL SCREEN
// -------------------------------------------------------------
class ListrikDetailScreen extends StatefulWidget {
  const ListrikDetailScreen({super.key});

  @override
  State<ListrikDetailScreen> createState() => _ListrikDetailScreenState();
}

class _ListrikDetailScreenState extends State<ListrikDetailScreen> {
  int _selectedIndex = 0;

  final String _listrikImageUrl =
      'https://i.ibb.co.com/fzFnw7sD/Save-Clip-App-569398449-18300678334268089-1166997920832915489-n.jpg';

  Widget _buildImage(String url, {double width = double.infinity, double height = double.infinity, BoxFit fit = BoxFit.cover}) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFF2C3E50),
          child: const Center(
            child: Icon(Icons.image_not_supported_outlined, color: Colors.white54, size: 28),
          ),
        );
      },
    );
  }

  Widget _buildProblemButton(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0x334B688A),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600, height: 1.3),
        ),
      ),
    );
  }

  void _onNavTapped(int index) {
    if (index == 0) {
      Navigator.pop(context);
    } else if (index == 1) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) => const OilCalendarScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
        ),
      );
    } else if (index == 2) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) => const ConnectedScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
        ),
      );
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFA6CBE8), Color(0xFF53789E), Color(0xFF182D46), Color(0xFF0D1826)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Text('LISTRIK', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: 1.0)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(19),
                          child: _buildImage(_listrikImageUrl, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Sistem kelistrikan pada motor matic berperan penting dalam penyediaan listrik untuk menyalakan mesin, lampu, kelistrikan pengapian, hingga instrumen indikator.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 10, height: 1.45),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Tiga Komponen Utama Kelistrikan\n(The Big Three)',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.5, height: 1.3),
                      ),
                      const SizedBox(height: 18),
                      _buildProblemButton('Aki (Battery)'),
                      _buildProblemButton('Spul (Stator Comp)'),
                      _buildProblemButton('Kiprok (Regulator / Rectifier)'),
                      const SizedBox(height: 18),
                      const Text(
                        'Apakah motor Anda saat ini sedang mengalami salah satu dari ketiga gejala di atas?',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white60, fontSize: 9.5, height: 1.4),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Container(
                height: 56,
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0x66182C44),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.home_rounded, color: _selectedIndex == 0 ? Colors.white : Colors.white38, size: 22),
                      onPressed: () => _onNavTapped(0),
                    ),
                    IconButton(
                      icon: Icon(Icons.format_list_bulleted_rounded, color: _selectedIndex == 1 ? Colors.white : Colors.white38, size: 22),
                      onPressed: () => _onNavTapped(1),
                    ),
                    IconButton(
                      icon: Icon(Icons.star_border_rounded, color: _selectedIndex == 2 ? Colors.white : Colors.white38, size: 22),
                      onPressed: () => _onNavTapped(2),
                    ),
                    IconButton(
                      icon: Icon(Icons.person_outline_rounded, color: _selectedIndex == 3 ? Colors.white : Colors.white38, size: 22),
                      onPressed: () => _onNavTapped(3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// SLIDE 13: RODA DETAIL SCREEN
// -------------------------------------------------------------
class RodaDetailScreen extends StatefulWidget {
  const RodaDetailScreen({super.key});

  @override
  State<RodaDetailScreen> createState() => _RodaDetailScreenState();
}

class _RodaDetailScreenState extends State<RodaDetailScreen> {
  int _selectedIndex = 0;

  final String _rodaImageUrl =
      'https://i.ibb.co.com/vCtJJP2R/Save-Clip-App-569268939-18300678493268089-6253589217219705468-n.jpg';

  Widget _buildImage(String url, {double width = double.infinity, double height = double.infinity, BoxFit fit = BoxFit.cover}) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFF2C3E50),
          child: const Center(
            child: Icon(Icons.image_not_supported_outlined, color: Colors.white54, size: 28),
          ),
        );
      },
    );
  }

  Widget _buildProblemButton(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0x334B688A),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w600, height: 1.3),
        ),
      ),
    );
  }

  void _onNavTapped(int index) {
    if (index == 0) {
      Navigator.pop(context);
    } else if (index == 1) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) => const OilCalendarScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
        ),
      );
    } else if (index == 2) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) => const ConnectedScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
        ),
      );
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFA6CBE8), Color(0xFF53789E), Color(0xFF182D46), Color(0xFF0D1826)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Text('RODA', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: 1.0)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(19),
                          child: _buildImage(_rodaImageUrl, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Sistem roda pada motor matic bukan hanya sekedar karet bulat untuk berjalan, melainkan komponen keselamatan nomor satu yang menopang seluruh bobot kendaraan, pengendara, dan menyalurkan tenaga dari CVT ke aspal.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 10, height: 1.45),
                      ),
                      const SizedBox(height: 28),
                      _buildProblemButton('Masalah: Motor Terasa Goyang /\nOleng (Padahal Ban Tidak Kempes)'),
                      _buildProblemButton('Masalah: Stang Bergetar Hebat dan\nBan Habis Sebelah'),
                      _buildProblemButton('Masalah: Ban Tubeless Sering\nKempes Halus'),
                      const SizedBox(height: 18),
                      const Text(
                        'Apakah motor Anda saat ini sedang mengalami salah satu dari ketiga gejala di atas?',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white60, fontSize: 9.5, height: 1.4),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Container(
                height: 56,
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0x66182C44),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.home_rounded, color: _selectedIndex == 0 ? Colors.white : Colors.white38, size: 22),
                      onPressed: () => _onNavTapped(0),
                    ),
                    IconButton(
                      icon: Icon(Icons.format_list_bulleted_rounded, color: _selectedIndex == 1 ? Colors.white : Colors.white38, size: 22),
                      onPressed: () => _onNavTapped(1),
                    ),
                    IconButton(
                      icon: Icon(Icons.star_border_rounded, color: _selectedIndex == 2 ? Colors.white : Colors.white38, size: 22),
                      onPressed: () => _onNavTapped(2),
                    ),
                    IconButton(
                      icon: Icon(Icons.person_outline_rounded, color: _selectedIndex == 3 ? Colors.white : Colors.white38, size: 22),
                      onPressed: () => _onNavTapped(3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// SLIDE 14: PENGINGAT GANTI OLI + KALENDER SCREEN
// -------------------------------------------------------------
class OilCalendarScreen extends StatefulWidget {
  const OilCalendarScreen({super.key});

  @override
  State<OilCalendarScreen> createState() => _OilCalendarScreenState();
}

class _OilCalendarScreenState extends State<OilCalendarScreen> {
  int _selectedIndex = 1;
  DateTime _selectedDate = DateTime(2026, 10, 16);

  final String _cvtImageUrl = 'https://i.ibb.co.com/60qqLNSf/Save-Clip-App-567552174-18300678466268089-5744902995844593677-n.jpg';
  final String _listrikImageUrl = 'https://i.ibb.co.com/fzFnw7sD/Save-Clip-App-569398449-18300678334268089-1166997920832915489-n.jpg';
  final String _rodaImageUrl = 'https://i.ibb.co.com/vCtJJP2R/Save-Clip-App-569268939-18300678493268089-6253589217219705468-n.jpg';

  Widget _buildImage(String url, {double width = double.infinity, double height = double.infinity, BoxFit fit = BoxFit.cover}) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFF2C3E50),
          child: const Center(
            child: Icon(Icons.image_not_supported_outlined, color: Colors.white54, size: 20),
          ),
        );
      },
    );
  }

  Widget _buildCategoryItem(String label, String imageUrl, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 75,
            height: 65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: _buildImage(imageUrl),
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _onNavTapped(int index) {
    if (index == 0) {
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
        ),
        (route) => false,
      );
    } else if (index == 2) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) => const ConnectedScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
        ),
      );
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFA6CBE8), Color(0xFF53789E), Color(0xFF182D46), Color(0xFF0D1826)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCategoryItem(
                            'cvt',
                            _cvtImageUrl,
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 600),
                                  pageBuilder: (context, animation, secondaryAnimation) => const CvtDetailScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
                                ),
                              );
                            },
                          ),
                          _buildCategoryItem(
                            'listrik',
                            _listrikImageUrl,
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 600),
                                  pageBuilder: (context, animation, secondaryAnimation) => const ListrikDetailScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
                                ),
                              );
                            },
                          ),
                          _buildCategoryItem(
                            'roda',
                            _rodaImageUrl,
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 600),
                                  pageBuilder: (context, animation, secondaryAnimation) => const RodaDetailScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Jika Anda menunda ganti oli terlalu lama, volume oli di dalam mesin bisa tinggal setengahnya. Mesin yang kekurangan oli akan saling bergesekan kasar dan berisiko jebol dengan biaya perbaikan jutaan rupiah.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 9.0, height: 1.4),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3EDF7),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFF0F2B48),
                              onPrimary: Colors.white,
                              surface: Color(0xFFE3EDF7),
                              onSurface: Color(0xFF1E3550),
                            ),
                          ),
                          child: CalendarDatePicker(
                            initialDate: _selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                            onDateChanged: (date) {
                              setState(() {
                                _selectedDate = date;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Container(
                height: 56,
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0x66182C44),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.home_rounded, color: _selectedIndex == 0 ? Colors.white : Colors.white38, size: 22),
                      onPressed: () => _onNavTapped(0),
                    ),
                    IconButton(
                      icon: Icon(Icons.format_list_bulleted_rounded, color: _selectedIndex == 1 ? Colors.white : Colors.white38, size: 22),
                      onPressed: () => _onNavTapped(1),
                    ),
                    IconButton(
                      icon: Icon(Icons.star_border_rounded, color: _selectedIndex == 2 ? Colors.white : Colors.white38, size: 22),
                      onPressed: () => _onNavTapped(2),
                    ),
                    IconButton(
                      icon: Icon(Icons.person_outline_rounded, color: _selectedIndex == 3 ? Colors.white : Colors.white38, size: 22),
                      onPressed: () => _onNavTapped(3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// SLIDE 15: LET'S STAY CONNECTED SCREEN (IKON BINTANG + MAPS GIS)
// -------------------------------------------------------------
class ConnectedScreen extends StatefulWidget {
  const ConnectedScreen({super.key});

  @override
  State<ConnectedScreen> createState() => _ConnectedScreenState();
}

class _ConnectedScreenState extends State<ConnectedScreen> {
  int _selectedIndex = 2;
  bool _isCallActive = false;
  int? _selectedUserIndex;

  final String _cvtImageUrl = 'https://i.ibb.co.com/60qqLNSf/Save-Clip-App-567552174-18300678466268089-5744902995844593677-n.jpg';
  final String _listrikImageUrl = 'https://i.ibb.co.com/fzFnw7sD/Save-Clip-App-569398449-18300678334268089-1166997920832915489-n.jpg';
  final String _rodaImageUrl = 'https://i.ibb.co.com/vCtJJP2R/Save-Clip-App-569268939-18300678493268089-6253589217219705468-n.jpg';

  final LatLng _centerLocation = const LatLng(-6.9337223, 107.7226134);

  final List<Map<String, dynamic>> _nearbyUsers = [
    {'name': 'Joo', 'point': const LatLng(-6.9332223, 107.7216134)},
    {'name': 'Rian', 'point': const LatLng(-6.9347223, 107.7236134)},
    {'name': 'Budi', 'point': const LatLng(-6.9327223, 107.7246134)},
    {'name': 'Siti', 'point': const LatLng(-6.9357223, 107.7216134)},
    {'name': 'Andi', 'point': const LatLng(-6.9317223, 107.7230134)},
  ];

  Widget _buildImage(String url, {double width = double.infinity, double height = double.infinity, BoxFit fit = BoxFit.cover}) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFF2C3E50),
          child: const Center(
            child: Icon(Icons.image_not_supported_outlined, color: Colors.white54, size: 18),
          ),
        );
      },
    );
  }

  Widget _buildCircleButton(String label, {Widget? childWidget, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0x55FFFFFF),
              border: Border.all(color: const Color(0x80FFFFFF), width: 1.2),
            ),
            child: ClipOval(
              child: childWidget ?? Container(),
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildChatItem(String name, String subtext, String time) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (context, animation, secondaryAnimation) => ChatDetailScreen(userName: name),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0x33283858),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0x33FFFFFF), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0x33FFFFFF),
                border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
              ),
              child: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(subtext, style: const TextStyle(color: Colors.white60, fontSize: 10)),
                ],
              ),
            ),
            Text(time, style: const TextStyle(color: Colors.white54, fontSize: 9.5)),
          ],
        ),
      ),
    );
  }

  void _onNavTapped(int index) {
    if (index == 0) {
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
        ),
        (route) => false,
      );
    } else if (index == 1) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) => const OilCalendarScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
        ),
      );
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFA6CBE8), Color(0xFF53789E), Color(0xFF182D46), Color(0xFF0D1826)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0x334B688A),
                          borderRadius: BorderRadius.circular(19),
                          border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
                        ),
                        child: const TextField(
                          style: TextStyle(color: Colors.white, fontSize: 12),
                          decoration: InputDecoration(
                            hintText: 'Cari...',
                            hintStyle: TextStyle(color: Colors.white70, fontSize: 11),
                            prefixIcon: Icon(Icons.search, color: Colors.white70, size: 18),
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        "Let's Stay\nConnected",
                        style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800, height: 1.2),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        height: 220,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0x33FFFFFF), width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(19),
                          child: Stack(
                            children: [
                              Opacity(
                                opacity: 0.65,
                                child: FlutterMap(
                                  options: MapOptions(
                                    initialCenter: _centerLocation,
                                    initialZoom: 15.0,
                                    interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      userAgentPackageName: 'com.example.flutter_application_1',
                                    ),
                                    if (_isCallActive)
                                      MarkerLayer(
                                        markers: List.generate(_nearbyUsers.length, (index) {
                                          final user = _nearbyUsers[index];
                                          final isSelected = _selectedUserIndex == index;

                                          return Marker(
                                            point: user['point'] as LatLng,
                                            width: 36,
                                            height: 36,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _selectedUserIndex = isSelected ? null : index;
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: isSelected ? Colors.blueAccent : Colors.black87,
                                                  border: Border.all(color: Colors.white, width: 1.5),
                                                ),
                                                child: Icon(
                                                  Icons.person,
                                                  size: 18,
                                                  color: isSelected ? Colors.white : Colors.white70,
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                  ],
                                ),
                              ),
                              if (!_isCallActive)
                                Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0x770D1826),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _buildCircleButton(
                                          'Call',
                                          childWidget: const Icon(Icons.phone_outlined, color: Colors.white, size: 24),
                                          onTap: () {
                                            setState(() {
                                              _isCallActive = true;
                                            });
                                          },
                                        ),
                                        const SizedBox(width: 12),
                                        _buildCircleButton(
                                          'cvt',
                                          childWidget: _buildImage(_cvtImageUrl),
                                          onTap: () {
                                            Navigator.of(context).push(
                                              PageRouteBuilder(
                                                transitionDuration: const Duration(milliseconds: 600),
                                                pageBuilder: (context, animation, secondaryAnimation) => const CvtDetailScreen(),
                                                transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 12),
                                        _buildCircleButton(
                                          'listrik',
                                          childWidget: _buildImage(_listrikImageUrl),
                                          onTap: () {
                                            Navigator.of(context).push(
                                              PageRouteBuilder(
                                                transitionDuration: const Duration(milliseconds: 600),
                                                pageBuilder: (context, animation, secondaryAnimation) => const ListrikDetailScreen(),
                                                transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 12),
                                        _buildCircleButton(
                                          'roda',
                                          childWidget: _buildImage(_rodaImageUrl),
                                          onTap: () {
                                            Navigator.of(context).push(
                                              PageRouteBuilder(
                                                transitionDuration: const Duration(milliseconds: 600),
                                                pageBuilder: (context, animation, secondaryAnimation) => const RodaDetailScreen(),
                                                transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                Center(
                                  child: _buildCircleButton(
                                    'Call',
                                    childWidget: const Icon(Icons.phone_outlined, color: Colors.white, size: 24),
                                    onTap: () {
                                      setState(() {
                                        _isCallActive = false;
                                        _selectedUserIndex = null;
                                      });
                                    },
                                  ),
                                ),
                              if (_isCallActive && _selectedUserIndex != null)
                                Positioned(
                                  bottom: 12,
                                  left: 20,
                                  right: 20,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          transitionDuration: const Duration(milliseconds: 600),
                                          pageBuilder: (context, animation, secondaryAnimation) => ChatDetailScreen(userName: _nearbyUsers[_selectedUserIndex!]['name']),
                                          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xEEFFFFFF),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: const [
                                          BoxShadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 3)),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.person_pin, size: 18, color: Colors.blueAccent),
                                              const SizedBox(width: 8),
                                              Text(
                                                _nearbyUsers[_selectedUserIndex!]['name'],
                                                style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const Row(
                                            children: [
                                              Text('Kirim Pesan', style: TextStyle(color: Colors.blueAccent, fontSize: 10, fontWeight: FontWeight.w600)),
                                              SizedBox(width: 4),
                                              Icon(Icons.chat_bubble_outline, size: 14, color: Colors.blueAccent),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildChatItem('Ujang Japran', _isCallActive ? 'Call' : 'Otw', '9:43 AM'),
                      _buildChatItem('Dian', _isCallActive ? 'Call' : 'Message', '9:41 AM'),
                      _buildChatItem('KK AI', _isCallActive ? 'Call' : 'Message', '9:41 AM'),
                      _buildChatItem('Hauzan', _isCallActive ? 'Call' : 'Message', '9:41 AM'),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              Container(
                height: 56,
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0x66182C44),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.home_rounded, color: _selectedIndex == 0 ? Colors.white : Colors.white38, size: 22),
                      onPressed: () => _onNavTapped(0),
                    ),
                    IconButton(
                      icon: Icon(Icons.format_list_bulleted_rounded, color: _selectedIndex == 1 ? Colors.white : Colors.white38, size: 22),
                      onPressed: () => _onNavTapped(1),
                    ),
                    IconButton(
                      icon: Icon(Icons.star_border_rounded, color: _selectedIndex == 2 ? Colors.white : Colors.white38, size: 22),
                      onPressed: () => _onNavTapped(2),
                    ),
                    IconButton(
                      icon: Icon(Icons.person_outline_rounded, color: _selectedIndex == 3 ? Colors.white : Colors.white38, size: 22),
                      onPressed: () => _onNavTapped(3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// SLIDE 16: CHAT DETAIL SCREEN (CHAT KUTAKATIK DENGAN GIS MAPS)
// -------------------------------------------------------------
class ChatDetailScreen extends StatefulWidget {
  final String userName;
  const ChatDetailScreen({super.key, this.userName = 'Ujang Japran'});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final LatLng _bengkelLocation = const LatLng(-6.9337223, 107.7226134);
  final String _mapsUrl =
      'https://www.google.com/maps/search/bengkel+terdekat/@-6.9337223,107.7226134,16z/data=!3m1!4b1!5m1!1e1?entry=ttu&g_ep=EgoyMDI2MTAxMy4wIKXMDSoASAFQAw%3D%3D';

  Future<void> _launchMaps() async {
    final Uri uri = Uri.parse(_mapsUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_mapsUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isUjang = widget.userName.toLowerCase().contains('ujang');

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFA6CBE8), Color(0xFF53789E), Color(0xFF182D46), Color(0xFF0D1826)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu_rounded, color: Colors.white70, size: 24),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Chat Kutakatik',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0x40FFFFFF),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0x66FFFFFF), width: 1),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'BANTUAN EUY MOGOK',
                                style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 4),
                              Text('9:41 AM', style: TextStyle(color: Colors.white70, fontSize: 8)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (isUjang) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0x33FFFFFF),
                                border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
                              ),
                              child: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 16),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0x33283858),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0x33FFFFFF), width: 1),
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'DIMANA ??',
                                    style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 4),
                                  Text('9:42 AM', style: TextStyle(color: Colors.white54, fontSize: 8)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: _launchMaps,
                            child: Container(
                              width: 220,
                              decoration: BoxDecoration(
                                color: const Color(0x33283858),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: SizedBox(
                                        height: 115,
                                        width: double.infinity,
                                        child: FlutterMap(
                                          options: MapOptions(
                                            initialCenter: _bengkelLocation,
                                            initialZoom: 15.0,
                                            interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                                          ),
                                          children: [
                                            TileLayer(
                                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                              userAgentPackageName: 'com.example.flutter_application_1',
                                            ),
                                            MarkerLayer(
                                              markers: [
                                                Marker(
                                                  point: _bengkelLocation,
                                                  width: 30,
                                                  height: 30,
                                                  child: const Icon(Icons.location_on, color: Colors.redAccent, size: 30),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 6.0),
                                    child: Text(
                                      'Temukan Lokasi (Klik)',
                                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 8.0, right: 12.0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text('9:42 AM', style: TextStyle(color: Colors.white54, fontSize: 8)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0x33FFFFFF),
                                border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
                              ),
                              child: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 16),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0x33283858),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0x33FFFFFF), width: 1),
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Otww',
                                    style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 4),
                                  Text('9:43 AM', style: TextStyle(color: Colors.white54, fontSize: 8)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0x334B688A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
                  ),
                  child: const TextField(
                    style: TextStyle(color: Colors.white, fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'Ketik Pesan .....',
                      hintStyle: TextStyle(color: Colors.white70, fontSize: 11),
                      prefixIcon: Icon(Icons.keyboard_outlined, color: Colors.white70, size: 18),
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(
                height: 56,
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 12, top: 4),
                decoration: BoxDecoration(
                  color: const Color(0x66182C44),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.home_rounded, color: Colors.white38, size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.format_list_bulleted_rounded, color: Colors.white38, size: 22),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.star_border_rounded, color: Colors.white, size: 22),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.person_outline_rounded, color: Colors.white38, size: 22),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
