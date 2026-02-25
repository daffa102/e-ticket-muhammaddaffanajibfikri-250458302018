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
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search tickets...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      context.read<TicketBloc>().add(const LoadTickets());
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  context.read<TicketBloc>().add(SearchTickets(query: value));
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<TicketBloc, TicketState>(
                builder: (context, state) {
                  if (state is TicketLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TicketLoaded) {
                    if (state.tickets.isEmpty) {
                      return const Center(child: Text('No tickets found.'));
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        if (_searchController.text.isEmpty) {
                          context.read<TicketBloc>().add(const LoadTickets());
                        } else {
                          context.read<TicketBloc>().add(
                            SearchTickets(query: _searchController.text),
                          );
                        }
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                              if (_searchController.text.isEmpty) {
                                context.read<TicketBloc>().add(
                                  const LoadTickets(),
                                );
                              } else {
                                context.read<TicketBloc>().add(
                                  SearchTickets(query: _searchController.text),
                                );
                              }
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
          ],
        ),
      ),
    );
  }
}
