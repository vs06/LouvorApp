import 'package:flutter/material.dart';
import 'package:louvor_app/helpers/date_utils.dart';
import 'package:louvor_app/models/Service.dart';
import 'package:louvor_app/models/service_manager.dart';
import 'package:louvor_app/models/user.dart';
import 'package:louvor_app/models/user_manager.dart';
import 'package:provider/provider.dart';

class UserListTile extends StatelessWidget {

  const UserListTile(this.user);

  final User user;

  _showAlertDialog(BuildContext context, String conteudo, User u) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: Text(conteudo),
          actions: [
            FlatButton(
              child: Text('Não'),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text('Sim'),
              onPressed: () {
                 u.userInactivated();
                 context.read<UserManager>().update(u);
                 Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4)
          ),
          child: Container(
            height: 85,
            padding: const EdgeInsets.all(6),
            child: Row(
              children: <Widget>[
                const SizedBox(width: 16,),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            user.name,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context).primaryColor
                            ),
                          ),
                          Visibility(
                            visible: UserManager.isUserAdmin,
                            child: GestureDetector(
                                      onTap: () {
                                        _showAlertDialog(context, 'Confirma a exclusão desse Usuário?', user);
                                      },
                                      child: Icon(Icons.delete, color: Colors.blueGrey,),
                                  ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          user.email,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          user.isAdmin,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      )

                    ],
                  ),
                )
              ],
            ),
          ),
        );
  }
}