import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia_app/components/my_drawer.dart';
import 'package:socialmedia_app/controllers/providers/PageProvider.dart';
import 'package:socialmedia_app/pages/discussion_page.dart';
import 'package:socialmedia_app/pages/post_page.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  late Pageprovider pPage;

  final List<Widget> _pages = <Widget>[
    const PostPage(),
    const DiscussionPage(),
    const DiscussionPage(),
  ];

  final List<String> _titles = <String>[
    'Posts',
    'Conversations',
    'Conversations',
  ];

  @override
  void initState() {
    super.initState();
    pPage = Provider.of<Pageprovider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[pPage.getIndex()]),
        ),
        drawer: MyDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(0),
          child: SingleChildScrollView(
            // Ajout de SingleChildScrollView pour rendre la page défilable
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 50,
                  child: _pages[pPage.getIndex()],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          height: 60,
          key: _bottomNavigationKey,
          index: pPage.getIndex(),
          items: <Widget>[
            Icon(Icons.home,
                size: 30,
                color: pPage.getIndex() == 0
                    ? Colors.white
                    : Colors.black),
            Icon(Icons.message,
                size: 30,
                color: pPage.getIndex() == 1
                    ? Colors.white
                    : Colors.black),
            Icon(Icons.person,
                size: 30,
                color: pPage.getIndex() == 2
                    ? Colors.white
                    : Colors.black),
          ],
          color: Theme.of(context).colorScheme.background,
          buttonBackgroundColor: Colors.black,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 200),
          onTap: (selectedIndex) {
            setState(() {
              pPage.setIndex(selectedIndex);
            });
          },
          letIndexChange: (index) => true,
        ),
      ),
    );
  }
}
