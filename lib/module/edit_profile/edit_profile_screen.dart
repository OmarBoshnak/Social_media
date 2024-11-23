import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/module/layout/cubit/cubit.dart';
import 'package:social_media/module/layout/cubit/state.dart';
import 'package:social_media/shared/companants.dart';
import 'package:social_media/shared/icon_broken.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context).userModel;
        var profile = SocialCubit.get(context).profileImage;
        var cover = SocialCubit.get(context).coverImage;
        nameController.text = cubit!.name;
        bioController.text = cubit.bio;
        return Scaffold(
          appBar: AppBar(
            title: Text('Edit Profile'),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(IconBroken.Arrow___Left_2)),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.blue),
                    )),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                if (state is SocialUserUpdateLoadingSuccessState)
                  LinearProgressIndicator(),
                if (state is SocialUserUpdateLoadingSuccessState)
                  SizedBox(
                    height: 10,
                  ),
                Container(
                  height: 250,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topCenter,
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4)),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: cover == null
                                      ? NetworkImage(
                                          '${cubit.cover}',
                                        )
                                      : FileImage(cover!),
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  SocialCubit.get(context)
                                      .getCoverImage(context);
                                },
                                icon: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.blue,
                                    child: Icon(
                                      size: 20,
                                      IconBroken.Camera,
                                      color: Colors.white,
                                    )))
                          ],
                        ),
                      ),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: profile == null
                                  ? NetworkImage('${cubit.image}')
                                  : FileImage(profile),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                SocialCubit.get(context)
                                    .getProfileImage(context);
                              },
                              icon: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.blue,
                                child: Icon(
                                  IconBroken.Camera,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
                if (SocialCubit.get(context).profileImage != null ||
                    SocialCubit.get(context).coverImage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: [
                        if (SocialCubit.get(context).profileImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  width: double.infinity,
                                  child: defaultButton(
                                      color: Colors.blue,
                                      text: 'Update Profile',
                                      function: () {}),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(
                          width: 10,
                        ),
                        if (SocialCubit.get(context).coverImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  width: double.infinity,
                                  child: defaultButton(
                                      color: Colors.blue,
                                      text: 'Update cover ',
                                      function: () {
                                        SocialCubit.get(context)
                                            .uploadCoverImage();
                                      }),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                SizedBox(
                  height: 20,
                ),
                defaultFieldform(
                  controller: nameController,
                  type: TextInputType.name,
                  validate: (String? value) {
                    if (value!.isEmpty) {
                      return "Name can't be empty";
                    }
                  },
                  label: 'Name',
                  prefix: IconBroken.User,
                ),
                SizedBox(
                  height: 10,
                ),
                defaultFieldform(
                    controller: bioController,
                    type: TextInputType.text,
                    validate: (String? value) {
                      if (value!.isEmpty) {
                        return "Name can't be empty";
                      }
                    },
                    label: 'Bio',
                    prefix: IconBroken.Info_Circle)
              ],
            ),
          ),
        );
      },
    );
  }
}
