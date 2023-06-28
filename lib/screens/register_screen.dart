import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register-screen';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final nameValidate = ValidationBuilder()
      .maxLength(30)
      .required('Required')
      .regExp(RegExp(r'^[a-zA-Z]+$'), 'Invalid Name')
      .build();
  final emailValidate =
      ValidationBuilder().required('Required').email('Invalid Email').build();
  final passwordValidate = ValidationBuilder()
      .minLength(8, 'Password must be at least 8 characters')
      .required('Required')
      .build();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    );

    final fillColor = Theme.of(context).colorScheme.secondary.withOpacity(0.7);

    const textFieldPadding = EdgeInsets.symmetric(horizontal: 26.0);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
          ),
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Image.asset('assets/images/key.png'),
                ),
                const SizedBox(height: 30),
                Column(
                  children: const [
                    Text(
                      'SnapDrive',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      'Join the SnapDrive Community!',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: textFieldPadding,
                  child: TextFormField(
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      border: outlineInputBorder,
                      fillColor: fillColor,
                      filled: true,
                      prefixIcon: const Icon(Icons.person_2_rounded),
                      prefixIconColor: Colors.black,
                      hintText: 'First Name',
                    ),
                    controller: firstNameController,
                    validator: nameValidate,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: textFieldPadding,
                  child: TextFormField(
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      border: outlineInputBorder,
                      fillColor: fillColor,
                      filled: true,
                      prefixIcon: const Icon(Icons.person_2_rounded),
                      prefixIconColor: Colors.black,
                      hintText: 'Last Name',
                    ),
                    controller: lastNameController,
                    validator: nameValidate,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: textFieldPadding,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      border: outlineInputBorder,
                      fillColor: fillColor,
                      filled: true,
                      prefixIcon: const Icon(Icons.email_rounded),
                      prefixIconColor: Colors.black,
                      hintText: 'Email',
                    ),
                    controller: emailController,
                    validator: emailValidate,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: textFieldPadding,
                  child: TextFormField(
                    cursorColor: Theme.of(context).primaryColor,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: outlineInputBorder,
                      fillColor: fillColor,
                      filled: true,
                      prefixIcon: const Icon(Icons.lock_rounded),
                      prefixIconColor: Colors.black,
                      hintText: 'Password',
                    ),
                    controller: passwordController,
                    validator: passwordValidate,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: textFieldPadding,
                  child: TextFormField(
                    cursorColor: Theme.of(context).primaryColor,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: outlineInputBorder,
                      fillColor: fillColor,
                      filled: true,
                      prefixIcon: const Icon(Icons.lock_rounded),
                      prefixIconColor: Colors.black,
                      hintText: 'Confirm Password',
                    ),
                    controller: confirmPasswordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'The field is required';
                      }
                      if (value != passwordController.text) {
                        return 'Password doesn\'t match';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 26,
                    right: 26,
                    bottom: 20,
                  ),
                  child: InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {}
                    },
                    borderRadius: BorderRadius.circular(8),
                    overlayColor: MaterialStateProperty.all(Colors.blue),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withAlpha(240),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
