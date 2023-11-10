import 'dart:async';
import 'package:audio/di/get_it.dart';
import 'package:audio/features/add_music/presentation/view/add_music/add_music_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  unawaited(init());
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const ScreenUtilInit(
      child: MaterialApp(
        home: AddMusicScreen(),
      ),
    );
  }
}
