import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/models/message_model.dart';
import 'package:social_media/models/post_model.dart';
import 'package:social_media/models/user_creater.dart';
import 'package:social_media/module/add_post/add_post.dart';
import 'package:social_media/module/chats/chat_screen.dart';
import 'package:social_media/module/feeds/feeds_screen.dart';
import 'package:social_media/module/layout/cubit/state.dart';
import 'package:social_media/module/settings/settings_screen.dart';
import 'package:social_media/module/users/users_screen.dart';
import 'package:social_media/shared/endpoints.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  UserCreateModel? userModel;
  void getUserData() {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserCreateModel.fromJson(value.data()!);
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      emit(SocialGetUserErrorState(error));
    });
  }

  int currentIndex = 0;
  List<Widget> screens = [
    FeedsScreen(),
    ChatScreen(),
    AddPost(),
    UsersScreen(),
    SettingsScreen(),
  ];
  List<String> title = [
    'Home',
    'Chat',
    'Post',
    'Users',
    'Settings',
  ];
  void changeBottomNav(int index) {
    if (index == 1) getUsers();
    if (index == 2)
      emit(SocialNewPostState());
    else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  final ImagePicker _picker = ImagePicker();
  File? coverImage;
  File? profileImage;
  File? postImage;

  Future<void> getCoverImage(BuildContext context) async {
    _picker.pickImage(source: ImageSource.gallery).then((value) {
      coverImage = File(value!.path);
      emit(SocialUpdateCoverSuccessState());
    }).catchError((error) {
      emit(SocialUpdateCoverErrorState(error.toString()));
    });
  }

  Future<void> uploadCoverImage() async {
    if (coverImage != null) {
      emit(SocialUploadCoverLoadingState());

      // upload coverImage to Firestore Storage
      FirebaseStorage.instance
          .ref('users/$uId/coverImage')
          .putFile(coverImage!)
          .then((value) {
        // get cover url
        value.ref.getDownloadURL().then((coverUrl) {
          // update in model
          userModel!.cover = coverUrl;

          // update in Firebase user data
          // emit(SocialUpdateFireStoreCoverLoadingState());

          FirebaseFirestore.instance
              .collection('users')
              .doc(uId)
              .update(userModel!.toMap())
              .then((_) {
            emit(SocialUpdateFireStoreCoverSuccessState());
          }).catchError((error) {
            emit(SocialUpdateFireStoreCoverErrorState(error.toString()));
          });
        }).catchError((error) {});
      }).catchError((error) {
        emit(SocialUploadCoverErrorState(error.toString()));
      });
    } else {}
  }

  Future<void> getProfileImage(BuildContext context) async {
    _picker.pickImage(source: ImageSource.gallery).then((value) {
      profileImage = File(value!.path);
      emit(SocialUpdateProfileImageSuccessState());
    }).catchError((error) {
      emit(SocialUpdateProfileImageErrorState(error.toString()));
    });
  }

  Future<void> uploadProfileImage() async {
    if (profileImage != null) {
      emit(SocialUploadProfileImageLoadingState());

      // upload profileImage to Firestore Storage
      FirebaseStorage.instance
          .ref('users/$uId/profileImage')
          .putFile(profileImage!)
          .then((value) {
        // get cover url
        value.ref.getDownloadURL().then((profileUrl) {
          // update in model
          userModel!.image = profileUrl;

          // update in Firebase user data
          // emit(SocialUpdateFireStoreProfileImageLoadingState());

          FirebaseFirestore.instance
              .collection('users')
              .doc(uId)
              .update(userModel!.toMap())
              .then((_) {
            emit(SocialUpdateFireStoreProfileImageSuccessState());
          }).catchError((error) {
            emit(SocialUpdateFireStoreProfileImageErrorState(error.toString()));
          });
        }).catchError((error) {});
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState(error.toString()));
      });
    }
  }

  Future<void> getPostImage() async {
    _picker.pickImage(source: ImageSource.gallery).then((value) {
      postImage = File(value!.path);
      emit(SocialPostImagePickedSuccessState());
    }).catchError((error) {
      emit(SocialPostImagePickedErrorState());
    });
  }

  void uploadPostImage({
    required String dateTime,
    required String text,
  }) {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(
          dateTime: dateTime,
          text: text,
          postImage: value,
        );
      }).catchError((error) {
        emit(SocialCreatePostErrorState());
      }).catchError((error) {
        emit(SocialCreatePostErrorState());
      });
    });
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
  }) {
    emit(SocialCreatePostLoadingState());

    PostModel model = PostModel(
      name: userModel!.name,
      uId: userModel!.uId,
      image: userModel!.image,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];

  void getPosts() {
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        final postId = element.id;
        getComments(postId);
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
        }).catchError((error) {});
      });
      emit(SocialGetPostsSuccessState());
    }).catchError((error) {
      SocialGetPostsErrorState();
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({'like': true}).then((value) {
      emit(SocialLikePostsSuccessState());
    }).catchError((error) {
      emit(SocialLikePostsErrorState());
    });
  }

  Map<String, List<Map<String, dynamic>>> comments = {};

  void getComments(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('commentTime')
        .snapshots()
        .listen((event) {
      comments[postId] = event.docs.map((e) => e.data()).toList();
      emit(SocialCommentPostsSuccessState());
    });
  }

  void addComment(String postId, String commentText) {
    final commentData = {
      'uId': userModel!.uId,
      'name': userModel!.name,
      'commentText': commentText,
      'commentTime': Timestamp.now(),
    };
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(commentData)
        .then((_) {
      emit(SocialAddCommentSuccessState());
    }).catchError((error) {
      emit(SocialAddCommentErrorState());
    });
  }

  List<UserCreateModel> users = [];
  void getUsers() {
    if (users.length == 0)
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != userModel!.uId)
            users.add(UserCreateModel.fromJson(element.data()));
        });
        emit(SocialGetPostsSuccessState());
      }).catchError((error) {
        SocialGetPostsErrorState();
      });
  }

  void sendMessages({
    required String receiverId,
    required String text,
    required String dateTime,
  }) {
    MessageModel model = MessageModel(
      senderId: userModel!.uId,
      receiverId: receiverId,
      dateTime: dateTime,
      text: text,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState(error));
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chat')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState(error));
    });
  }

  List<MessageModel> messages = [];
  void getMessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(SocialGetMessagesSuccessState());
    });
  }
}
