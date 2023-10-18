
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hearts/screens/comingsoon.dart';
import 'package:hearts/screens/history_screen.dart';
import 'package:hearts/screens/home.dart';
import 'package:hearts/screens/login.dart';
import 'package:hearts/screens/profile.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:get/get.dart';
import '../../controllers/carousel_controller.dart';
import '../../providers/user.dart';
import '../../widgets/carousel_loading.dart';
import '../../widgets/myfonts.dart';
import '../../widgets/oval_right_clipper.dart';
import '../WebViewApp.dart';

final GlobalKey<ScaffoldState> HEARTSKey = GlobalKey();

class dashboard1 extends StatefulWidget {
  const dashboard1({super.key});

  @override
  _dashboard1State createState() => _dashboard1State();
}

class _dashboard1State extends State<dashboard1>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _animation2;

  final Color primary = Colors.white;
  final Color active = Colors.grey.shade800;
  final Color divider = Colors.grey.shade600;

  @override
  void initState() {
    super.initState();
    _deviceToken();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),

    );

    _animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {});
      });

    _animation2 = Tween<double>(begin: -30, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    _controller.forward();
  }
  _deviceToken() async {
    UserProvider user = Provider.of<UserProvider>(context, listen: false);

    await user.initialize();

    // if (user.userModel?.token != prefs.getString('token')) {
    user.saveDeviceToken();
    //}

    // print(prefs.getString(showPref));
    // print(prefs.getString(driverIdPref));
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller.dispose();
    super.dispose();
  }
  final SliderController _sliderController = Get.put(SliderController());
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      key: HEARTSKey,
      drawer: ClipPath(
        clipper: OvalRightBorderClipper(),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Drawer(
          child: Container(
            padding: const EdgeInsets.only(left: 16.0, right: 40),
            decoration: BoxDecoration(
                color: darkTheme ? Colors.black38 : Colors.grey[300],
                boxShadow: const [BoxShadow(color: Colors.black45)]),
            width: 300,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(50),
                          boxShadow:  [
                            BoxShadow(
                                color: darkTheme ? Colors.black26 : const Color(0xFFBEBEBE),
                                offset: const Offset(10, 10),
                                blurRadius: 20,
                                spreadRadius: 1
                            ),
                            BoxShadow(
                                color: darkTheme ? Colors.white24 : Colors.white,
                                offset: const Offset(-5, -5),
                                blurRadius: 20,
                                spreadRadius: 1
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.power_settings_new,
                            color: active,
                          ),
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: 90,
                      width: 90,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2, color: Colors.orange),
                      ),
                      child: const CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('assets/HEARTS2.png')),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      userProvider.userModel?.name ?? "This is null",
                      style: TextStyle(
                          color: darkTheme ? Colors.white : Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      userProvider.userModel?.email ?? "This is null",
                      style: TextStyle(
                          color: darkTheme ? Colors.white : Colors.black,
                          fontSize: 16.0),
                    ),
                    30.height,
                    GestureDetector(
                      child: _buildRow(Icons.person_pin, "My profile"),
                      onTap: () {
                        finish(context);
                        const ProfileScreen().launch(context);
                      },
                    ),
                    _buildDivider(),
                    GestureDetector(
                      child: _buildRow(Icons.history, "Booking History",
                          showBadge: true),
                      onTap: () {
                        finish(context);
                        HistoryScreen().launch(context);
                      },
                    ),
                    _buildDivider(),
                    GestureDetector(
                      child: _buildRow(
                          Icons.history, "Emergency and \nMedication History"),
                      onTap: () {
                        finish(context);
                        // HEARTSMyRidesScreen().launch(context);
                      },
                    ),
                    _buildDivider(),
                    GestureDetector(
                      child: _buildRow(Icons.notifications, "Notifications",
                          showBadge: true),
                      // onTap: () {
                      //   finish(context);
                      //   HEARTSMyRidesScreen().launch(context);
                      // },
                    ),
                    _buildDivider(),
                    GestureDetector(
                      child: _buildRow(Icons.settings, "Settings"),
                      // onTap: () {
                      //   finish(context);
                      //   HEARTSMyRidesScreen().launch(context);
                      // },
                    ),
                    _buildDivider(),
                    GestureDetector(
                      child: _buildRow(
                          Icons.contact_phone, "Emergency \nContact Numbers"),
                      // onTap: () {
                      //   finish(context);
                      //   HEARTSMyRidesScreen().launch(context);
                      // },
                    ),
                    _buildDivider(),
                    GestureDetector(
                      child: _buildRow(Icons.favorite, "My Favorites"),
                      onTap: () {
                        finish(context);
                        // HEARTSFavouriteScreen().launch(context);
                      },
                    ),
                    _buildDivider(),
                    GestureDetector(
                      child: _buildRow(Icons.info_outline, "Help"),
                      onTap: () {
                        finish(context);
                        // HEARTSMyRidesScreen().launch(context);
                      },
                    ),
                    _buildDivider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: darkTheme ? Colors.white30 : Colors.grey[300],
      //Color(0xff6DA5C0),
      body: Stack(
        children: [
          SizedBox(height: w / 50),
          /// ListView
          ListView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, w / 20, 0, w / 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'HEARTS',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 40,
                        color: darkTheme ? Colors.white : Colors.blue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: w / 50),
                    AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText(
                          'Are You In Need Of Health Care?',
                          speed: const Duration(milliseconds: 100),
                          textStyle: TextStyle(
                              color: darkTheme
                                  ? Colors.yellowAccent
                                  : Colors.pinkAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                      isRepeatingAnimation: true,
                      repeatForever: true,
                      displayFullTextOnTap: true,
                      stopPauseOnTap: true,
                      // 'Are You In Need Of Health Care?',
                      // style: TextStyle(
                      //   fontSize: 22,
                      //   color: Colors.red,
                      //   fontWeight: FontWeight.bold,
                      // ),
                      // textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              homePageCardsGroup(
                Colors.blueAccent,
                HeartsIcons.ambulance_1,
                'Book Ambulance',
                context,
                const HomeScreen(),
                darkTheme ? Colors.deepOrangeAccent : const Color(0xff9b59b6),
                // routee(),

                Colors.blueAccent,
                Icons.home_work_outlined,
                'Home Based Care',
                 ComingSoon(),
                darkTheme ? Colors.cyanAccent : const Color(0xff3498db),
              ),
              homePageCardsGroup(
                Colors.blueAccent,
                Icons.on_device_training_outlined,
                'HealthCare Training',
                context,
                 ComingSoon(),
                darkTheme ? Colors.amber : const Color(0xff2ecc71),
                Colors.blueAccent,
                HeartsIcons.th,
                'Take Quiz and Win Prizes',
                 const WebViewApp(),
                darkTheme ? Colors.lightBlueAccent : const Color(0xff1abc9c),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Advertise Here",
                    style: TextStyle(
                      fontSize: 25,
                      color: darkTheme ? Colors.yellow : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Icon(
                    Icons.arrow_downward_rounded,
                    size: 30,
                    color: darkTheme ? Colors.yellow : Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 1),
              Divider(
                color: darkTheme ? Colors.tealAccent : Colors.blueAccent,
                height: 5,
                //height spacing of divider
                thickness: 3,
                //thickness of divier line
                indent: 15,
                //spacing at the start of divider
                endIndent: 15, //spacing at the end of divider
              ),
              const SizedBox(height: 5),

              SafeArea
                (child: Obx(
                    () => _sliderController.banners.isNotEmpty
                    ? ListView.builder(
                  itemCount: _sliderController.banners.length,
                  itemBuilder: (BuildContext context, int index) {
                    var banner = _sliderController.banners[index];

                    return Container(
                      margin: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.network(banner.imageUrl),
                          SizedBox(height: 8.0),
                          Text(banner.description),
                        ],
                      ),
                    );
                  },
                )
                    : const CarouselLoading(),
              ),
              ),
            ],
          ),

          /// DRAWER ICON
          Padding(
            padding: EdgeInsets.fromLTRB(15.5, w / 9.5, w / 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    HEARTSKey.currentState!.openDrawer();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) {
                    //       return const RouteWhereYouGo();
                    //     },
                    //   ),
                    // );
                  },
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(99)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                      child: Container(
                        height: w / 8.5,
                        width: w / 8.5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue, width: 1.5),
                          boxShadow:  [
                            BoxShadow(
                                color: darkTheme ? Colors.black26 : Colors.black12,
                                offset: const Offset(10, 10),
                                blurRadius: 20,
                                spreadRadius: 1
                            ),
                            BoxShadow(
                                color: darkTheme ? Colors.white24 : Colors.blueGrey,
                                offset: const Offset(-5, -5),
                                blurRadius: 20,
                                spreadRadius: 1
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            HeartsIcons.th_large,
                            size: w / 17,
                            color: darkTheme
                                ? Colors.black26
                                : Colors.black.withOpacity(.6),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Blur the Status bar
          blurTheStatusBar(context),
        ],
      ),
    );
  }

  Widget homePageCardsGroup(
    Color color,
    IconData icon,
    String title,
    BuildContext context,
    Widget route,
    Color iconcolor1,
    Color color2,
    IconData icon2,
    String title2,
    Widget route2,
    Color iconColor,
  ) {
    double w = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(bottom: w / 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          homePageCard(color, icon, title, context, route, iconcolor1),
          homePageCard(color2, icon2, title2, context, route2, iconColor),
        ],
      ),
    );
  }

  Widget homePageCard(
    Color color,
    IconData icon,
    String title,
    BuildContext context,
    Widget route,
    Color iconColor,
  ) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    double w = MediaQuery.of(context).size.width;
    return Opacity(
      opacity: _animation.value,
      child: Transform.translate(
        offset: Offset(0, _animation2.value),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return route;
                },
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            height: w / 2.4,
            width: w / 2.4,
            decoration: BoxDecoration(
              color: darkTheme ? Colors.black12 : Colors.grey[300],
              border: Border.all(color: Colors.blue, width: 1.5),
              boxShadow: [
                BoxShadow(
                    color: darkTheme ? Colors.black26 : const Color(0xFFBEBEBE),
                    offset: const Offset(10, 10),
                    blurRadius: 20,
                    spreadRadius: 1),
                BoxShadow(
                    color: darkTheme ? Colors.white24 : Colors.white24,
                    offset: const Offset(-5, -5),
                    blurRadius: 20,
                    spreadRadius: 1),
              ],
              borderRadius: const BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(),
                Container(
                  height: w / 6,
                  width: w / 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 1.5),
                  ),
                  child: Icon(
                    icon,
                    size: w / 11,
                    color: iconColor,
                  ),
                ),
                Text(
                  title,
                  maxLines: 4,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget blurTheStatusBar(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
        child: Container(
          height: w / 18,
          color: Colors.transparent,
        ),
      ),
    );
  }





  Divider _buildDivider() {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Divider(
      color: darkTheme ? Colors.white : Colors.grey.shade600,
    );
  }

  Widget _buildRow(IconData icon, String title, {bool showBadge = false}) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final TextStyle tStyle = TextStyle(
        color: darkTheme ? Colors.white : Colors.black, fontSize: 16.0);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(children: [
        Icon(
          icon,
          color: darkTheme ? Colors.white70 : Colors.black,
        ),
        const SizedBox(width: 10.0),
        Text(
          title,
          style: tStyle,
        ),
        const Spacer(),
        if (showBadge)
          Material(
            color: Colors.deepOrange,
            elevation: 5.0,
            shadowColor: Colors.red,
            borderRadius: BorderRadius.circular(5.0),
            child: Container(
              width: 25,
              height: 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: const Text(
                "0+",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
      ]),
    );
  }
}


