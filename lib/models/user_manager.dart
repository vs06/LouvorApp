import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:louvor_app/helpers/app_list_pool.dart';
import 'package:louvor_app/helpers/firebase_errors.dart';
import 'package:louvor_app/models/user_app.dart';

class UserManager extends ChangeNotifier {

  UserManager(){
    _loadCurrentUser();
    _loadAllUsers();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  UserApp? userApp;
  static bool? isUserAdmin;

  List<UserApp> allUsers = [];

  bool _loading = false;
  bool get loading => _loading;

  bool get isLoggedIn => userApp != null;

  Future<void> signIn({required UserApp userApp,required Function onFail,required Function onSuccess}) async {
    loading = true;
    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(email: userApp.email ?? '', password: userApp.password ?? '');

      await _loadCurrentUser(firebaseUser: result.user);

      _loadAllUsers();

      onSuccess();
    } on PlatformException catch (e){
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  Future<void> signUp({required UserApp userApp,required Function onFail,required Function onSuccess}) async {
    loading = true;
    try {
      final UserCredential result = await auth.createUserWithEmailAndPassword(
          email: userApp.email ?? '', password: userApp.password ?? '');

      userApp.id = result.user!.uid;
      userApp.isAdmin = 'FALSE';
      userApp.ativo = 'TRUE';
      //Retirado linha abaixo, para não logar
      // trocar o usuário ao admin, cadastrar um novo user
      //this.user = user;

      await userApp.saveData();

      onSuccess();
    } on PlatformException catch (e){
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  void signOut(){
    auth.signOut();
    userApp = null;
    notifyListeners();
  }

  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  static Future<void> resetPassword(String email) async {
    FirebaseAuth? auth = FirebaseAuth.instance;
    await auth.sendPasswordResetEmail(email: email);
    auth = null;
  }

  Future<void> _loadCurrentUser({User? firebaseUser}) async {
    final User currentUser = firebaseUser ?? await auth.currentUser!;
    if(currentUser != null){
      final DocumentSnapshot docUser = await firestore.collection('users')
          .doc(currentUser.uid).get();
      userApp = UserApp.fromDocument(docUser);
      isUserAdmin = userApp!.isAdmin == 'TRUE'? true : false;

      notifyListeners();
    }
  }


  Future<void> _loadAllUsers() async {
    final QuerySnapshot snapServices =
    await firestore.collection('users').where('ativo', isEqualTo: 'TRUE')
                                       .get().then((QuerySnapshot querySnapshot) => querySnapshot);

    allUsers = snapServices.docs.map(
            (d) => UserApp.fromDocument(d)).toList();

    if(AppListPool.usersName.isEmpty){

      //todo arrumar non safety
      //allUsers.sort((a, b) => a.name!.compareTo(b.name));

      AppListPool.fillUsers(allUsers);
    }

    notifyListeners();
  }

  List<UserApp> get filteredUsers {
    return allUsers;
  }

  void update(UserApp u){
    allUsers.removeWhere((u) => u.id == userApp!.id);
    userApp!.saveData();
    notifyListeners();
  }

  void userInactivated(UserApp u){
    allUsers.removeWhere((u) => u.id == userApp!.id);
    userApp!.userInactivated();
    notifyListeners();
  }

}