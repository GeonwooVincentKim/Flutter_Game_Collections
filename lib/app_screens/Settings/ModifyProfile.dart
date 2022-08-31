import 'package:flutter/material.dart';
import 'package:flutter_app/Provider/users.dart';
import 'package:flutter_app/model/Users.dart';
import 'package:flutter_app/shared/style.dart';
import 'package:flutter_app/widgets/Details/label.dart';
import 'package:provider/provider.dart';


class ModifyProfile extends StatefulWidget {
  @override
  _ModifyProfileState createState() => _ModifyProfileState();
}

class _ModifyProfileState extends State<ModifyProfile> {
  final _formModifyKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formUserData = {
    'username': '',
    'email': '',
    'imageURL': '',
    'Address': '',
  };

  @override
  void initState(){
    final User userList = Provider.of<UserProvider>(context, listen: false).userModify;
    if (userList != null){
      print("Initialize..");
      _formUserData['username'] = userList.username;
      _formUserData['email'] = userList.email;
      _formUserData['imageURL'] = userList.photoURL;
      _formUserData['Address'] = userList.userAddress;
    }
    super.initState();
  }

  Widget _buildModifyAppBar(){
    return AppBar(
      backgroundColor: appBarColor,
      title: Text("MODIFY PROFILE"),
      centerTitle: true,
    );
  }

  Widget _buildModifyBody(){
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight,
      color: backgroundColor,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(defaultPadding * 2),
            child: SingleChildScrollView(
              child: Form(
                key: _formModifyKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(label: "UserName"),
                    _buildUserNameModify(),
                    Label(label: "Email"),
                    _buildUserEmailModify(),
                    Label(label: "Image URL"),
                    _buildUserImageURLModify(),
                    Label(label: "Address"),
                    _buildUserAddressModify(),
                  ],
                )
              ),
            )
          ),
          _buildModifyForm(),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildModifyAppBar(),
      body: _buildModifyBody(),
    );
  }

  Widget _buildUserNameModify(){
    return Column(
      children: <Widget>[
        TextFormField(
          initialValue: _formUserData['username'],
          validator: (value){
            if(value.isEmpty) {return 'Please enter some text';}
            return null;
          },
          onSaved: (value) => _formUserData['username'] = value
        ),
        SizedBox(height: defaultPadding * 2),
      ],
    );
  }

  Widget _buildUserEmailModify(){
    return Column(
      children: <Widget>[
        TextFormField(
          initialValue: _formUserData['email'],
          keyboardType: TextInputType.emailAddress,
          validator: (value){
            Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            RegExp regex = new RegExp(pattern);
            if(value.isEmpty) {return 'Please enter some text';}
            else if(!regex.hasMatch(value)){return 'Please enter VALID E-Mail';}
            return null;
          },
          onSaved: (value) => _formUserData['email'] = value.replaceAll(new RegExp(r' '), ''),
        ),
        SizedBox(height: defaultPadding * 2),
      ],
    );
  }

  Widget _buildUserImageURLModify(){
    return Column(
      children: <Widget>[
        TextFormField(
          initialValue: _formUserData['imageURL'],
          validator: (value){
            if(value.isEmpty) {return 'Please enter some text';}
            return null;
          },
          onSaved: (value) => _formUserData['imageURL'] = value.replaceAll(new RegExp(r' '), ''),
        ),
        SizedBox(height: defaultPadding * 2),
      ],
    );
  }

  Widget _buildUserAddressModify(){
    return Column(
      children: <Widget>[
        TextFormField(
          initialValue: _formUserData['Address'],
          maxLines: 4,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87, width: 1.0)),
            labelText: '',
          ),
          validator: (value){
            if(value.isEmpty) {return 'Please enter some text';}
            return null;
          },
          onSaved: (value) => _formUserData['Address'] = value
        ),
        SizedBox(height: defaultPadding * 2),
      ],
    );
  }

  Widget _buildModifyForm(){
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: ContinuousRectangleBorder(side: BorderSide(color: lineColor)),
          foregroundColor: Colors.black87
        ),
        child: Padding(
          padding: EdgeInsets.all(defaultPadding / 2),
          child: Text("MODIFY", style: settingsMainFont),
        ),
        onPressed: () => _submitForm(context)
      ),
    );
  }

  void _submitForm(BuildContext context){
    if(!_formModifyKey.currentState.validate()) return;
    _formModifyKey.currentState.save();
    
    Provider.of<UserProvider>(context).editUser(_formUserData);
    Navigator.pushNamed(context, '/settings');
  }
}
