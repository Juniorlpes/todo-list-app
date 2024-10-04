import 'package:todo_list/app/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
    };
  }

  factory UserModel.fromFireData(String docId, Map<String, dynamic> map) {
    return UserModel(
      id: docId,
      email: map['email'] as String,
      name: map['name'] as String,
    );
  }
}
