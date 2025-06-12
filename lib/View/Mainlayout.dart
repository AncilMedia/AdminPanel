import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../View_model/Sidebar_provider.dart';
import '../View/Home_page.dart';
import '../View/Events.dart';
import '../View/Sermons.dart';
import 'Apps_page/App_drawer.dart';
import 'Giving.dart';
import 'Apps_page/Apps.dart';
import 'Responsive/Responsive_page.dart';
import 'Sidebar.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SidebarProvider>(context);
    final selectedRoute = provider.selectedRoute;
    final isDesktop = Responsive.isDesktop(context);

    Widget content;

    if (selectedRoute == '/apps') {
      content = const Apps(); // will handle its own sub-navigation
    } else {
      content = getSelectedPage(selectedRoute);
    }

    return Scaffold(
      appBar: isDesktop || selectedRoute == '/apps'
          ? null
          : AppBar(
        title: const Text("Dashboard"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: isDesktop || selectedRoute == '/apps'
          ? null
          : const Drawer(child: AppSidebar()),
      body: Row(
        children: [
          if (isDesktop && selectedRoute != '/apps') const AppSidebar(),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: content,
            ),
          ),
        ],
      ),
    );
  }

  Widget getSelectedPage(String route) {
    switch (route) {
      case '/events':
        return const Events();
      case '/sermons':
        return const Sermons();
      case '/giving':
        return const Giving();
      case '/home':
      default:
        return const HomePage();
    }
  }
}





