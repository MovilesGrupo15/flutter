class User {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;

  User({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
  });

  factory User.fromFirebase(Map<String, dynamic> json) {
    return User(
      id: json['uid'],
      email: json['email'],
      name: json['displayName'],
      photoUrl: json['photoURL'],
    );
  }
}
