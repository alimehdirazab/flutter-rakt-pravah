import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rakt_pravah/core/ui.dart';
import 'package:rakt_pravah/presentation/pages/home/request_for_blood_screen.dart';
import 'package:rakt_pravah/presentation/pages/home/dashboard_screen.dart';
import 'package:rakt_pravah/presentation/pages/home/donate_screen.dart';
import 'package:rakt_pravah/presentation/pages/other/about_us.dart';
import 'package:rakt_pravah/presentation/pages/other/my_profile_screen.dart';
import 'package:rakt_pravah/presentation/pages/other/privacy_prolicy.dart';
import 'package:rakt_pravah/presentation/pages/other/terms_conditions.dart';
import 'package:rakt_pravah/presentation/widgets/drawer_tile.dart';
import 'package:rakt_pravah/presentation/widgets/gap_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = "homePage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  List<Widget> screens = const [
    DashboardScreen(),
    DonateScreen(),
    RequestForBloodScreen(),
  ];

  // Define the GlobalKey
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use the GlobalKey here
      key: _scaffoldKey,
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bloodtype),
            label: "Donate",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety_outlined),
            label: "Request For Blood",
          ),
        ],
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 240,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(400, 200),
                    bottomRight: Radius.elliptical(400, 150),
                  ),
                ),
                child: Column(
                  children: [
                    const GapWidget(size: 20),
                    SizedBox(
                      width: 200,
                      height: 150,
                      child: Image.asset('assets/images/rakt_pravah_logo.png'),
                    ),
                    Text('Noble To Save Life', style: TextStyles.body2),
                  ],
                ),
              ),
              const GapWidget(size: 10),
              DrawerTile(
                icon: Icons.home_filled,
                title: 'Home',
                onTap: () {
                  Navigator.pushReplacementNamed(context, HomePage.routeName);
                },
              ),
              DrawerTile(
                icon: Icons.person_2_outlined,
                title: 'My Profile',
                onTap: () {
                  Navigator.pushNamed(context, MyProfileScreen.routeName);
                },
              ),
              DrawerTile(
                icon: Icons.library_books,
                title: ' About Us',
                onTap: () {
                  Navigator.pushNamed(context, AboutUs.routeName);
                },
              ),
              const DrawerTile(icon: Icons.add_to_queue, title: 'Requests'),
              const DrawerTile(icon: Icons.history, title: 'Donate History'),
              DrawerTile(
                icon: Icons.menu_book,
                title: 'Terms & Conditions',
                onTap: () {
                  Navigator.pushNamed(context, TermsConditions.routeName);
                },
              ),
              DrawerTile(
                icon: Icons.policy,
                title: 'Privacy Policy',
                onTap: () {
                  Navigator.pushNamed(context, PrivacyPolicy.routeName);
                },
              ),
              const DrawerTile(
                icon: Icons.reviews_outlined,
                title: 'Rate Us',
              ),
              DrawerTile(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
