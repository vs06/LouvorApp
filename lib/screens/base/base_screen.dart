import 'package:flutter/material.dart';
import 'package:louvor_app/common/custom_drawer/custom_drawer.dart';
import 'package:louvor_app/models/page_manager.dart';
import 'package:louvor_app/models/user_manager.dart';
import 'package:louvor_app/screens/User/users_screen.dart';
import 'package:louvor_app/screens/services/ServicesPeriodSelect.dart';
import 'package:louvor_app/screens/songs/songs_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: Consumer<UserManager>(
        builder: (_, userManager, __){
          return PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              Scaffold(
                drawer: CustomDrawer(),
                appBar: AppBar(
                  title: const Text('CEU Louvor'),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset("assets/worship_tile.png", width: 600),
                ),
              ),
              SongsScreen(),
              ServicesPeriodSelect('Service'),
              ServicesPeriodSelect('Rehearsal'),
              UsersScreen(),
            ],
          );
        },
      ),
    );
  }
}