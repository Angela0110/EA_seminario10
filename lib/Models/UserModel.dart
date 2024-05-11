class User {
  final String? id;
  final String first_name;
  final String last_name;
  final String gender;
  final String role;
  final String password;
  final String email;
  final String phone_number;
  final String birth_date;

  User({
    this.id,
    required this.first_name,
    required this.last_name,
    required this.gender,
    required this.role,
    required this.password,
    required this.email,
    required this.phone_number,
    required this.birth_date,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': first_name,
      'last_name': last_name,
      'gender': gender,
      'role': role,
      'password': password,
      'email': email,
      'phone_number': phone_number,
      'birth_date': birth_date,
    };
  }

   factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      gender: json['gender'],
      role: json['role'],
      password: json['password'],
      email: json['email'],
      phone_number: json['phone_number'],
      birth_date: json['birth_date'],
    );
  }
  
}
