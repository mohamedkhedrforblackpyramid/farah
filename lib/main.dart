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

  static const _yesSweetMessage =
      'After you press Yes, you’re officially allowed to say sweet things to me… no excuses 😌😂';

  Future<void> _showYesSweetPopup() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFE8F0),
                    Color(0xFFFFF5FA),
                    Color(0xFFFFD6E8),
                  ],
                ),
                border: Border.all(color: Colors.white.withValues(alpha: 0.95), width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE91E63).withValues(alpha: 0.28),
                    blurRadius: 28,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('💗', style: TextStyle(fontSize: 28)),
                          const SizedBox(width: 6),
                          Text(
                            'yay!',
                            style: GoogleFonts.fredoka(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFE91E63),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text('💗', style: TextStyle(fontSize: 28)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'She said YES!',
                        style: GoogleFonts.fredoka(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF5C2D45),
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: const Color(0xFFFFB7D5).withValues(alpha: 0.6)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE91E63).withValues(alpha: 0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Text(
                          _yesSweetMessage,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                            fontSize: 17,
                            height: 1.55,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF6B4A5A),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '(rules are rules 💅)',
                        style: GoogleFonts.quicksand(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color: const Color(0xFFB87A9A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: Text(
                                'Later',
                                style: GoogleFonts.quicksand(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: FilledButton(
                              onPressed: () async {
                                Navigator.of(ctx).pop();
                                if (!mounted) return;
                                await _sendDecisionToWhatsApp('YES');
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFE91E63),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                'ماشي 💌',
                                style: GoogleFonts.fredoka(fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showNoWhatsAppPopup() async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Open WhatsApp?'),
          content: const Text('Send your answer on WhatsApp when you tap below.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _sendDecisionToWhatsApp('NO');
              },
              child: const Text('ماشي'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final wide = size.width > 720;

    final card = Container(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFE91E63).withValues(alpha: 0.22)),
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
          const Icon(Icons.favorite_rounded, color: Color(0xFFE91E63), size: 52),
          const SizedBox(height: 10),
          Text(
            'My Dearest Farah',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: wide ? 44 : 34,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF3A2433),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Every day with you feels like a beautiful dream I never want to wake up from.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: wide ? 19 : 16.5,
              height: 1.45,
              color: const Color(0xFF5C4150),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Will You Marry Me?',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: wide ? 52 : 40,
              fontWeight: FontWeight.w900,
              color: const Color(0xFFE91E63),
            ),
          ),
          const SizedBox(height: 24),
          if (_accepted)
            Text(
              'She said YES! ❤️',
              style: GoogleFonts.fredoka(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFE91E63),
              ),
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
                        await _showYesSweetPopup();
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
                          await _showNoWhatsAppPopup();
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
    );

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
              constraints: const BoxConstraints(maxWidth: 980),
              child: Padding(
                padding: EdgeInsets.fromLTRB(18, wide ? 28 : 12, 18, 20),
                child: wide
                    ? LayoutBuilder(
                        builder: (context, constraints) {
                          // IntrinsicHeight + Row + Expanded breaks layout (often empty on web).
                          final heroHeight = math.min(
                            540.0,
                            math.max(300.0, constraints.maxHeight - 48),
                          );
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 52,
                                child: SizedBox(
                                  height: heroHeight,
                                  child: _ProposalGardenHero(t: _controller.value),
                                ),
                              ),
                              const SizedBox(width: 22),
                              Expanded(
                                flex: 48,
                                child: Center(child: card),
                              ),
                            ],
                          );
                        },
                      )
                    : SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: math.min(360.0, size.height * 0.38).clamp(220.0, 400.0).toDouble(),
                              child: _ProposalGardenHero(t: _controller.value),
                            ),
                            const SizedBox(height: 18),
                            card,
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

/// Romantic hero frame: golden-hour gradient border, soft vignette, gentle parallax glow.
class _ProposalGardenHero extends StatelessWidget {
  const _ProposalGardenHero({required this.t});

  final double t;

  static const _asset = 'assets/proposal_garden.png';

  @override
  Widget build(BuildContext context) {
    final breathe = 1.0 + 0.018 * math.sin(t * math.pi * 2);
    final sway = 3.0 * math.sin(t * math.pi * 2 * 0.5);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Transform.translate(
          offset: Offset(sway, 0),
          child: Transform.scale(
            scale: breathe,
            alignment: Alignment.center,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE91E63).withValues(alpha: 0.20 + 0.06 * math.sin(t * math.pi * 2)),
                      blurRadius: 36,
                      offset: const Offset(0, 18),
                      spreadRadius: -2,
                    ),
                    BoxShadow(
                      color: const Color(0xFFFFB74D).withValues(alpha: 0.18),
                      blurRadius: 56,
                      spreadRadius: -8,
                    ),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.all(3.2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFFFE082),
                        const Color(0xFFE91E63).withValues(alpha: 0.95),
                        const Color(0xFFFFCC80),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28.8),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          _asset,
                          fit: BoxFit.cover,
                          alignment: const Alignment(0, -0.08),
                          filterQuality: FilterQuality.high,
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment.center,
                              radius: 1.25,
                              colors: [
                                Colors.transparent,
                                const Color(0xFF3E2723).withValues(alpha: 0.08),
                              ],
                              stops: const [0.55, 1.0],
                            ),
                          ),
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                const Color(0xFFFFFDE7).withValues(alpha: 0.12),
                                Colors.transparent,
                                const Color(0xFFFFF7FB).withValues(alpha: 0.92),
                              ],
                              stops: const [0.0, 0.42, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        );
      },
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
