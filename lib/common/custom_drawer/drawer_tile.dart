import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {

  const DrawerTile({required this.iconData, required this.title, required this.page});

  final IconData iconData;
  final String title;
  final int page;

  @override
  Widget build(BuildContext context) {
    final int curPage = 0;
    /// context.watch<PageManager>().page;
    final Color primaryColor = Theme.of(context).primaryColor;

    return InkWell(
        onTap: (){
          ///context.read<PageManager>().setPage(page);
          //TODO Fix this POG
        switch(this.title) {
          case 'Repertório':
            Navigator.of(context).pushNamed('/songs');
            return;
          case 'Cultos':
            Navigator.of(context).pushNamed('/servicesperiod');
            return;
          case 'Usuários':
            Navigator.of(context).pushNamed('/users');
            return;
          case 'Ensaios':
            Navigator.of(context).pushNamed('/rehearsalsperiod'
            );
            return;
          default:
            Navigator.of(context).pushNamed('base');
            return;
        }
      },
      child: SizedBox(
        height: 60,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Icon(
                iconData,
                size: 32,
                color: curPage == page ? primaryColor : Colors.grey[700],
              ),
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  color: curPage == page ? primaryColor : Colors.grey[700]
              ),
            )
          ],
        ),
      ),
    );
  }
}