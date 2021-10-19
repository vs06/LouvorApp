import 'package:flutter/material.dart';
import 'package:louvor_app/helpers/validators.dart';
import 'package:louvor_app/models/user_app.dart';
import 'package:louvor_app/models/user_manager.dart';
import 'package:louvor_app/screens/User/user_list_tile.dart';
import 'package:louvor_app/screens/services/components/service_list_tile.dart';
import 'package:provider/provider.dart';

class UsersScreen extends StatelessWidget {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Usuários'),
        centerTitle: true,
        actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
                onPressed: () {Navigator.of(context).pushNamed('/signup',);
              },
            )
        ],
      ),
      body: Consumer<UserManager>(
        builder: (_, userManager, __) {
          final filteredUsers = userManager.filteredUsers;
          return ListView.builder(
              padding: const EdgeInsets.all(4),
              itemCount: filteredUsers.length,
              itemBuilder: (_, index) {
                return UserListTile(filteredUsers[index]);
              });
        },
      ),
    );
  }
}