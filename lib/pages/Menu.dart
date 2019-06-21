import 'package:ahorradora/components/categoria.dart';
import 'package:ahorradora/providers/DataProvider.dart';
import 'package:flutter/material.dart';


class Menu extends StatefulWidget {
  Menu({Key key, this.title}) : super(key: key);
  final String title;

  @override
  MenuPageState createState() => MenuPageState();
}

class MenuPageState extends State<Menu> {

  DataProvider dataProvider;
  int currentTabIndex = 0;
  static final List<Widget> tabs =[
     new Categoria(index: 0),
     new Categoria(index: 1),
     new Categoria(index: 2),
     new Categoria(index: 3),
     new Categoria(index: 4),
     new Categoria(index: 5),
  ];

  Widget currentW=tabs[0];

  @override
  initState()  {
    super.initState();
    dataProvider=new DataProvider();
  }

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
      currentW= tabs[currentTabIndex];
    });
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Ahorradora'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.select_all),
              onPressed: (){
                setState(() {
                  currentW=tabs[5];
                });
              },
            ),
          ],
        ),
        body:  currentW,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.white30,
          backgroundColor:  Color.fromRGBO(71,68,196,1),
          onTap: onTapped,
          currentIndex: currentTabIndex,
          items: [
            BottomNavigationBarItem(title: Text('20 K'), icon: Icon(Icons.child_care,color: Colors.white)),
            BottomNavigationBarItem(title: Text('40 K'),icon: Icon(Icons.add_box,color: Colors.white)),
            BottomNavigationBarItem(title: Text('60 K'),icon: Icon(Icons.music_note,color: Colors.white)),
            BottomNavigationBarItem(title: Text('80 K'),icon: Icon(Icons.wb_sunny,color: Colors.white)),
            BottomNavigationBarItem(title: Text('100 K'),icon: Icon(Icons.beenhere,color: Colors.white)),
          ],
        ),
      );
  }
}
