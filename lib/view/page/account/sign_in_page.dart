import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/constants.dart';
import '../../../model/user/user.dart';
import '../../../service/user/user_service.dart';
import '../../../state/user_state.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  RegExp phoneExp =
      RegExp(r'^((13\d)|(14\d)|(15\d)|(16\d)|(17\d)|(18\d)|(19\d))\d{8}$');

  String _phoneNumber = "18348542622";
  String _password = "18348542622";
  bool _signInIng = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: FocusTraversalGroup(
              child: Column(
                children: [
                  const SizedBox(height: 30.0),
                  SizedBox(
                    width: loginInputWidth,
                    child: phoneNumBuild(),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: loginInputWidth,
                    child: passwordBuild(),
                  ),
                  const SizedBox(height: 40),
                  signInButtonBuild(),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  TextFormField phoneNumBuild() {
    return TextFormField(
      initialValue: _phoneNumber,
      onSaved: (newValue) => _phoneNumber = newValue!,
      validator: (value) {
        if (value!.isEmpty) {
          return "手机号不能为空";
        } else if (!phoneExp.hasMatch(value)) {
          return "手机号格式有误";
        }
        return null;
      },
      style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      decoration: InputDecoration(
        labelText: "账号",
        labelStyle:
            TextStyle(color: Theme.of(context).colorScheme.onBackground),
        hintText: "手机号",
        hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground.withAlpha(150)),
        border: OutlineInputBorder(
          //添加边框
          borderRadius: BorderRadius.circular(30.0),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          Icons.person,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  TextFormField passwordBuild() {
    return TextFormField(
      initialValue: _password,
      obscureText: true,
      onSaved: (newValue) => _password = newValue!,
      validator: (value) {
        if (value!.isEmpty) {
          return "密码不能为空";
        } else if (value.length < 8) {
          return "密码长度最小为8";
        }
        return null;
      },
      style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      decoration: InputDecoration(
        labelText: "密码",
        labelStyle:
            TextStyle(color: Theme.of(context).colorScheme.onBackground),
        hintText: "密码",
        hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground.withAlpha(150)),
        border: OutlineInputBorder(
          //添加边框
          borderRadius: BorderRadius.circular(30.0),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          Icons.password,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  signInButtonBuild() {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Selector<UserState, UserState>(
      selector: (context, userState) => userState,
      shouldRebuild: (pre, next) => false,
      builder: (context, userState, child) {
        return SizedBox(
          height: 46,
          width: loginInputWidth,
          child: TextButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
                //登录中为灰色
                backgroundColor: MaterialStateProperty.all(
                    _signInIng ? Colors.blue.withAlpha(150) : Colors.blue)),
            //登录中不可点击
            onPressed: _signInIng
                ? null
                : () async {
                    _formKey.currentState?.save();
                    //执行验证
                    if (_formKey.currentState!.validate()) {
                      //加载
                      setState(() {
                        _signInIng = true;
                      });
                      //
                      await signIn(userState);
                      if(mounted) Navigator.of(context).pop();
                    }
                  },
            child: _signInIng
                ? CupertinoActivityIndicator(color: colorScheme.onSurface)
                : const Text(
                    "登录",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
          ),
        );
      },
    );
  }

  //登录
  signIn(UserState userState) async {
    //发送请求
    try {
      User user = await UserService.signIn(_phoneNumber, _password);
      //赋值给全局变量
      userState.user = user;
    } on TimeoutException {
      log("请求超时");
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        _signInIng = false;
      });
    }
  }
}
