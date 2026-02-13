import 'package:ancilmediaadminpanel/View/Mainlayout.dart';
import 'package:ancilmediaadminpanel/View/Login_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainLayout(initialPage: 'home'),
    ),
    GoRoute(
      path: '/events',
      builder: (context, state) => const MainLayout(initialPage: 'events'),
    ),
    GoRoute(
      path: '/apps',
      builder: (context, state) => const MainLayout(initialPage: 'apps'),
    ),
    GoRoute(
      path: '/media',
      builder: (context, state) => const MainLayout(initialPage: 'media'),
    ),
    GoRoute(
      path: '/sermons',
      builder: (context, state) => const MainLayout(initialPage: 'sermons'),
    ),
    GoRoute(
      path: '/giving',
      builder: (context, state) => const MainLayout(initialPage: 'giving'),
    ),
    GoRoute(
      path: '/user',
      builder: (context, state) => const MainLayout(initialPage: 'user'),
    ),
    GoRoute(
      path: '/organization',
      builder: (context, state) => const MainLayout(initialPage: 'organization'),
    ),
    GoRoute(
      path: '/applications',
      builder: (context, state) => const MainLayout(initialPage: 'applications'),
    ),
    GoRoute(
      path: '/pushnotification',
      builder: (context, state) => const MainLayout(initialPage: 'pushnotification'),
    ),
    GoRoute(
      path: '/role',
      builder: (context, state) => const MainLayout(initialPage: 'role'),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const MainLayout(initialPage: 'profile'),
    ),
    GoRoute(
      path: '/notification',
      builder: (context, state) => const MainLayout(initialPage: 'notification'),
    ),
    GoRoute(
      path: '/sidebar',
      builder: (context, state) => const MainLayout(initialPage: 'sidebar'),
    ),
    GoRoute(
      path: '/navigation',
      builder: (context, state) => const MainLayout(initialPage: 'navigation'),
    ),
  ],
);
