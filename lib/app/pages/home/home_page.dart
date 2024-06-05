// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:rmcheckin/app/pages/home/pages/checkin_page.dart';
import 'package:rmcheckin/app/pages/home/pages/config_page.dart';
import 'package:rmcheckin/app/pages/home/pages/perfil_page.dart';

enum InitialHomePage { config, perfil, historico, checkin }

extension InitialHomePageExt on InitialHomePage {
  bool get isConfig => this == InitialHomePage.config;
  bool get isPerfil => this == InitialHomePage.perfil;
  bool get isCheckin => this == InitialHomePage.checkin;
}

class HomePage extends StatefulWidget {
  final InitialHomePage? initialHomePage;

  const HomePage({
    Key? key,
    this.initialHomePage,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int intemSelecionado = 0;
  Color darkBlueColor = const Color(0xFF0C2356);
  @override
  void initState() {
    if (widget.initialHomePage != null) {
      switch (widget.initialHomePage!) {
        case InitialHomePage.config:
          intemSelecionado = 3;
          break;
        case InitialHomePage.checkin:
          intemSelecionado = 0;
          break;
        case InitialHomePage.perfil:
          intemSelecionado = 1;
          break;

        default:
      }
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: intemSelecionado,
        children: const [
          CheckinPage(),
          PerfilPage(),
          ConfigPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: intemSelecionado,
        backgroundColor: darkBlueColor,
        unselectedItemColor: Colors.grey,
        fixedColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "CheckIn",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Configurações"),
        ],
        onTap: (valor) {
          setState(
            () {
              intemSelecionado = valor;
            },
          );
        },
      ),
    );
  }
}
