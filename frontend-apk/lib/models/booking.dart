import 'package:equatable/equatable.dart';

class Booking extends Equatable {
  final String id;
  final String ticketId;
  final String userId;
  final int quantity;
  final int totalPrice;
  final String status;
  final String createdAt;

  const Booking({
    required this.id,
    required this.ticketId,
    required this.userId,
    required this.quantity,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ticket_id': ticketId,
      'user_id': userId,
      'quantity': quantity,
      'total_price': totalPrice,
      'status': status,
      'created_at': createdAt,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] ?? '',
      ticketId: map['ticket_id'] ?? '',
      userId: map['user_id'] ?? '',
      quantity: map['quantity'] ?? 0,
      totalPrice: map['total_price'] ?? 0,
      status: map['status'] ?? '',
      createdAt: map['created_at'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
    id,
    ticketId,
    userId,
    quantity,
    totalPrice,
    status,
    createdAt,
  ];
}
