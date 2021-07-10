// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:teamsclone/authentication/google_signin.dart';
import 'package:teamsclone/pages/homepage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teamsclone/sign_in_up_pages/signin.dart';

//main function to run the source code
//initializing all firestore apis

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Googlesigninprov(),
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(
          seconds: 2,
          // pageRoute: MaterialPageRoute(
          //   builder: (context) => Mainrun(),
          // ),
          navigateAfterSeconds: Mainrun(),
          loadingText: Text(
            "Microsoft",
            style: TextStyle(
              color: Colors.grey,
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
              fontSize: 30,
            ),
          ),
          image: Image.asset(
            'assets/applogo.png',
            height: 150.0,
            width: 150.0,
          ),
          backgroundColor: Colors.grey[900],
          photoSize: 100.0,
          loaderColor: Colors.transparent,
        ),
      ),
    );
  }
}

class Mainrun extends StatefulWidget {
  const Mainrun({Key key}) : super(key: key);

  @override
  _MainrunState createState() => _MainrunState();
}

class _MainrunState extends State<Mainrun> {
  LocalAuthentication localauth = new LocalAuthentication();

  bool _checksensoravailability = false;
  List<BiometricType> _authtype = [];
  bool _authstatus = false;

  @override
  void initState() {
    super.initState();
    checksensors();
  }

  //function to check sensors availability
  Future<void> checksensors() async {
    bool checksensor;

    try {
      checksensor = await localauth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;
    setState(() {
      _checksensoravailability = checksensor;
      print(_checksensoravailability);
    });
    getsensors();
  }

  //function to access sensors for authentication
  Future<void> getsensors() async {
    List<BiometricType> available;

    try {
      available = await localauth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    setState(() {
      _authtype = available;
    });
    mainauthentication();
  }

  //function to authenticate local user using the accessible sensors
  Future<void> mainauthentication() async {
    bool authstatus = false;

    try {
      authstatus = await localauth.authenticate(
        localizedReason: "Tap",
        useErrorDialogs: true,
        stickyAuth: false,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;
    setState(() {
      _authstatus = authstatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!_authstatus && _checksensoravailability) {
            return Container(
              color: Colors.grey[900],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.lightBlue,
              ),
            );
          } else if (snapshot.hasData) {
            return HomePage();
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Some error occured..Please close and restart the application :)",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }
          return Signin();
        },
      ),
    );
  }
}
