import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menu_plus/screens/homepage/home_screen.dart';
import 'package:menu_plus/screens/loginpage/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = "https://ozmzpnayygajicxafxfm.supabase.co";
const supabaseKey = "sb_publishable_zTr-mF2b6CCWgssJZEgMjQ_vUwB62oJ";
const supabaseFunctionsVersion = 1.0;
const sqliteTableVersion = 1.0;

void main() async {
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  runApp(const MainApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(path: '/', redirect: (_, __) => '/home'),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
  ],
  redirect: (context, state) async {
    //TODO
    // Add a versioning check

    final session = Supabase.instance.client.auth.currentSession;
    final isLoggingIn = state.matchedLocation.startsWith('/login');

    if (session == null && !isLoggingIn) {
      return '/login';
    }

    if (session != null && isLoggingIn) {
      return '/home';
    }

    return null;
  },
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(title: 'MenuPlus', routerConfig: _router);
  }
}
