abstract class SocialStates {}

class SocialInitialState extends SocialStates {}

class SocialGetUserLoadingState extends SocialStates {}

class SocialGetUserSuccessState extends SocialStates {}

class SocialGetUserErrorState extends SocialStates {
  final String error;

  SocialGetUserErrorState(this.error);
}

class SocialChangeBottomNavState extends SocialStates {}

class SocialNewPostState extends SocialStates {}

class SocialUpdateCoverSuccessState extends SocialStates {}

class SocialUpdateCoverErrorState extends SocialStates {
  final String error;

  SocialUpdateCoverErrorState(this.error);
}

class SocialUploadCoverLoadingState extends SocialStates {}

class SocialUploadCoverSuccessState extends SocialStates {}

class SocialUploadCoverErrorState extends SocialStates {
  final String error;

  SocialUploadCoverErrorState(this.error);
}

class SocialUpdateFireStoreCoverLoadingState extends SocialStates {}

class SocialUpdateFireStoreCoverSuccessState extends SocialStates {}

class SocialUpdateFireStoreCoverErrorState extends SocialStates {
  final String error;

  SocialUpdateFireStoreCoverErrorState(this.error);
}

/// update profile image states
class SocialUpdateProfileImageSuccessState extends SocialStates {}

class SocialUpdateProfileImageErrorState extends SocialStates {
  final String error;

  SocialUpdateProfileImageErrorState(this.error);
}

class SocialUploadProfileImageLoadingState extends SocialStates {}

class SocialUploadProfileImageSuccessState extends SocialStates {}

class SocialUploadProfileImageErrorState extends SocialStates {
  final String error;

  SocialUploadProfileImageErrorState(this.error);
}

class SocialUpdateFireStoreProfileImageLoadingState extends SocialStates {}

class SocialUpdateFireStoreProfileImageSuccessState extends SocialStates {}

class SocialUpdateFireStoreProfileImageErrorState extends SocialStates {
  final String error;

  SocialUpdateFireStoreProfileImageErrorState(this.error);
}

class SocialUserUpdateLoadingSuccessState extends SocialStates {}

class SocialCreatePostLoadingState extends SocialStates {}

class SocialCreatePostSuccessState extends SocialStates {}

class SocialCreatePostErrorState extends SocialStates {}

class SocialPostImagePickedSuccessState extends SocialStates {}

class SocialPostImagePickedErrorState extends SocialStates {}

class SocialRemovePostImageState extends SocialStates {}

class SocialGetPostsLoadingState extends SocialStates {}

class SocialGetPostsSuccessState extends SocialStates {}

class SocialGetPostsErrorState extends SocialStates {}

class SocialLikePostsSuccessState extends SocialStates {}

class SocialLikePostsErrorState extends SocialStates {}

class SocialCommentPostsSuccessState extends SocialStates {}

class SocialCommentPostsErrorState extends SocialStates {}

class SocialAddCommentSuccessState extends SocialStates {}

class SocialAddCommentErrorState extends SocialStates {}

// Messages

class SocialSendMessageSuccessState extends SocialStates {}

class SocialSendMessageErrorState extends SocialStates {
  SocialSendMessageErrorState(this.error);
  final String error;
}

class SocialGetMessagesSuccessState extends SocialStates {}

class SocialGetMessagesErrorState extends SocialStates {}
