import '../models/ticket.dart';

class TicketRepository {
  static const List<Ticket> _mockTickets = [
    Ticket(
      id: '1',
      title: 'Music Festival 2024',
      date: '2024-12-20',
      time: '19:00',
      location: 'Jakarta International Stadium',
      price: 500000,
      status: 'Active',
      imageUrl:
          'https://images.unsplash.com/photo-1459749411177-042180ce673c?q=80&w=1000',
    ),
    Ticket(
      id: '2',
      title: 'Tech Conference',
      date: '2024-11-15',
      time: '09:00',
      location: 'Convention Center',
      price: 250000,
      status: 'Used',
      imageUrl:
          'https://images.unsplash.com/photo-1540575861501-7cf05a4b125a?q=80&w=1000',
    ),
  ];

  Future<List<Ticket>> getTickets() async {
    // Simulasi fetch data dari API atau DB
    await Future.delayed(const Duration(seconds: 1));
    return _mockTickets;
  }

  Future<Ticket> getTicketDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockTickets.firstWhere((ticket) => ticket.id == id);
  }

  Future<List<Ticket>> searchTickets(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockTickets.where((ticket) {
      return ticket.title.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
