import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:mood_tracker/home/home_screen.dart';
import 'package:mood_tracker/home/write_screen.dart';
import 'package:mood_tracker/home/search_screen.dart';
import 'package:mood_tracker/repo/authentification_repository.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen>
    with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ));
  late final AnimationController _logoanimationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 3000,
      ));

  @override
  void initState() {
    super.initState();
    _logoanimationController.forward();
  }

  @override
  void dispose() {
    _logoanimationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onUploadComplete() {
    setState(() {
      _selectedIndex = 1; // Update _selectedIndex to 1 after upload
    });
  }

  void _onLogoutTap(BuildContext context) {
    _animationController.forward();
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text(
                "Log Out?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: () {
                    _animationController.reverse();
                    Navigator.of(context).pop();
                  },
                  child: const Text("No"),
                ),
                CupertinoDialogAction(
                  onPressed: () {
                    ref.read(authRepo).signOut();
                    context.go("/");
                  },
                  isDefaultAction: true,
                  child: const Text("Yes"),
                )
              ],
            ));
  }

  int _selectedIndex = 0;
  static final List<Color?> _colors = [
    Colors.blueAccent[100],
    Colors.lightGreen[100],
    Colors.purple[100],
  ];

  static final List<Color> _logocolors = [
    Colors.blueAccent.withOpacity(0.1),
    Colors.lightGreen.withOpacity(0.1),
    Colors.purple.withOpacity(0.1),
  ];

  static const List<String> _tabs = [
    "/",
    "/search",
    "/write",
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    context.go(_tabs[index]);
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(authRepo);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                  color: _colors[_selectedIndex],
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]),
              child: Text(
                (repo.user?.displayName == null) ? "" : repo.user!.displayName!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
        leading: GestureDetector(
          onTap: () => _onLogoutTap(context),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: Container(
              decoration: BoxDecoration(boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 4),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ], color: _colors[_selectedIndex], shape: BoxShape.circle),
              child: Lottie.asset("assets/logout.json",
                  repeat: false, controller: _animationController),
            ),
          ),
        ),
        toolbarHeight: 100,
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            _logoanimationController.reset();
            _logoanimationController.forward();
          },
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
              BoxShadow(
                color: _logocolors[_selectedIndex],
                offset: const Offset(0, 4),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ]),
            child: Lottie.asset(
              "assets/logo.json",
              controller: _logoanimationController,
              repeat: false,
              height: 90,
              width: 90,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Offstage(offstage: _selectedIndex != 0, child: const HomeScreen()),
          Offstage(offstage: _selectedIndex != 1, child: const SearchScreen()),
          Offstage(
              offstage: _selectedIndex != 2,
              child: WriteScreen(onUploadComplete: _onUploadComplete)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onTap,
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: "Home",
            backgroundColor: Colors.blueAccent[100],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.send_rounded),
            label: "Send",
            backgroundColor: Colors.lightGreen[100],
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.local_post_office_rounded),
              label: "Write",
              backgroundColor: Colors.purple[100]),
        ],
      ),
    );
  }
}
