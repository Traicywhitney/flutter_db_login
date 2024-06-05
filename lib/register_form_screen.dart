import 'package:flutter/material.dart';
import 'package:flutter_db_login/database_helper.dart';
import 'package:flutter_db_login/login_screen.dart';
import 'package:flutter_db_login/main.dart';
import 'package:intl/intl.dart';

class RegisterFormScreen extends StatefulWidget {
  const RegisterFormScreen({super.key});

  @override
  State<RegisterFormScreen> createState() => _RegisterFormScreenState();
}

class _RegisterFormScreenState extends State<RegisterFormScreen> {
  final _formField = GlobalKey<FormState>();
  var _userNameController = TextEditingController();
  var _passwordController = TextEditingController();
  var _dobController = TextEditingController();
  var _emailIdController = TextEditingController();
  var _mobileNumberController = TextEditingController();

  bool passwordToggle = true;
  DateTime _dateTime = DateTime.now();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Form'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formField,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'UserName',
                      hintText: 'Enter UserName',
                      prefixIcon: Icon(Icons.person)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter your name or email';
                    }
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: _dobController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Date of Birth',
                    hintText: 'Enter DOB',
                    prefixIcon: InkWell(
                      onTap: () {
                        _selectTodoDate(context);
                      },
                      child: Icon(Icons.calendar_today),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter your Date of birth';
                    }
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: passwordToggle,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'PassWord',
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
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: _emailIdController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'emailId',
                      hintText: 'Enter emailId',
                      prefixIcon: Icon(Icons.email)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter your emailId';
                    }
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: _mobileNumberController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'mobile No',
                      hintText: 'Enter Mobile Number',
                      prefixIcon: Icon(Icons.mobile_friendly)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter your mobile number';
                    }
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    _register();
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void _register() async {
    print('----------->Save');
    print('-------------> User Name: ${_userNameController.text}');
    print('-------------> DOB: ${_dobController.text}');
    print('-------------> Password: ${_passwordController.text}');
    print('-------------> EmailId: ${_emailIdController.text}');
    print('-------------> columnMobileNO: ${_mobileNumberController.text}');

    Map<String, dynamic> row = {
      DatabaseHelper.columnUserName: _userNameController.text,
      DatabaseHelper.columnDOB: _dobController.text,
      DatabaseHelper.columnPassword: _passwordController.text,
      DatabaseHelper.columnEmailId: _emailIdController.text,
      DatabaseHelper.columnMobileNO: _mobileNumberController.text,
    };

    final result = await dbHelper.insertRegisterForm(
        row, DatabaseHelper.loginDetailsTable);

    debugPrint('--------> Inserted Row Id: $result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'Saved');
    }

    setState(() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(message)));
  }
}
