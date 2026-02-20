import 'package:e_ticket/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_ticket/screens/auth/login_screen.dart';
import 'package:e_ticket/screens/auth/register_screen.dart';
import 'package:e_ticket/screens/dashboardscreen.dart';
import 'package:e_ticket/bloc/auth_bloc.dart';
import 'package:e_ticket/bloc/auth_event.dart';
import 'package:e_ticket/bloc/ticket/ticket_bloc.dart';
import 'package:e_ticket/bloc/ticket/ticket_event.dart';
import 'package:e_ticket/repositories/ticket_repositories.dart';

void main() {
  runApp(const ETicketingApp());
}

class ETicketingApp extends StatelessWidget {
  const ETicketingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider(create: (context) => TicketRepository())],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc()..add(const CheckAuthStatus()),
          ),
          BlocProvider(
            create: (context) =>
                TicketBloc(ticketRepository: context.read<TicketRepository>())
                  ..add(const LoadTickets()),
          ),
        ],
        child: MaterialApp(
          title: 'E-Ticketing',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return const DashboardScreen();
              } else if (state is AuthUnauthenticated || state is AuthInitial) {
                return const LoginScreen();
              } else if (state is AuthLoading) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (state is AuthError) {
                return Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${state.message}'),
                        ElevatedButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                              const CheckAuthStatus(),
                            );
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              // Fallback to avoid "body might complete normally" error
              return const LoginScreen();
            },
          ),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/dashboard': (context) => const DashboardScreen(),
          },
        ),
      ),
    );
  }
}
