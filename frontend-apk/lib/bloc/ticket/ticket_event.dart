import 'package:equatable/equatable.dart';

abstract class TicketEvent extends Equatable {
  const TicketEvent();

  @override
  List<Object?> get props => [];
}

class LoadTickets extends TicketEvent {
  const LoadTickets();
}

class RefreshTickets extends TicketEvent {
  const RefreshTickets();
}
