import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// =====================================================================================
/// FEED SCREEN
/// =====================================================================================

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  bool showFabOptions = false;

  late AnimationController _fabController;
  late Animation<double> _fabAnimation;

  /// =====================================================================================
  /// INIT STATE
  /// =====================================================================================

  @override
  void initState() {
    super.initState();

    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fabAnimation = CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeInOut,
    );
  }

  /// =====================================================================================
  /// DISPOSE
  /// =====================================================================================

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  /// =====================================================================================
  /// REFRESH FEED
  /// =====================================================================================

  Future<void> _refreshFeed() async {
    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    setState(() => isLoading = false);
  }

  /// =====================================================================================
  /// TOGGLE FAB
  /// =====================================================================================

  void _toggleFab() {
    setState(() {
      showFabOptions = !showFabOptions;
    });

    if (showFabOptions) {
      _fabController.forward();
    } else {
      _fabController.reverse();
    }
  }

  /// =====================================================================================
  /// BUILD METHOD
  /// =====================================================================================

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    final name =
        user?.userMetadata?['full_name'] as String? ?? 'Emma Watson';

    final firstName = name.split(' ').first;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF111315) : const Color(0xFFF7F8FC),

      /// =================================================================================
      /// APP BAR
      /// =================================================================================

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF181A1D) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                /// =========================================================================
                /// PROFILE IMAGE
                /// =========================================================================

                Hero(
                  tag: 'child_avatar',
                  child: Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFA8E6CF),
                          Color(0xFFDCEDC1),
                        ],
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(3),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/300',
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                /// =========================================================================
                /// USER NAME
                /// =========================================================================

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      firstName,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                /// =========================================================================
                /// NOTIFICATION BUTTON
                /// =========================================================================

                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color:
                    isDark ? const Color(0xFF24272B) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications_active_rounded,
                      color:
                      isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      /// =================================================================================
      /// BODY
      /// =================================================================================

      body: RefreshIndicator(
        onRefresh: _refreshFeed,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: isLoading
                          ? const FeedShimmer()
                          : Column(
                        children: [
                          /// =========================================================
                          /// STATUS CARD
                          /// =========================================================

                          FadeInUp(
                            child: StatusCard(
                              childName: firstName,
                            ),
                          ),

                          const SizedBox(height: 30),

                          /// =========================================================
                          /// FEED HEADER
                          /// =========================================================

                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Activity Feed',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              Text(
                                'Today',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          /// =========================================================
                          /// NAP CARD
                          /// =========================================================

                          const TimelineTile(
                            icon: Icons.nightlight_round,
                            iconColor: Color(0xFF8E97FD),
                            title: 'Nap Time',
                            time: '12:30 PM',
                            child: NapActivityCard(),
                          ),

                          /// =========================================================
                          /// HYDRATION CARD
                          /// =========================================================

                          const TimelineTile(
                            icon: Icons.water_drop_rounded,
                            iconColor: Color(0xFF6CCFF6),
                            title: 'Hydration',
                            time: '11:15 AM',
                            child: HydrationCard(),
                          ),

                          /// =========================================================
                          /// SNACK CARD
                          /// =========================================================

                          const TimelineTile(
                            icon: Icons.restaurant_rounded,
                            iconColor: Color(0xFFA5D6A7),
                            title: 'Morning Snack',
                            time: '09:45 AM',
                            child: SnackCard(),
                          ),

                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      /// =================================================================================
      /// FLOATING ACTION BUTTON
      /// =================================================================================

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizeTransition(
            sizeFactor: _fabAnimation,
            axisAlignment: -1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FloatingActionButton.small(
                heroTag: 'chat_fab',
                backgroundColor: const Color(0xFFA8E6CF),
                onPressed: () {},
                child: const Icon(Icons.chat_bubble_outline),
              ),
            ),
          ),

          FloatingActionButton(
            heroTag: 'main_fab',
            backgroundColor: const Color(0xFF6FCF97),
            onPressed: _toggleFab,
            child: AnimatedRotation(
              turns: showFabOptions ? 0.125 : 0,
              duration: const Duration(milliseconds: 300),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}

/// =====================================================================================
/// STATUS CARD
/// =====================================================================================

class StatusCard extends StatelessWidget {
  final String childName;

  const StatusCard({
    super.key,
    required this.childName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff92e2fc),
            Color(0xffe0f2fc),
            Colors.white
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'Secure Status: Active',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade900,
                ),
              ),
            ),
          ),

          const SizedBox(height: 22),

          Text(
            '$childName is currently napping',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'Expected wake up in 45 mins',
            style: GoogleFonts.poppins(
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 24),


          Container(
            height: 130,
            width: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.7),
                  blurRadius: 60,
                  spreadRadius: 15,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/napping.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),




        ],
      ),
    );
  }
}

/// =====================================================================================
/// TIMELINE TILE
/// =====================================================================================

class TimelineTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String time;
  final Widget child;

  const TimelineTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.time,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ===========================================================================
          /// LEFT TIMELINE
          /// ===========================================================================

          Column(
            children: [
              Container(
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: Colors.grey.shade300,
                ),
              ),
            ],
          ),

          const SizedBox(width: 18),

          /// ===========================================================================
          /// RIGHT CONTENT
          /// ===========================================================================

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color:
                          isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        time,
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  child,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// =====================================================================================
/// NAP ACTIVITY CARD
/// =====================================================================================

class NapActivityCard extends StatelessWidget {
  const NapActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: cardDecoration(context),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Start',
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '12:30 PM',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.grey.shade300,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'End',
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '-- : --',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            'Fell asleep quickly with white noise.',
            style: GoogleFonts.poppins(
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

/// =====================================================================================
/// HYDRATION CARD
/// =====================================================================================

class HydrationCard extends StatefulWidget {
  const HydrationCard({super.key});

  @override
  State<HydrationCard> createState() => _HydrationCardState();
}

class _HydrationCardState extends State<HydrationCard>
    with SingleTickerProviderStateMixin {
  double progress = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        progress = 0.6;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '300 / 500ml',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation(
                Color(0xFF6CCFF6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
/// =====================================================================================
/// SNACK CARD
/// =====================================================================================

class SnackCard extends StatelessWidget {
  const SnackCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              FoodMiniCard(
                title: 'Oatmeal',
                icon: Icons.breakfast_dining,
              ),
              SizedBox(width: 12),
              FoodMiniCard(
                title: 'Fruit',
                icon: Icons.apple_rounded,
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            'Healthy breakfast snacks were served and enjoyed happily.',
            style: GoogleFonts.poppins(
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

/// =====================================================================================
/// MINI FOOD CARD
/// =====================================================================================

class FoodMiniCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const FoodMiniCard({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            /// =========================================================================
            /// ICON
            /// =========================================================================

            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFB9F6CA),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFF2E7D32),
                size: 28,
              ),
            ),

            const SizedBox(height: 14),

            /// =========================================================================
            /// TITLE
            /// =========================================================================

            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: const Color(0xFF1B5E20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =====================================================================================
/// SHIMMER PLACEHOLDER
/// =====================================================================================

class FeedShimmer extends StatelessWidget {
  const FeedShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        shimmerBox(height: 280),
        const SizedBox(height: 30),
        shimmerBox(height: 120),
        const SizedBox(height: 20),
        shimmerBox(height: 120),
      ],
    );
  }
}

/// =====================================================================================
/// SHIMMER BOX
/// =====================================================================================

Widget shimmerBox({required double height}) {
  return Container(
    height: height,
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(24),
    ),
  );
}

/// =====================================================================================
/// COMMON CARD DECORATION
/// =====================================================================================

BoxDecoration cardDecoration(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return BoxDecoration(
    color: isDark ? const Color(0xFF1B1E22) : Colors.white,
    borderRadius: BorderRadius.circular(26),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
  );
}

/// =====================================================================================
/// FADE IN UP ANIMATION
/// =====================================================================================

class FadeInUp extends StatefulWidget {
  final Widget child;

  const FadeInUp({
    super.key,
    required this.child,
  });

  @override
  State<FadeInUp> createState() => _FadeInUpState();
}

class _FadeInUpState extends State<FadeInUp>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacity;
  late Animation<Offset> offset;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    opacity = Tween<double>(begin: 0, end: 1).animate(controller);

    offset = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacity,
      child: SlideTransition(
        position: offset,
        child: widget.child,
      ),
    );
  }
}