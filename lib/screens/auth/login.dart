import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:rediones/api/file_handler.dart';
import 'package:rediones/api/user_service.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart' as f;
import 'package:rediones/tools/providers.dart';
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
  bool _showPassword = false, validPassword = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (!validPassword && _controller.text.length >= 6) {
        setState(() => validPassword = true);
      } else if (validPassword && _controller.text.length < 6) {
        setState(() => validPassword = false);
      }
    });

    Future.delayed(
      const Duration(milliseconds: 500),
      () => FlutterNativeSplash.remove(),
    );
  }

  void navigate(RedionesResponse<User?> result) {
    saveToDatabase(result.payload!);
    saveAuthDetails(_authDetails, ref);
    ref.watch(userProvider.notifier).state = result.payload!;
    context.router.pushReplacementNamed(Pages.home);
  }

  Future<void> saveToDatabase(User user) async {
    Isar isar = GetIt.I.get();
    await isar.writeTxn(() async {
      await isar.users.put(user);
      FileHandler.saveString(userIsarId, user.uuid);
    });
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

      f.showToast(
          result.status == Status.failed
              ? result.message
              : "Welcome, ${result.payload!.username}",
          context);

      if (result.status == Status.success) {
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
    bool darkTheme = context.isDark;

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
              Text("Log In", style: context.textTheme.titleLarge),
              Text(
                "Hi, Welcome back.",
                style: context.textTheme.bodyLarge,
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
                      SpecialForm(
                        width: 390.w,
                        height: 40.h,
                        controller: _emailControl,
                        fillColor: darkTheme ? neutral2 : authFieldBackground,
                        borderColor: Colors.transparent,
                        type: TextInputType.emailAddress,
                        prefix: Icon(
                          Icons.mail_outline_rounded,
                          size: 18.r,
                          color: darkTheme ? offWhite : primaryPoint2,
                        ),
                        onValidate: (value) {
                          if (value!.isEmpty || !value.contains("@")) {
                            f.showToast("Invalid Email Address", context);
                            return '';
                          }
                          return null;
                        },
                        onSave: (value) => _authDetails["email"] = value!,
                        hint: "Email",
                      ),
                      SizedBox(height: 10.h),
                      SpecialForm(
                        width: 390.w,
                        height: 40.h,
                        obscure: !_showPassword,
                        controller: _controller,
                        fillColor: darkTheme ? neutral2 : authFieldBackground,
                        borderColor: Colors.transparent,
                        type: TextInputType.text,
                        prefix: Icon(
                          Icons.lock_outline_rounded,
                          size: 18.r,
                          color: darkTheme ? offWhite : primaryPoint2,
                        ),
                        suffix: GestureDetector(
                          child: AnimatedSwitcherTranslation.right(
                            duration: const Duration(milliseconds: 500),
                            child: Icon(
                              !_showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 18.r,
                              key: ValueKey<bool>(_showPassword),
                              color: darkTheme ? offWhite : primaryPoint2,
                            ),
                          ),
                          onTap: () =>
                              setState(() => _showPassword = !_showPassword),
                        ),
                        onValidate: (value) {
                          if (value!.length < 6) {
                            f.showToast(
                                "Password is too short. Use at least 6 characters",
                                context);
                            return '';
                          }
                          return null;
                        },
                        onSave: (value) => _authDetails["password"] = value!,
                        hint: "Password",
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Password must be at least 6 characters",
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: !validPassword ? appRed : possibleGreen,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(390.w, 40.h),
                          backgroundColor: appRed,
                          elevation: 1.0,
                        ),
                        onPressed: submit,
                        child: Text(
                          "Login",
                          style: context.textTheme.titleSmall!.copyWith(
                            color: theme,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Forgot Password? ",
                            style: context.textTheme.bodyLarge,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            "Click Here",
                            style: context.textTheme.bodyLarge!.copyWith(
                              color: appRed,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      Center(
                        child: Text(
                          "- OR -",
                          style: context.textTheme.titleLarge,
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0.0,
                          fixedSize: Size(390.w, 40.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.h),
                            side: const BorderSide(color: neutral),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/google.png"),
                            SizedBox(width: 10.w),
                            Text(
                              "log in with Google",
                              style: context.textTheme.bodyLarge,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: context.textTheme.bodyLarge,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          GestureDetector(
                            onTap: () => context.router
                                .pushReplacementNamed(Pages.register),
                            child: Text(
                              "Sign Up",
                              style: context.textTheme.bodyLarge!.copyWith(
                                color: appRed,
                                fontWeight: FontWeight.w600,
                              ),
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
