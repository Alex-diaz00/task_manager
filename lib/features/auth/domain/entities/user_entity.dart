import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String token;

  const UserEntity({
    required this.id,
    required this.email,
    required this.token,
    this.name,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name, 'token': token};
  }

  @override
  List<Object?> get props => [id, email, name, token];
}
