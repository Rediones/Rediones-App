import 'package:animated_switcher_plus/animated_switcher_plus.dart';
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
        f.showNewError(result.status == Status.failed
            ? result.message
            : "Account Created Successfully", context);

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
              Text(
                "Rediones",
                style: context.textTheme.titleLarge!.copyWith(color: appRed),
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
                          "Email",
                          style: context.textTheme.labelSmall,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
                        width: 390.w,
                        height: 40.h,
                        fillColor: Colors.transparent,
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
                        obscure: !_showPassword,
                        width: 390.w,
                        height: 40.h,
                        controller: _controller,
                        type: TextInputType.text,
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
                              color: Colors.grey,
                            ),
                          ),
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Confirm Password",
                          style: context.textTheme.labelSmall,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
                        obscure: !_showConfirmPassword,
                        height: 40.h,
                        width: 390.w,
                        controller: _confirmControl,
                        type: TextInputType.text,
                        suffix: GestureDetector(
                          child: AnimatedSwitcherTranslation.right(
                            duration: const Duration(milliseconds: 500),
                            child: Icon(
                              !_showConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              key: ValueKey<bool>(_showConfirmPassword),
                              size: 18.r,
                              color: Colors.grey,
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
                        hint: "********",
                      ),
                      SizedBox(
                        height: 46.h,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(390.w, 40.h),
                          backgroundColor: appRed,
                        ),
                        onPressed: submit,
                        child: Text(
                          "Sign Up",
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
                          Text(
                            "Already have an account?",
                            style: context.textTheme.labelSmall,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          GestureDetector(
                            onTap: () => context.router
                                .pushReplacementNamed(Pages.login),
                            child: Text(
                              "Sign In",
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
