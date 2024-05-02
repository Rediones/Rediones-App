import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/api/profile_service.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart' as f;
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/widgets.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _emailControl = TextEditingController();
  final Map<String, String> _authDetails = {"email": "", "password": ""};
  bool _showPassword = false;

  void navigate(RedionesResponse<User?> result) {
    String location = Pages.home;
    saveAuthDetails(_authDetails, ref);
    ref.watch(userProvider.notifier).state = result.payload!;

    if (!result.payload!.isProfileComplete) {
      location = Pages.editProfile;
    }

    context.router.pushReplacementNamed(location);
  }

  void submit() {
    f.unFocus();
    FormState? currentState = _formKey.currentState;
    if (currentState != null) {
      if (!currentState.validate()) return;
      currentState.save();

      _login();
    }
  }

  void _login() {
   authenticate(_authDetails, Pages.login).then((result) {
      if (!mounted) return;

      f.showNewError(
          result.status == Status.failed
              ? result.message
              : "Welcome, ${result.payload!.username}",
          context);

      if (result.status == Status.success) {
        _controller.clear();
        _emailControl.clear();
        navigate(result);
      } else {
        Navigator.of(context).pop();
      }
    });

    showDialog(
      useSafeArea: true,
      barrierDismissible: false,
      context: context,
      builder: (_) => const Popup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 63.h,
              ),
              Text(
                "Rediones",
                style: context.textTheme.titleLarge!.copyWith(color: appRed),
              ),
              Text(
                "Welcome back",
                style: context.textTheme.bodyMedium,
              ),
              SizedBox(height: 32.h),
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Username or Email",
                          style: context.textTheme.labelSmall,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
                        width: 390.w,
                        height: 40.h,
                        controller: _emailControl,
                        type: TextInputType.emailAddress,
                        onValidate: (value) {
                          if (value!.isEmpty || !value.contains("@")) {
                            f.showNewError("Invalid Email Address", context);
                            return '';
                          }
                          return null;
                        },
                        onSave: (value) => _authDetails["email"] = value!,
                        hint: "Enter your email here",
                      ),
                      SizedBox(height: 10.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Password",
                          style: context.textTheme.labelSmall,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
                        width: 390.w,
                        height: 40.h,
                        obscure: !_showPassword,
                        controller: _controller,
                        type: TextInputType.text,
                        suffix: GestureDetector(
                          child: AnimatedSwitcherTranslation.right(
                            duration: const Duration(milliseconds: 500),
                            child: Icon(
                              !_showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 18.r,
                              key: ValueKey<bool>(_showPassword),
                              color: Colors.grey,
                            ),
                          ),
                          onTap: () =>
                              setState(() => _showPassword = !_showPassword),
                        ),
                        onValidate: (value) {
                          if (value!.length < 6) {
                            f.showNewError(
                                "Password is too short. Use at least 6 characters", context);
                            return '';
                          }
                          return null;
                        },
                        onSave: (value) => _authDetails["password"] = value!,
                        hint: "********",
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Forgot Password? ",
                            style: context.textTheme.labelSmall,
                          ),
                          Text(
                            "Click Here",
                            style: context.textTheme.bodySmall?.copyWith(
                                color: appRed, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(390.w, 40.h),
                          backgroundColor: appRed,
                          elevation: 1.0,
                        ),
                        onPressed: submit,
                        child: Text(
                          "Sign In",
                          style: context.textTheme.bodyLarge!.copyWith(
                              color: theme, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Don't have an account?",
                              style: context.textTheme.labelSmall),
                          SizedBox(
                            width: 5.w,
                          ),
                          GestureDetector(
                            onTap: () => context.router
                                .pushReplacementNamed(Pages.register),
                            child: Text(
                              "Register",
                              style: context.textTheme.labelSmall?.copyWith(
                                  color: appRed, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ],
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
