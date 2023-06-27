import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagesia/blocs/auth_bloc/auth_bloc.dart';

import 'pages.dart';




class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: BlocBuilder<AuthBloc,AuthState>(
        builder: (context,state){
          if(state is AuthInitial){
            return Center(child: CircularProgressIndicator(),);
          }else if(state is AuthStateAuthenticated){
            return MyHomePage(title: '');
          }else if(state is AuthStateUnauthenticated){
            return LoginPage();
          }else{
            return Center(child: Text('Error'),);
          }
        },
      
      )
      
      );
  }
}