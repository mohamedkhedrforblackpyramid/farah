import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      scaffoldBackgroundColor: const Color(0xFFFFFDF9),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Farah',
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
  bool _heroPrecached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_heroPrecached) {
      _heroPrecached = true;
      precacheImage(const AssetImage('assets/proposal_garden.png'), context);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final wide = size.width > 720;
    final compact = size.width < 380;

    final card = ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: wide ? 18 : 14,
          sigmaY: wide ? 18 : 14,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: wide ? 26 : (compact ? 18 : 22),
            vertical: wide ? 30 : (compact ? 20 : 24),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              width: 1.5,
              color: Colors.white.withValues(alpha: 0.88),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.82),
                const Color(0xFFFFF8FC).withValues(alpha: 0.66),
                Colors.white.withValues(alpha: 0.58),
              ],
              stops: const [0.0, 0.42, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 44,
                offset: const Offset(0, 22),
                spreadRadius: -6,
              ),
              BoxShadow(
                color: const Color(0xFFE91E63).withValues(alpha: 0.13),
                blurRadius: 38,
                offset: const Offset(0, 14),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.55),
                blurRadius: 0,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.favorite_rounded,
                color: const Color(0xFFE91E63),
                size: wide ? 52 : (compact ? 40 : 46),
              ),
              SizedBox(height: compact ? 10 : 14),
              Text(
                'Not surprised you said yes…',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: wide ? 34 : (compact ? 22 : 26),
                  fontWeight: FontWeight.w700,
                  height: 1.28,
                  letterSpacing: wide ? -0.35 : -0.25,
                  color: const Color(0xFF3A2433),
                ),
              ),
              SizedBox(height: compact ? 10 : 14),
              Text(
                'you seem like someone with great taste',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: wide ? 26 : (compact ? 17 : 19.5),
                  fontWeight: FontWeight.w600,
                  height: compact ? 1.42 : 1.4,
                  letterSpacing: 0.25,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFF7D5266),
                ),
              ),
              SizedBox(height: compact ? 16 : 22),
              Directionality(
                textDirection: TextDirection.rtl,
                child: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFFC2185B),
                      Color(0xFFE91E63),
                      Color(0xFFF48FB1),
                      Color(0xFFE91E63),
                    ],
                    stops: [0.0, 0.35, 0.65, 1.0],
                  ).createShader(bounds),
                  child: Text(
                    'بحبك',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.elMessiri(
                      fontSize: wide ? 46 : (compact ? 34 : 40),
                      fontWeight: FontWeight.w700,
                      height: 1.05,
                      letterSpacing: compact ? 3 : 6,
                      color: Colors.white,
                      shadows: const [
                        Shadow(
                          blurRadius: 18,
                          offset: Offset(0, 4),
                          color: Color(0x55E91E63),
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
    );

    final padH = compact ? 14.0 : (wide ? 22.0 : 18.0);

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
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 980),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    padH,
                    wide ? 24 : 8,
                    padH,
                    wide ? 24 : 16,
                  ),
                  child: wide
                      ? LayoutBuilder(
                          builder: (context, constraints) {
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
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            final heroH = (size.height * 0.28)
                                .clamp(176.0, 292.0)
                                .toDouble();
                            return SingleChildScrollView(
                              physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                              clipBehavior: Clip.none,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    height: heroH,
                                    child: _ProposalGardenHero(t: _controller.value),
                                  ),
                                  SizedBox(height: compact ? 14 : 20),
                                  card,
                                  SizedBox(height: compact ? 12 : 20),
                                ],
                              ),
                            );
                          },
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
        final dpr = MediaQuery.devicePixelRatioOf(context);
        const maxDecode = 4096;
        final decodeW = constraints.hasBoundedWidth
            ? (constraints.maxWidth * dpr).round().clamp(1, maxDecode)
            : null;
        final decodeH = constraints.hasBoundedHeight
            ? (constraints.maxHeight * dpr).round().clamp(1, maxDecode)
            : null;

        return RepaintBoundary(
          child: Transform.translate(
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
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(28.8),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          _asset,
                          fit: BoxFit.cover,
                          alignment: const Alignment(0, -0.08),
                          filterQuality: FilterQuality.high,
                          gaplessPlayback: true,
                          isAntiAlias: true,
                          cacheWidth: decodeW,
                          cacheHeight: decodeH,
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
          ),
        );
      },
    );
  }
}

class _LoveBackgroundPainter extends CustomPainter {
  _LoveBackgroundPainter({required this.t});

  final double t;

  static const _ivory = Color(0xFFFFFDF9);
  static const _blush = Color(0xFFFFF5F8);
  static const _roseMist = Color(0xFFF5E6EE);
  static const _deepMauve = Color(0xFFE8D5E0);
  static const _champagne = Color(0xFFE8D4A8);
  static const _roseGold = Color(0xFFD4A5B9);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final w = size.width;
    final h = size.height;

    // Layer 1: Opulent wedding palette — ivory, blush, candlelit rose.
    final base = Paint()
      ..shader = const LinearGradient(
        begin: Alignment(-0.85, -1),
        end: Alignment(0.9, 1.15),
        colors: [
          _ivory,
          Color(0xFFFFF9FB),
          _blush,
          _roseMist,
          Color(0xFFF3E8EF),
        ],
        stops: [0.0, 0.28, 0.55, 0.82, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, base);

    // Layer 2: Soft cathedral spotlight from above.
    final spotlight = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -0.92),
        focal: const Alignment(0, -0.55),
        focalRadius: 0.08,
        radius: 1.05,
        colors: [
          Colors.white.withValues(alpha: 0.58),
          const Color(0xFFFFF8F2).withValues(alpha: 0.22),
          Colors.transparent,
        ],
        stops: const [0.0, 0.35, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, spotlight);

    // Layer 3: Corner warmth (gold / rose vignette).
    _radialCorner(canvas, w, h, Offset.zero, 0.65 * (w + h), [
      _champagne.withValues(alpha: 0.34),
      Colors.transparent,
    ]);
    _radialCorner(canvas, w, h, Offset(w, 0), 0.55 * (w + h), [
      _roseGold.withValues(alpha: 0.22),
      Colors.transparent,
    ]);
    _radialCorner(canvas, w, h, Offset(0, h), 0.5 * (w + h), [
      const Color(0xFFC9A86C).withValues(alpha: 0.14),
      Colors.transparent,
    ]);
    _radialCorner(canvas, w, h, Offset(w, h), 0.55 * (w + h), [
      _deepMauve.withValues(alpha: 0.18),
      Colors.transparent,
    ]);

    // Layer 4: Floating silk bokeh orbs (slow drift).
    final tau = t * math.pi * 2;
    final bokehCenters = <Offset>[
      Offset(w * 0.12 + math.sin(tau * 0.7) * 14, h * 0.18),
      Offset(w * 0.88 + math.cos(tau * 0.55) * 18, h * 0.22),
      Offset(w * 0.42 + math.sin(tau * 0.9 + 1) * 22, h * 0.08),
      Offset(w * 0.72, h * 0.42 + math.cos(tau * 0.65) * 26),
      Offset(w * 0.22, h * 0.62 + math.sin(tau * 0.5) * 20),
      Offset(w * 0.55 + math.cos(tau * 0.4) * 16, h * 0.78),
      Offset(w * 0.92, h * 0.88 + math.sin(tau * 0.85) * 12),
    ];
    final bokehRadii = <double>[110, 95, 130, 85, 100, 115, 75];
    for (var i = 0; i < bokehCenters.length; i++) {
      final r = bokehRadii[i];
      final orb = Paint()
        ..shader = RadialGradient(
          colors: [
            Color.lerp(_champagne, Colors.white, 0.55)!.withValues(alpha: 0.26),
            _roseGold.withValues(alpha: 0.08),
            Colors.transparent,
          ],
          stops: const [0.0, 0.45, 1.0],
        ).createShader(Rect.fromCircle(center: bokehCenters[i], radius: r));
      canvas.drawCircle(bokehCenters[i], r, orb);
    }

    // Layer 5: Subtle horizontal silk bands.
    final bandPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment(0, 0.35 + 0.08 * math.sin(tau)),
        end: Alignment(1, 0.72 + 0.06 * math.cos(tau * 0.8)),
        colors: [
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.14),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, bandPaint);

    // Layer 6: Twinkling crystal sparkles.
    final sparklePaint = Paint();
    for (var i = 0; i < 42; i++) {
      final p = i / 42;
      final sx = w * (0.05 + ((i * 47) % 90) / 100);
      final sy = h * (0.08 + ((i * 73) % 84) / 100);
      final tw = (0.5 + 0.5 * math.sin(tau * 3 + p * 12)).clamp(0.0, 1.0);
      final a = (0.08 + 0.35 * tw) * (0.75 + 0.25 * math.sin(p * 6.28));
      sparklePaint.color = Color.lerp(Colors.white, _champagne, 0.35)!.withValues(alpha: a);
      final sz = 1.2 + (i % 4) * 0.65;
      canvas.drawCircle(Offset(sx, sy), sz, sparklePaint);
      if (tw > 0.72) {
        _drawFourRaySparkle(canvas, Offset(sx, sy), sz * 2.8, sparklePaint.color.withValues(alpha: a * 0.55));
      }
    }

    // Layer 7: Shower of hearts — dense field, varied drift, sway & gentle spin.
    final heartPaint = Paint()..style = PaintingStyle.fill;
    final heartCount = (w * h / 3800).floor().clamp(85, 220);
    for (var i = 0; i < heartCount; i++) {
      final p = i / heartCount;
      final seed = i * 0.813 + w * 0.00017;
      final gx = (math.sin(seed * 12.9898) * 43758.5453 % 1).abs();
      final gy = (math.sin(seed * 78.233 + 2.1) * 23421.123 % 1).abs();
      final baseX = w * (0.03 + gx * 0.94);
      final riseSpeed = 0.22 + (i % 13) * 0.028;
      final phase = p * 5.7 + seed;
      final rise = (t * riseSpeed + phase + gy * 0.45) % 1.0;
      final baseY = h * (1.12 - rise * 1.35);
      final sway = math.sin(tau * (0.55 + (i % 9) * 0.07) + seed * 6.2) * (16 + (i % 7) * 2.5);
      final bob = math.cos(tau * (0.85 + (i % 5) * 0.05) + seed) * (9 + (i % 4));
      final wander = math.sin(tau * 0.35 + i * 0.31) * (w * 0.018);
      final x = baseX + sway + wander;
      final y = baseY + bob;
      final s = 4.2 + (i % 11) * 1.35 + (i % 3) * 0.4;
      final pulse = 0.55 + 0.45 * math.sin(tau * 1.4 + seed * 4);
      final alpha = (0.055 + 0.17 * pulse * (0.75 + 0.25 * math.sin(seed * 10))).clamp(0.045, 0.32);
      final tone = i % 5;
      final baseColor = switch (tone) {
        0 || 4 => const Color(0xFFE91E63),
        1 => _roseGold,
        2 => const Color(0xFFF06292),
        _ => const Color(0xFFE57373),
      };
      heartPaint.color = baseColor.withValues(alpha: alpha);
      final wobble = 0.18 * math.sin(tau * 0.65 + seed * 2.6);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(wobble);
      _drawHeart(canvas, Offset.zero, s, heartPaint);
      canvas.restore();
    }

    // Layer 7b: "Farah" — many elegant names drifting, swaying, and spinning across the canvas.
    final nameCount = (w * h / 4600).floor().clamp(32, 96);
    for (var i = 0; i < nameCount; i++) {
      final seed = i * 1.127 + w * 0.00019 + h * 0.00011;
      final gx = (math.sin(seed * 9.12) * 43758.5453 % 1 + 1) % 1;
      final gy = (math.sin(seed * 5.47 + 1.73) * 23421.123 % 1 + 1) % 1;
      final baseX = w * (0.02 + gx * 0.96);
      final riseSpeed = 0.13 + (i % 15) * 0.019;
      final phase = i * 0.41 + seed * 1.7;
      final rise = (t * riseSpeed + phase + gy * 0.62) % 1.0;
      final baseY = h * (1.1 - rise * 1.42);
      final sway = math.sin(tau * (0.52 + (i % 10) * 0.055) + seed * 4.9) * (24 + (i % 8) * 2.8);
      final lift = math.cos(tau * (0.68 + (i % 6) * 0.045) + seed * 2.4) * (12 + (i % 5));
      final drift = math.cos(tau * 0.26 + i * 0.52) * (w * 0.042);
      final slow = math.sin(tau * 0.18 + seed * 1.1) * (h * 0.025);
      final x = baseX + sway + drift;
      final y = baseY + lift + slow;
      final fs = 11.5 + (i % 15) * 1.45;
      final pulse = 0.42 + 0.58 * math.sin(tau * 1.15 + seed * 6);
      final alpha = (0.08 + 0.24 * pulse).clamp(0.07, 0.42);
      final tone = i % 4;
      final nameColor = switch (tone) {
        0 => const Color(0xFFE91E63),
        1 => const Color(0xFFC48B9C),
        2 => const Color(0xFFAD6B7F),
        _ => const Color(0xFFE573A5),
      };
      final label = TextPainter(
        text: TextSpan(
          text: 'Farah',
          style: GoogleFonts.playfairDisplay(
            fontSize: fs,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            height: 1.0,
            color: nameColor.withValues(alpha: alpha),
            shadows: [
              Shadow(
                blurRadius: 10,
                color: Colors.white.withValues(alpha: alpha * 0.5),
                offset: const Offset(0, 1.2),
              ),
              Shadow(
                blurRadius: 4,
                color: const Color(0xFFE91E63).withValues(alpha: alpha * 0.28),
                offset: Offset.zero,
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
        textScaler: TextScaler.noScaling,
      )..layout();
      final rot = 0.28 * math.sin(tau * 0.5 + seed * 2.2);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rot);
      label.paint(canvas, Offset(-label.width / 2, -label.height / 2));
      canvas.restore();
    }

    // Layer 8: Fine pearl vignette frame (inner glow).
    final frame = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black.withValues(alpha: 0.03),
          Colors.transparent,
          Colors.transparent,
          _deepMauve.withValues(alpha: 0.06),
        ],
        stops: const [0.0, 0.22, 0.78, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, frame);
  }

  void _radialCorner(Canvas canvas, double w, double h, Offset center, double radius, List<Color> colors) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: colors,
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), paint);
  }

  void _drawFourRaySparkle(Canvas canvas, Offset c, double r, Color color) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(c.dx - r, c.dy), Offset(c.dx + r, c.dy), p);
    canvas.drawLine(Offset(c.dx, c.dy - r), Offset(c.dx, c.dy + r), p);
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
