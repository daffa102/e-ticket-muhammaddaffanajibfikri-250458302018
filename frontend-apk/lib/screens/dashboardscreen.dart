import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_ticket/bloc/auth_bloc.dart';
import 'package:e_ticket/bloc/auth_event.dart';
import 'package:e_ticket/bloc/auth_state.dart';
import 'package:e_ticket/bloc/ticket/ticket_bloc.dart';
import 'package:e_ticket/bloc/ticket/ticket_state.dart';
import 'package:e_ticket/bloc/ticket/ticket_event.dart';

import './dashboard/widgets/event_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/login', (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Tickets'),
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(const LogoutRequested());
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: BlocBuilder<TicketBloc, TicketState>(
          builder: (context, state) {
            if (state is TicketLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TicketLoaded) {
              if (state.tickets.isEmpty) {
                return const Center(child: Text('No tickets available.'));
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<TicketBloc>().add(const LoadTickets());
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = state.tickets[index];
                    return EventCard(ticket: ticket);
                  },
                ),
              );
            } else if (state is TicketError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}'),
                    ElevatedButton(
                      onPressed: () {
                        context.read<TicketBloc>().add(const LoadTickets());
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('Welcome!'));
          },
        ),
      ),
    );
  }
}
