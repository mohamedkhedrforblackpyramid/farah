import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const ProposalApp());
}

class ProposalApp extends StatelessWidget {
  const ProposalApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFFE91E63);
    final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light);
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFFFF7FB),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Will You Marry Me?',
      theme: base.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(base.textTheme),
      ),
      home: const ProposalPage(),
    );
  }
}

class ProposalPage extends StatefulWidget {
  const ProposalPage({super.key});

  @override
  State<ProposalPage> createState() => _ProposalPageState();
}

class _ProposalPageState extends State<ProposalPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final _random = math.Random();

  bool _accepted = false;
  Offset _noButtonOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _moveNoButton() {
    setState(() {
      final dx = (_random.nextDouble() * 220) - 110;
      final dy = (_random.nextDouble() * 120) - 60;
      _noButtonOffset = Offset(dx, dy);
    });
  }

  Future<void> _sendDecisionToWhatsApp(String decision) async {
    final uri = Uri.parse(
      'https://wa.me/$_whatsAppPhoneE164?text=${Uri.encodeComponent('Proposal answer: $decision')}',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: _LoveBackgroundPainter(t: _controller.value),
                );
              },
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.84),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0xFFE91E63).withValues(alpha: 0.25)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1FE91E63),
                        blurRadius: 30,
                        offset: Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.favorite_rounded, color: Color(0xFFE91E63), size: 56),
                      const SizedBox(height: 12),
                      Text(
                        'My Dearest Farah',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: size.width > 600 ? 46 : 36,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF3A2433),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Every day with you feels like a beautiful dream I never want to wake up from.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: size.width > 600 ? 20 : 17,
                          height: 1.4,
                          color: const Color(0xFF5C4150),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Will You Marry Me?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: size.width > 600 ? 58 : 44,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFE91E63),
                        ),
                      ),
                      const SizedBox(height: 26),
                      if (_accepted)
                        Column(
                          children: [
                            Text(
                              'She said YES! ❤️',
                              style: GoogleFonts.poppins(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFE91E63),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Best day of my life.',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        )
                      else
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    setState(() => _accepted = true);
                                    await _sendDecisionToWhatsApp('YES');
                                  },
                                  icon: const Icon(Icons.favorite),
                                  label: const Text('YES'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE91E63),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Transform.translate(
                                  offset: _noButtonOffset,
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      _moveNoButton();
                                      await _sendDecisionToWhatsApp('NO');
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xFFE91E63),
                                      side: const BorderSide(color: Color(0xFFE91E63), width: 1.6),
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                      textStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    child: const Text('NO'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoveBackgroundPainter extends CustomPainter {
  _LoveBackgroundPainter({required this.t});

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final base = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFFFF5FA),
          Color(0xFFFFE7F2),
          Color(0xFFFFF9FD),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    canvas.drawRect(rect, base);

    final hearts = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < 18; i++) {
      final p = i / 18;
      final x = size.width * (0.1 + ((i * 37) % 80) / 100);
      final y = size.height * (0.95 - ((t + p) % 1.0) * 1.2);
      final sway = math.sin((t * math.pi * 2) + p * 7) * 16;
      final alpha = (0.15 + 0.2 * (1 - ((t + p) % 1.0))).clamp(0.08, 0.32);
      hearts.color = const Color(0xFFE91E63).withValues(alpha: alpha);
      _drawHeart(canvas, Offset(x + sway, y), 8 + (i % 5).toDouble() * 2, hearts);
    }
  }

  void _drawHeart(Canvas canvas, Offset center, double s, Paint paint) {
    final path = Path()
      ..moveTo(center.dx, center.dy + s * 0.30)
      ..cubicTo(
        center.dx - s * 0.85,
        center.dy - s * 0.15,
        center.dx - s * 0.35,
        center.dy - s * 0.80,
        center.dx,
        center.dy - s * 0.35,
      )
      ..cubicTo(
        center.dx + s * 0.35,
        center.dy - s * 0.80,
        center.dx + s * 0.85,
        center.dy - s * 0.15,
        center.dx,
        center.dy + s * 0.30,
      )
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LoveBackgroundPainter oldDelegate) {
    return oldDelegate.t != t;
  }
}

const _whatsAppPhoneE164 = '201068361867';
