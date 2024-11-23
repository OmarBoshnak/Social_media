import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/models/user_creater.dart';
import 'package:social_media/module/register/cubit/state.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());
  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister(
      {required String name,
      required String email,
      required String password,
      required String phone}) {
    emit(SocialRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      createUser(
        name: name,
        email: email,
        phone: phone,
        uId: value.user!.uid,
      );
    }).catchError((error) {
      emit(SocialRegisterErrorState());
    });
  }

  void createUser({
    required String email,
    required String name,
    required String phone,
    required String uId,
  }) {
    var userModel = UserCreateModel(
        email: email,
        name: name,
        phone: phone,
        uId: uId,
        isEmailVerified: false,
        bio: 'Write your bio...',
        cover:
            'https://img.freepik.com/free-photo/handsome-smiling-happy-hipster-style-bearded-man-wearing-denim-shirt-cap-with-bicycle-morning-sunrise-by-sea-drinking-coffee-healthy-active-lifestyle-traveler_285396-5405.jpg?t=st=1730190156~exp=1730193756~hmac=e3979f6353a2a4e5ba1b7a947903fef93345f429399cde3d558577b2c57ef40d&w=2000',
        image:
            'https://img.freepik.com/premium-photo/male-walk-mountain-mexico-high-quality-photo_370312-674.jpg?w=2000');
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(userModel.toMap())
        .then((value) {
      emit(SocialCreateUserSuccessState());
    }).catchError((error) {
      emit(SocialCreateUserErrorState());
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordRegister() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off;

    emit(SocialRegisterChangePasswordVisibitlyState());
  }
}
