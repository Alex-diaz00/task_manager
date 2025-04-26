import 'package:task_manager/features/project/domain/entities/member.dart';

class MemberModel extends Member {
  const MemberModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
