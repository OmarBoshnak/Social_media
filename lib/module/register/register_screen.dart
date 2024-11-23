import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/module/layout/layout_screem.dart';
import 'package:social_media/module/register/cubit/cubit.dart';
import 'package:social_media/module/register/cubit/state.dart';
import 'package:social_media/shared/companants.dart';

class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
        listener: (context, state) {
          if (state is SocialCreateUserSuccessState) {
            navigatorAndFinish(context, const LayoutScreen());
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
                      'Register',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const Text(
                      'Register now to our social media to communicate with friends',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    defaultFieldform(
                        controller: nameController,
                        type: TextInputType.name,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Name';
                          }
                          return null;
                        },
                        label: 'Name',
                        prefix: Icons.person),
                    const SizedBox(
                      height: 15,
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
                      onSubmit: (value) {},
                      label: 'Password',
                      prefix: Icons.lock,
                      suffix: SocialRegisterCubit.get(context).suffix,
                      isPassword: SocialRegisterCubit.get(context).isPassword,
                      suffixPressed: () {
                        SocialRegisterCubit.get(context)
                            .changePasswordRegister();
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    defaultFieldform(
                        controller: phoneController,
                        type: TextInputType.phone,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Phone';
                          }
                          return null;
                        },
                        label: 'Phone',
                        prefix: Icons.phone),
                    const SizedBox(
                      height: 15,
                    ),
                    ConditionalBuilder(
                      builder: (context) => defaultButton(
                        color: Colors.blue,
                        text: 'Register',
                        function: () {
                          if (formKey.currentState!.validate()) {
                            SocialRegisterCubit.get(context).userRegister(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                phone: phoneController.text);
                          }
                        },
                      ),
                      condition: state is! SocialRegisterLoadingState,
                      fallback: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
