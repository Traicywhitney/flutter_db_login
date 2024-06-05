import 'package:flutter/material.dart';
import 'package:flutter_db_login/database_helper.dart';
import 'package:flutter_db_login/userDetails_list_screen.dart';
import 'package:flutter_db_login/register_form_screen.dart';
import 'package:intl/intl.dart';

class LoginScreen extends StatefulWidget {
   LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formField = GlobalKey<FormState>();

  final _userNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _passwordController = TextEditingController();

  bool passwordToggle = true;
  DateTime _dateTime = DateTime.now();
  late DatabaseHelper _databaseHelper;

  Future<void> _initializeDatabase() async {
    _databaseHelper = DatabaseHelper();
    await _databaseHelper.initialization();
  }

  @override
  void initState() {
    super.initState();
    _initializeDatabase();

  }

  _selectTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        _dobController.text = DateFormat("dd-MM-yyyy").format(_dateTime);
      });
    }
  }
  Future<void> _loginUser() async {
    if (_formField.currentState!.validate()) {
      if (_databaseHelper == null) {
        return;
      }

      bool loginSuccessful = await _databaseHelper.checkLoginCredentials(
        _userNameController.text,
        _passwordController.text,
        _dobController.text
      );

      if (loginSuccessful) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => UserDetailsScreen(userName: _userNameController.text),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid username or password'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formField,
              child: Column(
                children: [
                  TextFormField(
                    controller: _userNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: 'Enter Name',
                      hintText: 'Enter Name',
                    ),
                    validator: (value) {
                      if(value!.isEmpty){
                        return'Enter your name or email';
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _dobController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: 'Enter dob',
                      hintText: 'Date of birth',
                      prefixIcon: InkWell(
                          onTap: () {
                              _selectTodoDate(context);
                          },
                          child: Icon(Icons.calendar_today)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your Date of birth';
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: passwordToggle,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: 'Enter password',
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            passwordToggle = !passwordToggle;
                          });
                        },
                        child: Icon(passwordToggle
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Password';
                      } else if (_passwordController.text.length < 8) {
                        return 'Password length should be more than 8 character.';
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _loginUser();
                      print('------>Login');
                    },
                    child: Text('Login'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterFormScreen()));
                        print('------>Register');
                      },
                      child: Text('Register'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
