import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'data/datasources/feed_remote_data_source.dart';
import 'data/repositories/feed_repository_impl.dart';
import 'domain/repositories/feed_repository.dart';
import 'domain/usecases/get_home_feed.dart';
import 'presentation/cubit/home_cubit.dart';
import 'presentation/screens/home_screen.dart';

void main() => runApp(const GemStoreLab4App());

class GemStoreLab4App extends StatelessWidget {
  const GemStoreLab4App({super.key});

  @override
  Widget build(BuildContext context) {
    // Lanțul dependențelor, de jos în sus:
    // http.Client -> DataSource -> Repository -> UseCase -> Cubit
    // RepositoryProvider pune repository-ul la dispoziția întregii aplicații.
    // Tipul este INTERFAȚA (FeedRepository), implementarea e FeedRepositoryImpl.
    return RepositoryProvider<FeedRepository>(
      create: (_) => FeedRepositoryImpl(FeedRemoteDataSource(http.Client())),
      // BlocProvider creează HomeCubit; ..load() pornește imediat prima cerere HTTP.
      child: BlocProvider(
        create: (ctx) => HomeCubit(GetHomeFeed(ctx.read<FeedRepository>()))..load(),
        child: MaterialApp(
          title: 'GemStore — Lab 4',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFFF7F5F3),
            fontFamily: 'Roboto',
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
            useMaterial3: true,
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
