// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rmcheckin/app/models/model.dart';
import 'package:rmcheckin/app/models/motorista_auth_model.dart';
import 'package:rmcheckin/app/pages/home/home_page.dart';
import 'package:rmcheckin/app/pages/input/input_screen.dart';
import 'package:rmcheckin/app/services/status_service.dart';
import 'package:rmcheckin/app/shared/theme/colors_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
final notificationHandler = FlutterLocalNotificationsPlugin();
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask(
    (task, inputData) async {
      debugPrint("BG task $task start.");
      var listCheckins = (await Checkin().select().toList())
          .map(
            (e) => e.id!,
          )
          .toList();

      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final result = sharedPreferences.getString("data");
      var user = Motorista.fromMap(jsonDecode(result!)["data"]);
      var resultStatusCheckins = await statusCheckin(
        cpf: user.cpf,
        checkInIds: listCheckins,
      );

      debugPrint(
        const JsonEncoder.withIndent("    ").convert(resultStatusCheckins),
      );
      
      for (var atualizacao in resultStatusCheckins) {
        if ([
          'RECEBIDA',
          'ENTRADA_NAO_AUTORIZADA',
          'VEICULO_NO_PATIO',
          'EM_CONFERENCIA',
          'FINALIZADO',
          'G',
          'AGUARDANDO_LIBERACAO',
        ].contains(atualizacao["status"].toString())) {
          continue;
        }

        notificationHandler.show(
          atualizacao["id"],
          "Checkin - ${atualizacao["id"]} - ${atualizacao["lojaDesc"]}",
          switch (atualizacao["status"] as String) {
            'REGISTRANDO' => "Estamos validando suas NFs, favor aguardar.",
            'AGUARDANDO_AUTORIZACAO_ENTRADA' => "NF's validadas com sucesso.\nAguarde autorização para entrada...",
            'ENTRADA_AUTORIZADA' => "Entrada autorizada para a doca ${atualizacao["docaDesc"]}. Favor se encaminhar para a portaria em até 30min.",
            'CONFERENCIA_FINALIZADA' => "Sua carga foi finalizada, obrigado!",
            'CANCELADO' => "Cancelado.",
            Object() => '',
          },
          const NotificationDetails(
            android: AndroidNotificationDetails("channelId", "channelName"),
            iOS: DarwinNotificationDetails(),
          ),
        );
      }
      debugPrint("BG task $task end.");
      return Future.value(true);
    },
  );
}

Future<void> initializeNotifications() async {
  await notificationHandler.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings(
        'ic_notification',
      ),
      iOS: DarwinInitializationSettings(),
    ),
    // onDidReceiveNotificationResponse: (details) =>
    //     WidgetsBinding.instance.addPostFrameCallback(
    //   (timeStamp) => showDialog(
    //     context: context,
    //     builder: (context) {
    //       return ???;
    //     },
    //   ),
    // ),
  );
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );
  await Workmanager().registerPeriodicTask(
    "atualizar-checkins",
    "atualizarCheckinsTask",
  );
  await Workmanager().registerOneOffTask(
    "atualizar-checkins-once",
    "atualizarCheckinsTaskOnce",
  );
}

main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  final bool hasUser = await verificarUser();

  initializeNotifications();

  runApp(
    MyApp(
      hasUser: hasUser,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    required this.hasUser,
  }) : super(key: key);
  final bool hasUser;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    notificationHandler.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      routes: {
        '/checkin': (context) => const HomePage(initialHomePage: InitialHomePage.checkin),
      },
      title: 'RMCheckIn',
      debugShowCheckedModeBanner: false,
      theme: myTheme,
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      home: widget.hasUser ? const HomePage() : const InputScreen(),
    );
  }
}

Future<bool> verificarUser() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString('data') != null;
}
