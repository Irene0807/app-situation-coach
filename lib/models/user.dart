class User {
  final String uid;
  final String name;
  final int age;
  final String email;

  User({
    required this.uid,
    required this.name,
    required this.age,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'email': email,
    };
  }

  factory User.fromMap(String uid, Map<String, dynamic> map) {
    return User(
      uid: uid,
      name: map['name'] as String? ?? '',
      age: (map['age'] is int) ? map['age'] as int : int.tryParse('${map['age']}') ?? 0,
      email: map['email'] as String? ?? '',
    );
  }
}
