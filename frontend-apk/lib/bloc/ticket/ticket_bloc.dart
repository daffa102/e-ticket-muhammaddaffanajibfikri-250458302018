import 'package:flutter_bloc/flutter_bloc.dart';
import './ticket_event.dart';
import './ticket_state.dart';
import '../../repositories/ticket_repositories.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketRepository ticketRepository;

  TicketBloc({required this.ticketRepository}) : super(TicketInitial()) {
    on<LoadTickets>(_onLoadTickets);
    on<RefreshTickets>(_onRefreshTickets);
    on<SearchTickets>(_onSearchTickets);
  }

  Future<void> _onLoadTickets(
    LoadTickets event,
    Emitter<TicketState> emit,
  ) async {
    // 1. Kabar Pertama: "Mohon tunggu, sedang memuat..."
    emit(TicketLoading());
    // -> UI akan menampilkan Loading Spinner (CircularProgressIndicator)
    try {
      // (Proses pengambilan data di belakang layar...)
      final tickets = await ticketRepository.getTickets();
      // 2. Kabar Kedua: "Berhasil! Ini daftar tiketnya."
      emit(TicketLoaded(tickets: tickets));
      // -> UI akan menampilkan Daftar Tiket (ListView)
    } catch (e) {
      // 3. Kabar Alternatif: "Maaf, ada error."
      emit(TicketError(message: e.toString()));
      // -> UI akan menampilkan Pesan Error (SnackBar / Text Merah)
    }
  }

  Future<void> _onRefreshTickets(
    RefreshTickets event,
    Emitter<TicketState> emit,
  ) async {
    emit(TicketLoading());
    try {
      final tickets = await ticketRepository.getTickets();
      emit(TicketLoaded(tickets: tickets));
    } catch (e) {
      emit(TicketError(message: e.toString()));
    }
  }

  Future<void> _onSearchTickets(
    SearchTickets event,
    Emitter<TicketState> emit,
  ) async {
    emit(TicketLoading());
    try {
      final tickets = await ticketRepository.searchTickets(event.query);
      emit(TicketLoaded(tickets: tickets));
    } catch (e) {
      emit(TicketError(message: e.toString()));
    }
  }
}
