import 'dart:ui';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:imagesia/blocs/auth_bloc/auth_bloc.dart';
import 'package:imagesia/blocs/user_bloc/user_bloc.dart';
import 'package:imagesia/pages/Home/widgets/chat_widget.dart';
import 'package:imagesia/pages/login/login_page.dart';

import '../../blocs/voice_bloc/voice_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<UserBloc>(context).add(SetUserEvent());
  }

  String? uid = '';
  String? email = '';
  String? displayName = '';
  String? photoURL = '';
  bool? emailVerified = false;
  // UI Configuraciones

  setConfig(BuildContext context) {
    int value = 0;

    return showModalBottomSheet(
        useSafeArea: true,
        context: context,
        builder: (context) {
          return BlocBuilder<VoiceBloc, VoiceState>(
            builder: (context, state) {
              if(state is VoiceInitial){
                value = state.voice == true ? 0 : 1;
              }
              return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  title: AnimatedToggleSwitch<int>.size(
                    current: value,
                    values: const [
                      0,
                      1,
                    ],
                    iconOpacity: 0.2,
                    indicatorSize: const Size.fromWidth(100),
                    iconAnimationType: AnimationType.onHover,
                    indicatorAnimationType: AnimationType.onHover,
                    innerColor: Colors.white,
                    iconBuilder: (value, size) {
                      switch (value) {
                        case 0:
                          return const Icon(
                            Icons.record_voice_over_rounded,
                            color: Colors.black,
                            size: 30,
                          );
                        case 1:
                          return const Icon(
                            Icons.voice_over_off_rounded,
                            color: Colors.black,
                            size: 30,
                          );
                        default:
                          return const Icon(
                            Icons.light_mode,
                            color: Colors.black,
                            size: 30,
                          );
                      }
                    },
                    borderWidth: 0.0,
                    borderColor: Colors.transparent,
                    colorBuilder: (i) =>
                        i.isEven ? Colors.tealAccent : Colors.red,
                    onChanged: (i) {
                      print('switched to: $i');
                      BlocProvider.of<VoiceBloc>(context)
                          .add(SetVoiceEvent(voice: i == 0 ? true : false));
                    },
                  ),
                )
              ]);
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.transparent,
        ),
      ),
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/fondochat.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: const SafeArea(child: ChatWidget()))),
      floatingActionButton: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              FloatingActionButton(
                heroTag: "btn1",
                backgroundColor: Colors.tealAccent,
                onPressed: () {
                  return setConfig(context);
                },
                child: const Icon(Icons.speaker_phone),
              ),
              const SizedBox(
                width: 10,
              ),
              FloatingActionButton(
                heroTag: "btn2",
                backgroundColor: Colors.tealAccent,
                onPressed: () {
                  return buildMenu();
                },
                child: const Icon(Icons.person),
              ),
            ],
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
    );
  }
  setAvatar(BuildContext context) {
    return showModalBottomSheet(
        useSafeArea: true,

        isScrollControlled: true,
        context: context,
        builder: (context) {

          return FractionallySizedBox(
            heightFactor: 0.8,
            child: SizedBox(
              width: double.infinity,
              child: ListView(
                children: [
                  FluttermojiCircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 100,
                  ),
                  FluttermojiCustomizer(
                      scaffoldHeight: 400,
                      theme: FluttermojiThemeData(
                          selectedIconColor: Colors.tealAccent))
                ],
              ),
            ),
          );
        });
  }

   buildMenu() {
    var watchProfile = BlocProvider.of<UserBloc>(context).state;
     if (watchProfile is ReadyInfoUser) {
          uid = watchProfile.uid;
          email = watchProfile.email;
          displayName = watchProfile.displayName;
          photoURL = watchProfile.photoURL;
          emailVerified = watchProfile.emailVerified;
        }
    return showModalBottomSheet(
      useSafeArea: true,
      enableDrag: true,
      
      context: context, builder: (context){
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: Column(
          children: [
            Stack(
              children: [
                FluttermojiCircleAvatar(
              backgroundColor: Colors.black,
              radius: 80,
              //radius: 50,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  color: Colors.tealAccent,
                  shape: BoxShape.circle
                ),
                child: GestureDetector(
                  onTap: () {
                    setAvatar(context);
                  },
                  child: const Icon(Icons.edit, color: Colors.black,)),
              ),
            )
              ],
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(displayName!),
              
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(email!),
              
            ),    
            const Expanded(child: SizedBox()),        
            
            SafeArea(
              child: SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent
                  ),
                  onPressed: (){
                  BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                }, child: const Text('Cerrar Sesión', style: TextStyle(fontSize: 20, color: Colors.black),)),
              ),
            )
          ],
        ),
      );
    });
  }
}
/* BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage())); */