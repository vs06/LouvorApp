import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:louvor_app/helpers/app_list_pool.dart';
import 'package:louvor_app/helpers/firebase_errors.dart';
import 'package:louvor_app/models/user.dart';

class UserManager extends ChangeNotifier {

  UserManager(){
    _loadCurrentUser();
    _loadAllUsers();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore firestore = Firestore.instance;

  User user;
  static bool isUserAdmin;

  List<User> allUsers = [];

  bool _loading = false;
  bool get loading => _loading;

  bool get isLoggedIn => user != null;

  Future<void> signIn({User user, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final AuthResult result = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);

      await _loadCurrentUser(firebaseUser: result.user);

      _loadAllUsers();

      onSuccess();
    } on PlatformException catch (e){
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  Future<void> signUp({User user, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final AuthResult result = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);

      user.id = result.user.uid;
      this.user = user;

      await user.saveData();

      onSuccess();
    } on PlatformException catch (e){
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  void signOut(){
    auth.signOut();
    user = null;
    notifyListeners();
  }

  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  Future<void> _loadCurrentUser({FirebaseUser firebaseUser}) async {
    final FirebaseUser currentUser = firebaseUser ?? await auth.currentUser();
    if(currentUser != null){
      final DocumentSnapshot docUser = await firestore.collection('users')
          .document(currentUser.uid).get();
      user = User.fromDocument(docUser);
      isUserAdmin = user.isAdmin == 'TRUE'? true : false;

      notifyListeners();
    }
  }


  Future<void> _loadAllUsers() async {
    final QuerySnapshot snapServices =
    await firestore.collection('users').where('ativo', isEqualTo: 'TRUE').getDocuments();

    allUsers = snapServices.documents.map(
            (d) => User.fromDocument(d)).toList();

    AppListPool.fillUsers(allUsers);

    notifyListeners();
  }

  List<User> get filteredUsers {
    return allUsers;
  }

  void update(User u){
    allUsers.removeWhere((u) => u.id == user.id);
    user.saveData();
    notifyListeners();
  }

  void userInactivated(User u){
    allUsers.removeWhere((u) => u.id == user.id);
    user.userInactivated ();
    notifyListeners();
  }

}