import 'package:equatable/equatable.dart';

class Ticket extends Equatable {
  final String id;
  final String title;
  final String date;
  final String time;
  final String location;
  final int price;
  final String status;
  final String imageUrl;

  const Ticket({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.price,
    required this.status,
    required this.imageUrl,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] ?? '',
      title: json['title'] ?? json['event_name'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      location: json['location'] ?? '',
      price: json['price'] ?? 0,
      status: json['status'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'time': time,
      'location': location,
      'price': price,
      'status': status,
      'image_url': imageUrl,
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    date,
    time,
    location,
    price,
    status,
    imageUrl,
  ];
}
