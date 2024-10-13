import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';
import '../../Routes/navigation_methods.dart';
import '../../Utilis/config.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future<bool> isValidUser() async {
    var url = Uri.https(baseUrl, loginUrl);
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
    });
    var response = await https.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var decodedJson = json.decode(response.body);
      //print(decodedJson);
      accessToken = decodedJson["data"]["accessToken"];
      return true;
    } else {
      return false;
    }
  }

  void trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    //final isValid = true;
    if (isValid) {
      _formKey.currentState!.save();
      if (await isValidUser()) {
        navigateToDashboard(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid Credentials"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1511652019870-fbd8713560bf?q=80&w=1946&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              // Replace with your image URL
              fit: BoxFit.cover,
            ),
          ),
          // Transparent Login Container
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.all(30),
              width: 400,
              color: Colors.white.withOpacity(0.8),
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Login Account',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Please fill username and password to sign into your account.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      key: const ValueKey("email"),
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter Email address";
                        }
                        if (!value.contains("@")) {
                          return "Please enter valid email address ";
                        }
                        if (!value.contains(".com")) {
                          return "Please enter valid email address ";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              10,
                            ),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        suffixIcon: Icon(
                          Icons.person,
                          color: Theme.of(context).primaryColor,
                        ),
                        hintText: "Email",
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      key: const ValueKey("password"),
                      controller: passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter password";
                        }
                        return null;
                      },
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              10,
                            ),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        hintText: "Password",
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: trySubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('LOG IN'),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
