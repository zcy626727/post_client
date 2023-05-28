import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_client/screen/account/sign_in_or_up/sign_in_page.dart';
import 'package:post_client/screen/account/sign_in_or_up/sign_up_page.dart';

import '../../../util/responsive.dart';

class SignInOrUpScreen extends StatefulWidget {
  const SignInOrUpScreen({Key? key}) : super(key: key);

  @override
  State<SignInOrUpScreen> createState() => _SignInOrUpScreenState();
}

class _SignInOrUpScreenState extends State<SignInOrUpScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      //防止键盘越界
      resizeToAvoidBottomInset: false,
      appBar: Responsive.isSmallWithDevice(context)
          ? CupertinoNavigationBar(
              border: null,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.navigate_before_outlined),
                splashRadius: 1,
                iconSize: 26,
                color: colorScheme.onSurface,
                padding: const EdgeInsets.only(top: 4),
              ),
              middle: Text(
                "登录/注册",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: colorScheme.onSurface),
              ),
              backgroundColor: colorScheme.surface,
            )
          : null,
      body: Container(
        color: colorScheme.surface,
        child: Column(
          children: [
            //内容
            Expanded(
              child: Center(
                child: Container(
                  color: Colors.transparent,
                  margin: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.transparent,
                        height: 40,
                        width: 400,
                        margin: const EdgeInsets.only(left: 30, right: 30),
                        //切换
                        child: TabBar(
                          controller: _tabController,
                          //未选择时文字颜色
                          unselectedLabelColor: Colors.grey,
                          labelColor: colorScheme.primary,
                          indicatorSize: TabBarIndicatorSize.tab,
                          //指示器样式
                          tabs: const <Widget>[
                            Tab(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text("登录"),
                              ),
                            ),
                            Tab(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text("注册"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                          child: TabBarView(
                            controller: _tabController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: <Widget>[
                              const SignInPage(),
                              SignUpPage(
                                onSignUpSuccess: () {
                                  //注册成功后应该跳转到登录
                                  setState(() {
                                    _tabController?.index = 0;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
