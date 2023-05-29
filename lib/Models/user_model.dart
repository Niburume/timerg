class UserModel {
  final String? id;
  final String email;
  final String password;
  final String? name;
  final List<String>? projects;

  UserModel({
    this.id,
    required this.email,
    required this.password,
    this.name,
    this.projects,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    List<String> projects = List<String>.from(json['projects'] ?? []);

    return UserModel(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      name: json['name'],
      projects: projects,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'name': name ?? '',
      'projects': projects ?? [],
    };
  }
}
