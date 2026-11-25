import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../defrigo_manage_event/models/managed_event.dart';
import '../defrigo_manage_event/pages/manage_event_page.dart';
import 'data/managed_event_adapter.dart';
import 'models/activity.dart';
import '../daniel_detail/widgets/detail_community_chat.dart';
import '../paulus_feed/feed_page.dart';
import 'widgets/activity_location_filter.dart';
import 'widgets/activity_time_filter.dart';
import 'widgets/featured_section.dart';
import 'widgets/home_bottom_navigation.dart';
import 'widgets/home_header.dart';
import 'widgets/home_promo_card.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/popular_clubs_section.dart';
import 'widgets/sport_shortcut_section.dart';
import '../joan_profile/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.userName = 'Teman'});

  final String userName;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _homeScroll = ScrollController();
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _activitiesKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  int _selectedTab = 0;
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  ActivityTimeGroup? _selectedTime;
  String? _selectedLocation;
  double _radiusKm = 20;
  List<ManagedEvent> _managedEvents = const [];

  @override
  void dispose() {
    _homeScroll.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: HomeBottomNavigation(
        onDestinationSelected: _onDestinationSelected,
        selectedIndex: _selectedTab,
        onSearchPressed: _showHomeSearch,
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedTab,
          children: [
            SingleChildScrollView(
              key: const PageStorageKey('home'),
              controller: _homeScroll,
              child: Column(
                children: [
                  HomeHeader(
                    userName: widget.userName,
                    onNotificationsTap: _showNotifications,
                  ),
                  HomePromoCard(onDiscoverTap: _showHomeSearch),
                  HomeSearchBar(
                    key: _searchKey,
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    onClear: () {
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  ),
                  SportShortcutSection(
                    selectedCategory: _selectedCategory,
                    onCategorySelected: (category) {
                      setState(() => _selectedCategory = category);
                    },
                  ),
                  ActivityTimeFilter(
                    selectedTime: _selectedTime,
                    onTimeSelected: (time) {
                      setState(() {
                        _selectedTime = time;
                      });
                    },
                  ),
                  ActivityLocationFilter(
                    selectedLocation: _selectedLocation,
                    radiusKm: _radiusKm,
                    onLocationSelected: (location) {
                      setState(() {
                        _selectedLocation = location;
                      });
                    },
                    onRadiusChanged: (radius) {
                      setState(() => _radiusKm = radius);
                    },
                  ),
                  FeaturedSection(
                    key: _activitiesKey,
                    searchQuery: _searchQuery,
                    selectedCategory: _selectedCategory,
                    selectedTime: _selectedTime,
                    selectedLocation: _selectedLocation,
                    radiusKm: _radiusKm,
                    onClearFilters: _clearHomeFilters,
                    additionalActivities: managedEventsToActivities(
                      _managedEvents,
                    ),
                    onCreateActivity: _openManageEvents,
                  ),
                  PopularClubsSection(
                    onSportSelected: _showSportActivities,
                    searchQuery: _searchQuery,
                    selectedCategory: _selectedCategory,
                    selectedLocation: _selectedLocation,
                    radiusKm: _radiusKm,
                    onClearFilters: _clearHomeFilters,
                  ),
                ],
              ),
            ),
            const FeedPage(),
          ],
        ),
      ),
    );
  }

  void _showHomeSearch() {
    setState(() => _selectedTab = 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final target = _searchKey.currentContext;
      if (target != null) {
        Scrollable.ensureVisible(
          target,
          duration: const Duration(milliseconds: 300),
        );
      }
      _searchFocusNode.requestFocus();
    });
  }

  void _onDestinationSelected(int index) {
    if (index == 0 || index == 1) {
      FocusScope.of(context).unfocus();
      setState(() => _selectedTab = index);
      return;
    }

    if (index == 2) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Diskusi komunitas',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                DetailCommunityChatCard(
                  activityTitle: 'Fun Futsal Bareng',
                  clubName: 'Jakarta Futsal Club',
                  currentUserRole: 'Pengunjung',
                  isJoined: false,
                ),
                DetailCommunityChatCard(
                  activityTitle: 'Basket Sore',
                  clubName: 'South Jakarta Hoops',
                  currentUserRole: 'Pengunjung',
                  isJoined: false,
                ),
              ],
            ),
          ),
        ),
      );
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(sheetContext);
                _onDestinationSelected(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.campaign_outlined),
              title: const Text('Feed komunitas'),
              onTap: () {
                Navigator.pop(sheetContext);
                _onDestinationSelected(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline_rounded),
              title: const Text('Profil saya'),
              onTap: () {
                Navigator.pop(sheetContext);
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const JoanProfilePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_calendar_outlined),
              title: const Text('Buat / kelola kegiatan'),
              onTap: () {
                Navigator.pop(sheetContext);
                _openManageEvents();
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Cari kegiatan'),
              onTap: () {
                Navigator.pop(sheetContext);
                _showHomeSearch();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNotifications() {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.notifications_none, size: 40),
              SizedBox(height: 12),
              Text('Belum ada notifikasi'),
            ],
          ),
        ),
      ),
    );
  }

  void _showSportActivities(String category) {
    _clearHomeFilters();
    setState(() => _selectedCategory = category);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final target = _activitiesKey.currentContext;
      if (mounted && target != null) {
        Scrollable.ensureVisible(
          target,
          duration: const Duration(milliseconds: 300),
        );
      }
    });
  }

  void _clearHomeFilters() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
      _selectedCategory = 'Semua';
      _selectedTime = null;
      _selectedLocation = null;
      _radiusKm = 20;
    });
  }

  Future<void> _openManageEvents() {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ManageEventPage(
          initialEvents: _managedEvents,
          onEventsChanged: _onEventsChanged,
        ),
      ),
    );
  }

  void _onEventsChanged(List<ManagedEvent> events) {
    setState(() => _managedEvents = List.unmodifiable(events));
  }
}
