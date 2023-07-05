class Login {
  final String email;
  final String password;

  Login({required this.email, required this.password});

  Login.fromMap(Map<String, dynamic> json)
      : email = json['email'],
        password = json['password'];

  Map<String, dynamic> toMap() => {
        'email': email,
        'password': password,
      };
}
