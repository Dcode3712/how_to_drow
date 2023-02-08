import 'package:container_tab_indicator/container_tab_indicator.dart';
import 'package:draw1/Screens/discover_page.dart';
import 'package:flutter/material.dart';
import 'favourite_screen.dart';

class home_screen extends StatefulWidget {

  bool? like;
  home_screen({this.like});

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  int _selectedIndex = 0;

  _onItemTapped(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Tab> tabs = <Tab>[
    const Tab(text: "Discover"),
    const Tab(text: "Favourite"),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SafeArea(
        child: DefaultTabController(
          length: tabs.length,
          child: Scaffold(
            backgroundColor: const Color(0xFF0B1222),
            body: Column(children: [
              Container(
                color: const Color(0xFF192033),
                height: 145,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Container(alignment: Alignment.topLeft,margin: const EdgeInsets.fromLTRB(15, 10, 0, 0),child:  const Text(
                        "Cute Girl",
                        style: TextStyle(
                          fontSize: 28,
                          letterSpacing: 1,
                          color: Colors.white,
                          fontFamily: "RecoletaRegular",
                        ),
                      ),),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(right: 50),
                      child: TabBar(
                            labelColor: Colors.white,
                            unselectedLabelColor: const Color(0xFFFA5E78),
                            unselectedLabelStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: "ProductRegular",
                                letterSpacing: 0.2),
                            labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                            labelStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: "ProductRegular",
                                letterSpacing: 0.2),
                            indicator: const ContainerTabIndicator(
                              width: 130,
                              height: 45,
                              radius: const BorderRadius.all(Radius.circular(30.0)),
                              color: const Color(0xFFF86174),
                              borderColor: const Color(0xFFF86174),
                            ),
                            padding: const EdgeInsets.all(10),
                            onTap: _onItemTapped,
                            indicatorSize: TabBarIndicatorSize.tab,
                            tabs: tabs,
                          ),
                    ),
                  ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: TabBarView(
                      children: [discover_page(), const favourite_screen()])),
            ]),
          ),
        ),
      ),
    );
  }
}
