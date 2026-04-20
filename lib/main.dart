import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const FarahApp());
}

class FarahApp extends StatelessWidget {
  const FarahApp({super.key});

  static const _seedPink = Color(0xFFFF2D95); // Barbie pink
  static const _bg = Color(0xFFFFF3F8);

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedPink,
      brightness: Brightness.light,
    ).copyWith(surface: Colors.white, surfaceContainerLowest: Colors.white);

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _bg,
      splashFactory: InkSparkle.splashFactory,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Farah',
      theme: base.copyWith(
        textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).copyWith(
          displayLarge: GoogleFonts.playfairDisplay(
            fontSize: 54,
            fontWeight: FontWeight.w900,
            height: 1.05,
            letterSpacing: -1.2,
          ),
          displayMedium: GoogleFonts.playfairDisplay(
            fontSize: 42,
            fontWeight: FontWeight.w900,
            height: 1.08,
            letterSpacing: -1.0,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: _bg,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        chipTheme: base.chipTheme.copyWith(
          backgroundColor: colorScheme.primary.withValues(alpha: 0.10),
          side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.18)),
          labelStyle: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w800),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: colorScheme.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: colorScheme.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
          ),
        ),
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _scrollController = ScrollController();

  final _heroKey = GlobalKey();
  final _servicesKey = GlobalKey();
  final _workKey = GlobalKey();
  final _contactKey = GlobalKey();

  Future<void> _scrollTo(GlobalKey key) async {
    final ctx = key.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeOutCubic,
      alignment: 0.06,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isWide = w >= 980;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _BarbieBackground()),
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: false,
                toolbarHeight: 78,
                titleSpacing: 18,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: const _FrostedAppBar(),
                title: Row(
                  children: [
                    _LogoMark(),
                    const SizedBox(width: 10),
                    Text(
                      'Farah',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.2,
                          ),
                    ),
                    const Spacer(),
                    if (isWide)
                      _TopNav(
                        onHero: () => _scrollTo(_heroKey),
                        onServices: () => _scrollTo(_servicesKey),
                        onWork: () => _scrollTo(_workKey),
                        onContact: () => _scrollTo(_contactKey),
                      )
                    else
                      _NavMenu(
                        onHero: () => _scrollTo(_heroKey),
                        onServices: () => _scrollTo(_servicesKey),
                        onWork: () => _scrollTo(_workKey),
                        onContact: () => _scrollTo(_contactKey),
                      ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _HeroSection(key: _heroKey),
                    _ServicesSection(key: _servicesKey),
                    _WorkSection(key: _workKey),
                    _ContactSection(key: _contactKey),
                    const _Footer(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: _WhatsAppFab(),
    );
  }
}

class _FrostedAppBar extends StatelessWidget {
  const _FrostedAppBar();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                cs.primary.withValues(alpha: 0.10),
                Colors.white.withValues(alpha: 0.60),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            border: Border(
              bottom: BorderSide(color: cs.primary.withValues(alpha: 0.12)),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cs.primary,
            const Color(0xFFFF7AC7),
            const Color(0xFFFFC4E3),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 20),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  const _GlassPanel({
    required this.child,
    this.radius = 26,
  });

  final Widget child;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.70),
                cs.primary.withValues(alpha: 0.08),
                Colors.white.withValues(alpha: 0.60),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            border: Border.all(color: cs.primary.withValues(alpha: 0.14)),
            boxShadow: [
              BoxShadow(
                color: cs.primary.withValues(alpha: 0.10),
                blurRadius: 32,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF2D95), Color(0xFFFF7AC7), Color(0xFFFFC4E3)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          boxShadow: [
            BoxShadow(
              color: cs.primary.withValues(alpha: 0.28),
              blurRadius: 22,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.2,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarbieBackground extends StatefulWidget {
  const _BarbieBackground();

  @override
  State<_BarbieBackground> createState() => _BarbieBackgroundState();
}

class _BarbieBackgroundState extends State<_BarbieBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 5200))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return CustomPaint(
          painter: _BarbieBackgroundPainter(
            t: _c.value,
            primary: cs.primary,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _BarbieBackgroundPainter extends CustomPainter {
  _BarbieBackgroundPainter({
    required this.t,
    required this.primary,
  });

  final double t;
  final Color primary;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final base = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFFFF3F8),
          const Color(0xFFFFE3F1),
          const Color(0xFFFFF8FC),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    canvas.drawRect(rect, base);

    final blobPaint = Paint()..blendMode = BlendMode.srcOver;
    final blobs = <_Blob>[
      _Blob(
        center: Offset(size.width * 0.18, size.height * 0.16),
        radius: size.shortestSide * 0.46,
        color: const Color(0xFFFF2D95).withValues(alpha: 0.14),
        drift: const Offset(0.06, 0.02),
      ),
      _Blob(
        center: Offset(size.width * 0.86, size.height * 0.32),
        radius: size.shortestSide * 0.52,
        color: const Color(0xFFFF7AC7).withValues(alpha: 0.12),
        drift: const Offset(-0.05, 0.03),
      ),
      _Blob(
        center: Offset(size.width * 0.70, size.height * 0.92),
        radius: size.shortestSide * 0.62,
        color: const Color(0xFFFFC4E3).withValues(alpha: 0.18),
        drift: const Offset(-0.03, -0.06),
      ),
    ];

    for (final b in blobs) {
      final dx = math.sin((t * math.pi * 2) + b.drift.dx * 10) * (size.shortestSide * 0.02);
      final dy = math.cos((t * math.pi * 2) + b.drift.dy * 10) * (size.shortestSide * 0.02);
      blobPaint.shader = RadialGradient(
        colors: [
          b.color,
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: b.center.translate(dx, dy), radius: b.radius));
      canvas.drawCircle(b.center.translate(dx, dy), b.radius, blobPaint);
    }

    final sparklePaint = Paint()..color = Colors.white.withValues(alpha: 0.55);
    final rng = math.Random(7);
    final count = (size.width * size.height / 18000).clamp(70, 190).toInt();
    for (var i = 0; i < count; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final p = rng.nextDouble();
      final tw = (0.25 + 0.75 * math.sin((t * math.pi * 2) + p * 12)).abs();
      final r = 0.7 + rng.nextDouble() * 1.8;
      canvas.drawCircle(Offset(x, y), r * tw, sparklePaint);
      if (i % 22 == 0) {
        _drawStar(canvas, Offset(x, y), 5.5 + rng.nextDouble() * 7, tw);
      }
    }

    final vignette = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.transparent,
          primary.withValues(alpha: 0.08),
        ],
        stops: const [0.65, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, vignette);
  }

  void _drawStar(Canvas canvas, Offset c, double size, double a) {
    final p = Paint()..color = Colors.white.withValues(alpha: 0.22 + 0.22 * a);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: c, width: size * 0.18, height: size),
        Radius.circular(size),
      ),
      p,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: c, width: size, height: size * 0.18),
        Radius.circular(size),
      ),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant _BarbieBackgroundPainter oldDelegate) {
    return oldDelegate.t != t || oldDelegate.primary != primary;
  }
}

class _Blob {
  _Blob({
    required this.center,
    required this.radius,
    required this.color,
    required this.drift,
  });

  final Offset center;
  final double radius;
  final Color color;
  final Offset drift;
}

class _TopNav extends StatelessWidget {
  const _TopNav({
    required this.onHero,
    required this.onServices,
    required this.onWork,
    required this.onContact,
  });

  final VoidCallback onHero;
  final VoidCallback onServices;
  final VoidCallback onWork;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _NavButton(label: 'Home', onTap: onHero),
        _NavButton(label: 'Services', onTap: onServices),
        _NavButton(label: 'Work', onTap: onWork),
        _NavButton(label: 'Contact', onTap: onContact),
        const SizedBox(width: 10),
        FilledButton.icon(
          onPressed: () => _launchWhatsApp(),
          icon: const Icon(Icons.chat_bubble_rounded),
          label: const Text('Book a Call'),
        ),
      ],
    );
  }
}

class _NavMenu extends StatelessWidget {
  const _NavMenu({
    required this.onHero,
    required this.onServices,
    required this.onWork,
    required this.onContact,
  });

  final VoidCallback onHero;
  final VoidCallback onServices;
  final VoidCallback onWork;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (context, controller, _) {
        return IconButton.filledTonal(
          onPressed: () => controller.isOpen ? controller.close() : controller.open(),
          icon: const Icon(Icons.menu_rounded),
          tooltip: 'Menu',
        );
      },
      menuChildren: [
        MenuItemButton(onPressed: onHero, child: const Text('Home')),
        MenuItemButton(onPressed: onServices, child: const Text('Services')),
        MenuItemButton(onPressed: onWork, child: const Text('Work')),
        MenuItemButton(onPressed: onContact, child: const Text('Contact')),
        const Divider(height: 12),
        MenuItemButton(
          onPressed: () => _launchWhatsApp(),
          leadingIcon: const Icon(Icons.chat_bubble_rounded),
          child: const Text('Book a Call'),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
      child: Text(label),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final w = MediaQuery.sizeOf(context).width;
    final isWide = w >= 980;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 28 : 18,
        vertical: isWide ? 30 : 18,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: _GlassPanel(
            radius: 28,
            child: Padding(
              padding: EdgeInsets.all(isWide ? 30 : 18),
              child: isWide
                  ? Row(
                      children: [
                        const Expanded(child: _HeroText()),
                        const SizedBox(width: 18),
                        Expanded(child: _HeroPhotoCard(accent: cs.primary)),
                      ],
                    )
                  : Column(
                      children: [
                        _HeroPhotoCard(accent: cs.primary),
                        const SizedBox(height: 16),
                        const _HeroText(),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  const _HeroText();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final w = MediaQuery.sizeOf(context).width;
    final isWide = w >= 980;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            Chip(label: Text('Marketing')),
            Chip(label: Text('Social Media')),
            Chip(label: Text('Branding')),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'Strategy-led marketing that looks premium—and performs.',
          style: (Theme.of(context).textTheme.displayMedium ??
                  Theme.of(context).textTheme.headlineMedium)
              ?.copyWith(color: cs.onSurface),
        ),
        const SizedBox(height: 10),
        Text(
          'I’m Farah, a marketing specialist helping brands grow through clear positioning, high-performing content, and measurable campaigns.',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.72),
                height: 1.45,
              ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _GradientButton(
              onPressed: () => _launchWhatsApp(),
              icon: Icons.chat_bubble_rounded,
              label: 'Get a Proposal',
            ),
            OutlinedButton.icon(
              onPressed: () => _launchEmail(),
              icon: const Icon(Icons.mail_rounded),
              label: const Text('Email Your Brief'),
            ),
            OutlinedButton.icon(
              onPressed: () => _showLoveGift(context),
              icon: const Icon(Icons.redeem_rounded),
              label: const Text('Gift Box'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _MiniStat(
              title: 'Plan',
              value: 'Clarity',
              icon: Icons.map_rounded,
              tint: cs.primary,
            ),
            _MiniStat(
              title: 'Content',
              value: 'Premium',
              icon: Icons.auto_awesome_rounded,
              tint: cs.secondary,
            ),
            _MiniStat(
              title: 'Ads',
              value: 'Results',
              icon: Icons.trending_up_rounded,
              tint: cs.tertiary,
            ),
          ],
        ),
        if (!isWide) const SizedBox(height: 6),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.tint,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tint.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: tint.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: tint),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroPhotoCard extends StatelessWidget {
  const _HeroPhotoCard({required this.accent});
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isWide = w >= 980;

    return AspectRatio(
      aspectRatio: isWide ? 1.05 : 1.12,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.20),
                    blurRadius: 30,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/photo1.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      accent.withValues(alpha: 0.20),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 14,
            bottom: 14,
            right: 14,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.82),
                  border: Border.all(color: accent.withValues(alpha: 0.14)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [accent, accent.withValues(alpha: 0.55)],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.verified_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Positioning, content, and performance—handled end to end.',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
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

class _ServicesSection extends StatelessWidget {
  const _ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final cols = w >= 1100 ? 3 : (w >= 720 ? 2 : 1);

    final items = <_Service>[
      const _Service(
        icon: Icons.calendar_month_rounded,
        title: 'Content Strategy',
        desc: 'Monthly content plan, hooks, scripts, and captions aligned with your positioning.',
      ),
      const _Service(
        icon: Icons.brush_rounded,
        title: 'Branding',
        desc: 'A cohesive visual direction: colors, typography, and tone that feels consistent everywhere.',
      ),
      const _Service(
        icon: Icons.campaign_rounded,
        title: 'Paid Media',
        desc: 'Campaign setup, A/B testing, and ongoing optimization focused on ROI.',
      ),
      const _Service(
        icon: Icons.insights_rounded,
        title: 'Reporting',
        desc: 'Clean dashboards and insights: what’s working, what to change, and what’s next.',
      ),
      const _Service(
        icon: Icons.support_agent_rounded,
        title: 'Community & Leads',
        desc: 'Messaging frameworks, FAQs, and lead follow-up workflows that keep momentum.',
      ),
      const _Service(
        icon: Icons.auto_graph_rounded,
        title: 'Growth',
        desc: 'Weekly priorities, KPIs, and a growth plan that compounds—without chaos.',
      ),
    ];

    return _SectionShell(
      key: const ValueKey('services'),
      title: 'Services',
      subtitle: 'Flexible packages based on your business stage—built for clarity, consistency, and performance.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final spacing = 14.0;
          final width = constraints.maxWidth;
          final itemWidth = (width - (cols - 1) * spacing) / cols;

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              for (final s in items) SizedBox(width: itemWidth, child: _ServiceCard(s: s)),
            ],
          );
        },
      ),
    );
  }
}

class _WorkSection extends StatelessWidget {
  const _WorkSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isWide = w >= 980;
    final cs = Theme.of(context).colorScheme;

    return _SectionShell(
      key: const ValueKey('work'),
      title: 'Work',
      subtitle: 'A preview of the visual direction and content style. (We can replace these with your case studies.)',
      bottom: Padding(
        padding: const EdgeInsets.only(top: 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: cs.primary.withValues(alpha: 0.12)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 10,
              children: [
                Text(
                  'Ready to start? Send your brand name, links, and this month’s target.',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                FilledButton.icon(
                  onPressed: () => _launchWhatsApp(prefill: 'Hi Farah — I’d like to start. Brand name: ...'),
                  icon: const Icon(Icons.chat_bubble_rounded),
                  label: const Text('WhatsApp'),
                ),
              ],
            ),
          ),
        ),
      ),
      child: isWide
          ? Row(
              children: [
                Expanded(
                  child: _WorkCard(
                    title: 'Visual Direction',
                    desc: 'A clean, premium look designed for scroll-stopping content.',
                    imageAsset: 'assets/photo2.png',
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _WorkCard(
                    title: 'Brand Tone',
                    desc: 'A consistent voice and structure across posts, stories, and ads.',
                    imageAsset: 'assets/photo1.png',
                  ),
                ),
              ],
            )
          : Column(
              children: [
                _WorkCard(
                  title: 'Visual Direction',
                  desc: 'A clean, premium look designed for scroll-stopping content.',
                  imageAsset: 'assets/photo2.png',
                ),
                const SizedBox(height: 14),
                _WorkCard(
                  title: 'Brand Tone',
                  desc: 'A consistent voice and structure across posts, stories, and ads.',
                  imageAsset: 'assets/photo1.png',
                ),
              ],
            ),
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final w = MediaQuery.sizeOf(context).width;
    final isWide = w >= 980;

    return _SectionShell(
      key: const ValueKey('contact'),
      title: 'Contact',
      subtitle: 'Choose what’s easiest for you—I’ll reply quickly.',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: cs.primary.withValues(alpha: 0.12)),
          boxShadow: [
            BoxShadow(
              color: cs.primary.withValues(alpha: 0.10),
              blurRadius: 26,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: isWide
              ? Row(
                  children: const [
                    Expanded(child: _ContactButtons()),
                    SizedBox(width: 14),
                    Expanded(child: _ContactCard()),
                  ],
                )
              : const Column(
                  children: [
                    _ContactCard(),
                    SizedBox(height: 14),
                    _ContactButtons(),
                  ],
                ),
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            cs.primary.withValues(alpha: 0.16),
            cs.secondary.withValues(alpha: 0.08),
            Colors.white.withValues(alpha: 0.92),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        border: Border.all(color: cs.primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick brief',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Send: business type, goals, expected budget, and links. I’ll reply with a clear first-week plan.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.45,
                  color: cs.onSurface.withValues(alpha: 0.74),
                ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: () => _launchEmail(),
            icon: const Icon(Icons.mail_rounded),
            label: const Text('Email'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => _launchWhatsApp(),
            icon: const Icon(Icons.chat_bubble_rounded),
            label: const Text('WhatsApp'),
          ),
        ],
      ),
    );
  }
}

class _ContactButtons extends StatelessWidget {
  const _ContactButtons();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final cols = w >= 1100 ? 2 : 1;

    final items = <_ContactAction>[
      _ContactAction(
        icon: Icons.chat_bubble_rounded,
        title: 'WhatsApp',
        subtitle: 'Fastest way to book and follow up',
        onTap: () => _launchWhatsApp(),
      ),
      _ContactAction(
        icon: Icons.mail_rounded,
        title: 'Email',
        subtitle: 'For briefs and files',
        onTap: () => _launchEmail(),
      ),
      _ContactAction(
        icon: Icons.public_rounded,
        title: 'Instagram',
        subtitle: 'Profile & portfolio',
        onTap: () => _launchInstagram(),
      ),
      _ContactAction(
        icon: Icons.call_rounded,
        title: 'Call',
        subtitle: 'For a quick call',
        onTap: () => _launchPhone(),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 12.0;
        final width = constraints.maxWidth;
        final itemWidth = (width - (cols - 1) * spacing) / cols;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final a in items) SizedBox(width: itemWidth, child: _ContactActionCard(a: a)),
          ],
        );
      },
    );
  }
}

class _ContactAction {
  _ContactAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
}

class _ContactActionCard extends StatelessWidget {
  const _ContactActionCard({required this.a});
  final _ContactAction a;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: a.onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: cs.primary.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(a.icon, color: cs.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    a.subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.70),
                        ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_outward_rounded, color: cs.onSurface.withValues(alpha: 0.55)),
          ],
        ),
      ),
    );
  }
}

class _WorkCard extends StatelessWidget {
  const _WorkCard({
    required this.title,
    required this.desc,
    required this.imageAsset,
  });

  final String title;
  final String desc;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: Colors.white,
        border: Border.all(color: cs.primary.withValues(alpha: 0.12)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: Image.asset(imageAsset, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    desc,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.45,
                          color: cs.onSurface.withValues(alpha: 0.72),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Service {
  const _Service({required this.icon, required this.title, required this.desc});
  final IconData icon;
  final String title;
  final String desc;
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.s});
  final _Service s;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cs.primary.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primary, cs.secondary.withValues(alpha: 0.75)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(s.icon, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            s.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            s.desc,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.45,
                  color: cs.onSurface.withValues(alpha: 0.72),
                ),
          ),
        ],
      ),
    );
  }
}

class _SectionShell extends StatelessWidget {
  const _SectionShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.bottom,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final pad = EdgeInsets.symmetric(horizontal: w >= 980 ? 28 : 18, vertical: 18);

    return Padding(
      padding: pad,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.3,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70),
                      height: 1.45,
                    ),
              ),
              const SizedBox(height: 14),
              child,
              if (bottom != null) bottom!,
            ],
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
      child: Center(
        child: Text(
          '© ${DateTime.now().year} Farah — كل الحب والـ conversions.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.62),
              ),
        ),
      ),
    );
  }
}

class _WhatsAppFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _launchWhatsApp(),
      icon: const Icon(Icons.chat_bubble_rounded),
      label: const Text('WhatsApp'),
    );
  }
}

// TODO: Add your real WhatsApp/Instagram/contact details here.
const _whatsAppPhoneE164 = '201000000000'; // Example: 201234567890
const _instagramUrl = 'https://instagram.com/';
const _emailAddress = 'hello@example.com';
const _phoneNumber = '+201000000000';

Future<void> _launchWhatsApp({String? prefill}) async {
  final text = (prefill ?? 'Hi Farah — I’d like to ask about your marketing packages.').trim();
  final uri = Uri.parse(
    'https://wa.me/$_whatsAppPhoneE164?text=${Uri.encodeComponent(text)}',
  );
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

Future<void> _launchInstagram() async {
  final uri = Uri.parse(_instagramUrl);
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

Future<void> _launchEmail() async {
  final uri = Uri(
    scheme: 'mailto',
    path: _emailAddress,
    queryParameters: {
      'subject': 'Marketing Inquiry',
      'body': 'Business name:\nIndustry:\nGoal:\nBudget range:\nLinks:\n',
    },
  );
  await launchUrl(uri);
}

Future<void> _launchPhone() async {
  final uri = Uri(scheme: 'tel', path: _phoneNumber);
  await launchUrl(uri);
}

Future<void> _showLoveGift(BuildContext context) async {
  await showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close',
    barrierColor: Colors.black.withValues(alpha: 0.35),
    transitionDuration: const Duration(milliseconds: 260),
    pageBuilder: (context, _, __) => const _LoveGiftDialog(),
    transitionBuilder: (context, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _LoveGiftDialog extends StatefulWidget {
  const _LoveGiftDialog();

  @override
  State<_LoveGiftDialog> createState() => _LoveGiftDialogState();
}

class _LoveGiftDialogState extends State<_LoveGiftDialog> with TickerProviderStateMixin {
  late final AnimationController _beat;
  late final AnimationController _float;

  @override
  void initState() {
    super.initState();
    _beat = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 760),
    )..repeat(reverse: true);
    _float = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _beat.dispose();
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Stack(
                children: [
                  _GlassPanel(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFF2D95), Color(0xFFFF7AC7), Color(0xFFFFC4E3)],
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Icon(Icons.redeem_rounded, color: Colors.white),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'A little surprise',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -0.2,
                                      ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => Navigator.of(context).maybePop(),
                                icon: const Icon(Icons.close_rounded),
                                tooltip: 'Close',
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          AnimatedBuilder(
                            animation: _beat,
                            builder: (context, _) {
                              final s = 1.0 + (0.08 * _beat.value);
                              return Transform.scale(
                                scale: s,
                                child: Container(
                                  width: 92,
                                  height: 92,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        cs.primary.withValues(alpha: 0.25),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.favorite_rounded, size: 54, color: Color(0xFFFF2D95)),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'بحبك يا فرح',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              height: 1.2,
                              color: cs.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'You deserve all the love.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: cs.onSurface.withValues(alpha: 0.70),
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 16),
                          _GradientButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            icon: Icons.auto_awesome_rounded,
                            label: 'Aww, thanks',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: AnimatedBuilder(
                        animation: _float,
                        builder: (context, _) {
                          return CustomPaint(
                            painter: _HeartsPainter(
                              t: _float.value,
                              primary: cs.primary,
                            ),
                          );
                        },
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
  }
}

class _HeartsPainter extends CustomPainter {
  _HeartsPainter({required this.t, required this.primary});

  final double t;
  final Color primary;

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(12);
    final count = 18;
    for (var i = 0; i < count; i++) {
      final p = i / count;
      final x = (0.12 + 0.76 * rng.nextDouble()) * size.width;
      final drift = math.sin((t * math.pi * 2) + p * 8) * (size.width * 0.02);
      final y = size.height * (0.92 - ((t + p) % 1.0) * 1.05);
      final s = 10 + rng.nextDouble() * 14;
      final a = 0.10 + 0.22 * (1 - ((t + p) % 1.0));
      final c = Color.lerp(const Color(0xFFFF2D95), primary, rng.nextDouble())!.withValues(alpha: a);
      _drawHeart(canvas, Offset(x + drift, y), s, c);
    }
  }

  void _drawHeart(Canvas canvas, Offset center, double size, Color color) {
    final paint = Paint()..color = color;
    final path = Path();
    final s = size;
    final x = center.dx;
    final y = center.dy;
    path.moveTo(x, y + s * 0.30);
    path.cubicTo(x - s * 0.80, y - s * 0.15, x - s * 0.35, y - s * 0.75, x, y - s * 0.35);
    path.cubicTo(x + s * 0.35, y - s * 0.75, x + s * 0.80, y - s * 0.15, x, y + s * 0.30);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HeartsPainter oldDelegate) {
    return oldDelegate.t != t || oldDelegate.primary != primary;
  }
}
