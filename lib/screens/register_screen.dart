import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  static const routeName = '/register-screen';

  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
      borderRadius: BorderRadius.circular(8),
    );

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
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: boxDecoration,
                  child: TextFormField(
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_2_rounded),
                      prefixIconColor: Colors.black,
                      hintText: 'First Name',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: textFieldPadding,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: boxDecoration,
                  child: TextFormField(
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_2_rounded),
                      prefixIconColor: Colors.black,
                      hintText: 'Last Name',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: textFieldPadding,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: boxDecoration,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_rounded),
                      prefixIconColor: Colors.black,
                      hintText: 'Email',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: textFieldPadding,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: boxDecoration,
                  child: TextFormField(
                    cursorColor: Theme.of(context).primaryColor,
                    obscureText: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock_rounded),
                      prefixIconColor: Colors.black,
                      hintText: 'Password',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: textFieldPadding,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: boxDecoration,
                  child: TextFormField(
                    cursorColor: Theme.of(context).primaryColor,
                    obscureText: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock_rounded),
                      prefixIconColor: Colors.black,
                      hintText: 'Confirm Password',
                      border: InputBorder.none,
                    ),
                  ),
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
                  onTap: () {},
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
    );
  }
}
