class Register {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  Register({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  Register.fromMap(Map<String, dynamic> map)
      : firstName = map['first_name'],
        lastName = map['last_name'],
        email = map['email'],
        password = map['password'];

  Map<String, dynamic> toMap() => {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
      };
}
