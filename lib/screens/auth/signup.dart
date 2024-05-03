import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/api/profile_service.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart' as f;
import 'package:rediones/tools/widgets.dart';

class Signup extends ConsumerStatefulWidget {
  const Signup({super.key});

  @override
  ConsumerState<Signup> createState() => _SignupState();
}

class _SignupState extends ConsumerState<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _emailControl = TextEditingController();
  final TextEditingController _confirmControl = TextEditingController();
  final Map<String, String> _authDetails = {"email": "", "password": ""};
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  void submit() {
    f.unFocus();
    FormState? currentState = _formKey.currentState;
    if (currentState != null) {
      if (!currentState.validate()) return;

      currentState.save();

      register();
    }
  }

  void register() {
    authenticate(_authDetails, Pages.register).then(
      (result) {
        f.showNewError(
            result.status == Status.failed
                ? result.message
                : "Account Created Successfully",
            context);

        if (result.status == Status.success) {
          _controller.clear();
          _emailControl.clear();
          _confirmControl.clear();
          navigate(result);
        } else {
          Navigator.of(context).pop();
        }
      },
    );

    showDialog(
      useSafeArea: true,
      barrierDismissible: false,
      context: context,
      builder: (_) => const Popup(),
    );
  }

  void navigate(RedionesResponse<User?> result) {
    saveAuthDetails(_authDetails, ref);
    ref.watch(userProvider.notifier).state = result.payload!;
    ref.watch(isNewUserProvider.notifier).state = true;
    context.router.pushReplacementNamed(Pages.editProfile);
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
              Text("Sign Up", style: context.textTheme.titleMedium),
              Text(
                "Welcome to Rediones",
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
                        fillColor: authFieldBackground,
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
                        hint: "Email",
                      ),
                      SizedBox(height: 10.h),
                      SpecialForm(
                        obscure: !_showPassword,
                        width: 390.w,
                        height: 40.h,
                        fillColor: authFieldBackground,
                        controller: _controller,
                        type: TextInputType.text,
                        prefix: Icon(
                          Icons.lock_outline_rounded,
                          size: 18.r,
                          color: primaryPoint2,
                        ),
                        suffix: GestureDetector(
                          onTap: () =>
                              setState(() => _showPassword = !_showPassword),
                          child: AnimatedSwitcherTranslation.right(
                            duration: const Duration(milliseconds: 500),
                            child: Icon(
                              !_showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 18.r,
                              key: ValueKey<bool>(_showPassword),
                              color: primaryPoint2,
                            ),
                          ),
                        ),
                        onValidate: (value) {
                          if (value!.length < 6) {
                            f.showNewError(
                                "Password is too short. Use at least 6 characters",
                                context);
                            return '';
                          }
                          return null;
                        },
                        onSave: (value) => _authDetails["password"] = value!,
                        hint: "Password",
                      ),
                      Text(
                        "Password must be at least 6 characters",
                        style: context.textTheme.bodySmall!.copyWith(
                          color: _controller.text.length < 6
                              ? appRed
                              : possibleGreen,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SpecialForm(
                        obscure: !_showConfirmPassword,
                        height: 40.h,
                        width: 390.w,
                        controller: _confirmControl,
                        fillColor: authFieldBackground,
                        type: TextInputType.text,
                        prefix: Icon(
                          Icons.lock_outline_rounded,
                          size: 18.r,
                          color: primaryPoint2,
                        ),
                        suffix: GestureDetector(
                          child: AnimatedSwitcherTranslation.right(
                            duration: const Duration(milliseconds: 500),
                            child: Icon(
                              !_showConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              key: ValueKey<bool>(_showConfirmPassword),
                              size: 18.r,
                              color: primaryPoint2,
                            ),
                          ),
                          onTap: () => setState(() =>
                              _showConfirmPassword = !_showConfirmPassword),
                        ),
                        onValidate: (value) {
                          if (value != _controller.text) {
                            f.showNewError("Password do not match", context);
                            return '';
                          }
                          return null;
                        },
                        hint: "Confirm Password",
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
                          "Sign up",
                          style: context.textTheme.bodyLarge!.copyWith(
                              color: theme, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: context.textTheme.labelSmall,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          GestureDetector(
                            onTap: () => context.router
                                .pushReplacementNamed(Pages.login),
                            child: Text(
                              "Log In",
                              style: context.textTheme.bodySmall!
                                  .copyWith(color: appRed),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      Center(
                        child: Text(
                          "-OR-",
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
                              "sign up with Google",
                              style: context.textTheme.bodyMedium,
                            )
                          ],
                        ),
                      )
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
