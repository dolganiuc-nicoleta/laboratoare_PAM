import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/home_cubit.dart';
import 'data/app_repository.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const GemStoreLab3App());
}

class GemStoreLab3App extends StatelessWidget {
  const GemStoreLab3App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => HomeCubit(const AppRepository())..loadHome(),
      child: MaterialApp(
        title: 'GemStore — Lab 3',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Roboto',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}