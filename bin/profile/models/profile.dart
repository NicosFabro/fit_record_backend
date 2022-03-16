import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String email;
  final String phone;
  final String firstName;
  final String lastName;
  final String nickname;
  final String image;
  final DateTime? dateRegistered;

  Profile({
    required this.id,
    required this.email,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.image,
    required this.dateRegistered,
  });

  @override
  List<Object?> get props => [];
}
