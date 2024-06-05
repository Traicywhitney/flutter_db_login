import 'package:flutter/material.dart';
import 'package:flutter_db_login/database_helper.dart';
import 'package:flutter_db_login/user_details_model.dart';

import 'main.dart';

class UserDetailsScreen extends StatefulWidget {
  final String userName;
  const UserDetailsScreen({super.key, required this.userName});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late List<UserDetailsModel> _userNameList;

  @override
  void initState() {
    super.initState();
    getAllLoginDetails();
  }

  getAllLoginDetails() async {
    _userNameList = <UserDetailsModel>[];

    var loginDetailsRecords =
        await dbHelper.queryAllRows(DatabaseHelper.loginDetailsTable);

    loginDetailsRecords.forEach((loginDetail) {
      setState(() {
        // Display in log
        print(loginDetail['id']);
        print(loginDetail['_userName']);
        print(loginDetail['_dob']);
        print(loginDetail['_password']);
        print(loginDetail['_emailId']);
        print(loginDetail['_mobileNo']);

        // Data model

        var loginDetailModel = UserDetailsModel(
          loginDetail['id'],
          loginDetail['_userName'],
          loginDetail['_dob'],
          loginDetail['_password'],
          loginDetail['_emailId'],
          loginDetail['_mobileNo'],
        );

        // Add in List
        if (widget.userName == loginDetail['_userName']) {
          _userNameList.add(loginDetailModel);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Screen'),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                itemCount: _userNameList.length,
                itemBuilder: (BuildContext, int index) {
                  return InkWell(
                    onTap: () {
                      print('------------->Edit or Delete: Send Data');
                      print(_userNameList[index].id);
                      print(_userNameList[index].userName);
                      print(_userNameList[index].dob);
                      print(_userNameList[index].password);
                      print(_userNameList[index].emailId);
                      print(_userNameList[index].mobileNo);
                    },
                    child: ListTile(
                      title: Text(_userNameList[index].userName),
                      subtitle: Column(
                        children: [
                          Text(_userNameList[index].dob),
                          Text(_userNameList[index].emailId),
                          Text(_userNameList[index].mobileNo)
                        ],
                      ),
                    ),
                  );
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
