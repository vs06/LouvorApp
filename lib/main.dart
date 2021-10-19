import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:louvor_app/models/Tag.dart';
import 'package:louvor_app/models/tag_manager.dart';
import 'package:louvor_app/screens/User/users_screen.dart';
import 'package:louvor_app/screens/rehearsals/rehearsal_period_select.dart';
import 'package:louvor_app/screens/rehearsals/rehearsal_screen.dart';
import 'package:louvor_app/screens/services/services_period_select.dart';
import 'package:louvor_app/screens/services/service_screen.dart';
import 'package:provider/provider.dart';
import 'package:louvor_app/models/user_manager.dart';
import 'package:louvor_app/screens/base/base_screen.dart';
import 'package:louvor_app/screens/login/login_screen.dart';
import 'package:louvor_app/screens/songs/song_screen.dart';
import 'package:louvor_app/screens/songs/songs_screen.dart';
import 'package:louvor_app/screens/services/services_screen.dart';
import 'package:louvor_app/screens/signup/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';


import 'models/Rehearsal.dart';
import 'models/Song.dart';
import 'models/rehearsal_manager.dart';
import 'models/song_manager.dart';
import 'models/Service.dart';
import 'models/service_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, SongManager>(
          create: (_) => SongManager(),
          lazy: false,
          update: (_, userManager, songManager) =>
              songManager!..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, ServiceManager>(
           create: (_) => ServiceManager(),
           lazy: false,
           update: (_, userManager, serviceManager) =>
           serviceManager!..updateUser(userManager),
         ),
        ChangeNotifierProxyProvider<UserManager, RehearsalManager>(
          create: (_) => RehearsalManager(),
          lazy: false,
          update: (_, userManager, rehearsalManager) =>
          rehearsalManager!..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, TagManager>(
          create: (_) => TagManager(),
          lazy: false,
          update: (_, userManager, tagManager) =>
          tagManager!..updateUser(userManager),
        )
      ],
      child: MaterialApp(
        title: 'Louvor',
        debugShowCheckedModeBanner: false,
        home: BaseScreen(),
        initialRoute: '/base',

        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [const Locale('pt', 'BR')],

        onGenerateRoute: (settings){
          switch(settings.name){
            case '/login':
              return MaterialPageRoute(
                  builder: (_) => LoginScreen()
              );
            case '/signup':
              return MaterialPageRoute(
                  builder: (_) => SignUpScreen()
              );
            case '/song':
              return MaterialPageRoute(
                  builder: (_) => SongScreen(
                      settings.arguments as Song
                  )
              );
            case '/songs':
              return MaterialPageRoute(
                  builder: (_) => SongsScreen()
              );
            case '/service':
              return MaterialPageRoute(
                  builder: (_) => ServiceScreen(
                      settings.arguments as Service
                  )
              );
            case '/services':
              return MaterialPageRoute(
                  builder: (_) => ServicesScreen()
              );
            case '/servicesperiod':
              return MaterialPageRoute(
                  builder: (_) => ServicesPeriodSelect("Service")
              );
            case '/rehearsalsperiod':
              return MaterialPageRoute(
                  builder: (_) => ServicesPeriodSelect("Rehearsal")
              );
            case '/rehearsal':
              return MaterialPageRoute(
                  builder: (_) => RehearsalScreen(null)
              );
            case '/users':
              return MaterialPageRoute(
                  builder: (_) => UsersScreen()
              );
            case '/base':
            default:
              return MaterialPageRoute(
                  builder: (_) => BaseScreen()
              );
          }
        },
      ),
    );
  }
}