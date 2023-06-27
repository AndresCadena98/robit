
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';

import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Blocs
import 'package:imagesia/blocs/search_bloc/search_bloc.dart';
import 'package:imagesia/blocs/voice_bloc/voice_bloc.dart';
import 'blocs/auth_bloc/auth_bloc.dart';
import 'blocs/user_bloc/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//Services
import 'package:imagesia/services/auth_services.dart';


//Pages
import 'pages/pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(lazy: false, create: (context) => UserBloc()),
        BlocProvider(create: (context) => SearchBloc()),
        BlocProvider(
          lazy: false,
          create: (context) => VoiceBloc()..add(GetVoiceEvent())),
      ],
      child: MaterialApp(
        title: 'Material App',
        theme: ThemeData(useMaterial3: true, fontFamily: 'Righteous'),
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (context) => const MyHomePage(title: ''),
          '/login': (context) => LoginPage(),
        },
        home: Scaffold(
          body: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return FlutterSplashScreen.gif(
                backgroundColor: Colors.black,
                gifPath: 'assets/icons/ai.png',
                gifWidth: 200,
                gifHeight: 200,
                defaultNextScreen: const MainLayout(),
                duration: const Duration(milliseconds: 3000),
                onInit: () async {
                  AuthServices().user.listen((User? user) {
                    print("User: $user");
                    if (user == null) {
                      print("User Not Logged");
                      BlocProvider.of<AuthBloc>(context)
                          .add(AuthEventStarted(user: null));
                    } else {
                      print("User Logged");
                      BlocProvider.of<AuthBloc>(context)
                          .add(AuthEventStarted(user: user));
                    }
                  });
                },
                onEnd: () async {},
              )..animate().fadeIn().scale();
            },
          ),
        ),
      ),
    );
  }
}
