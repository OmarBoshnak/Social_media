import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/firebase_options.dart';
import 'package:social_media/module/layout/cubit/cubit.dart';
import 'package:social_media/module/layout/layout_screem.dart';
import 'package:social_media/module/log/cubit/cubit.dart';
import 'package:social_media/module/log/cubit/state.dart';
import 'package:social_media/module/register/cubit/cubit.dart';
import 'package:social_media/shared/companants.dart';
import 'package:social_media/shared/endpoints.dart';
import 'package:social_media/shared/local/cache.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onMessage.listen((event) {
    showToast(text: 'on message', state: ToastState.SUCCESS);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    showToast(text: 'on message open app', state: ToastState.SUCCESS);
  });
  Widget widget;
  await CacheHelper.init();
  uId = CacheHelper.getData(key: 'uId');

  widget = const LayoutScreen();
  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  const MyApp({super.key, required this.startWidget});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => SocialCubit()
              ..getUserData()
              ..getPosts()
              ..getUsers()),
        BlocProvider(
          create: (context) => SocialLoginCubit(),
        ),
        BlocProvider(
          create: (context) => SocialRegisterCubit(),
        ),
      ],
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: startWidget,
          );
        },
      ),
    );
  }
}
