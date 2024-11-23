import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/module/layout/layout_screem.dart';
import 'package:social_media/module/log/cubit/cubit.dart';
import 'package:social_media/module/log/cubit/state.dart';
import 'package:social_media/module/register/register_screen.dart';
import 'package:social_media/shared/companants.dart';
import 'package:social_media/shared/local/cache.dart';

class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        listener: (context, state) {
          if (state is SocialLoginErrorState) {
            showToast(text: state.error, state: ToastState.ERROR);
          }
          if (state is SocialLoginSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              navigatorAndFinish(context, const LayoutScreen());
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LOGIN',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const Text(
                      'Login now to our social media',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    defaultFieldform(
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please Enter your Email';
                          }
                          return null;
                        },
                        label: 'Email',
                        prefix: Icons.email),
                    const SizedBox(
                      height: 15,
                    ),
                    defaultFieldform(
                      controller: passwordController,
                      type: TextInputType.emailAddress,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please Enter your Password';
                        }
                        return null;
                      },
                      onSubmit: (value) {
                        if (formKey.currentState!.validate()) {}
                      },
                      label: 'Password',
                      prefix: Icons.lock,
                      suffix: SocialLoginCubit.get(context).suffix,
                      isPassword: SocialLoginCubit.get(context).isPassword,
                      suffixPressed: () {
                        SocialLoginCubit.get(context).changePasswordVisibilty();
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ConditionalBuilder(
                      builder: (context) => defaultButton(
                        color: Colors.blue,
                        text: 'Login',
                        function: () {
                          if (formKey.currentState!.validate()) {
                            SocialLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text);
                          }
                        },
                      ),
                      condition: state is! SocialLoginLoadingState,
                      fallback: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                            onPressed: () {
                              navigatorTo(context, RegisterScreen());
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(color: Colors.blue),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
