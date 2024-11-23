import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/models/post_model.dart';
import 'package:social_media/models/user_creater.dart';
import 'package:social_media/module/layout/cubit/cubit.dart';
import 'package:social_media/module/layout/cubit/state.dart';
import 'package:social_media/shared/icon_broken.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = SocialCubit.get(context).userModel;
          if (cubit == null) {
            // Show a loading indicator while data is being fetched
            return Center(child: CircularProgressIndicator());
          }
          return ConditionalBuilder(
            condition: SocialCubit.get(context).posts.length > 0 &&
                SocialCubit.get(context).userModel != null,
            builder: (context) => SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 10,
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Image.network(
                          '${cubit.cover}',
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 20,
                          width: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black.withOpacity(0.7)),
                          child: Text(
                            'Coummincate with friends',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => buildPostItem(context,
                          SocialCubit.get(context).posts[index], index),
                      separatorBuilder: (context, index) => SizedBox(
                            height: 5,
                          ),
                      itemCount: SocialCubit.get(context).posts.length)
                ],
              ),
            ),
            fallback: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }

  Widget buildPostItem(context, PostModel model, index) {
    final postId = SocialCubit.get(context).postsId[index];
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage('${model.image}'),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            model.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, height: 1.3),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.blue,
                          )
                        ],
                      ),
                      Text(
                        model.dateTime,
                        style: TextStyle(
                            color: Colors.grey, fontSize: 13, height: 1.3),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_horiz,
                    size: 16,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Divider(
                color: Colors.black,
                thickness: 0.09,
              ),
            ),
            Text(
              model.text,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            Container(
              width: double.infinity,
              child: Wrap(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    child: MaterialButton(
                      onPressed: () {},
                      height: 20,
                      padding: EdgeInsets.zero,
                      minWidth: 1.0,
                      child: Text(
                        '#Softwear',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    child: MaterialButton(
                      onPressed: () {},
                      height: 20,
                      padding: EdgeInsets.zero,
                      minWidth: 1.0,
                      child: Text(
                        '#Softwear',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: NetworkImage(
                    '${model.image}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(
                            IconBroken.Heart,
                            color: Colors.red,
                            size: 23,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          if (SocialCubit.get(context).likes != null)
                            Text(
                              '${SocialCubit.get(context).likes[index]}',
                              style: TextStyle(color: Colors.grey),
                            )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            IconBroken.Chat,
                            color: Colors.amber,
                            size: 23,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            '120 Comments',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.black,
              thickness: 0.09,
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage('${model.image}'),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: TextField(
                    onSubmitted: (text) {
                      if (text.isNotEmpty) {
                        SocialCubit.get(context).addComment(postId, text);
                      }
                    },
                    decoration: InputDecoration(
                        hintText: 'Write a comment...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none),
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    SocialCubit.get(context)
                        .likePost(SocialCubit.get(context).postsId[index]);
                  },
                  icon: Icon(
                    size: 18,
                    IconBroken.Heart,
                    color: Colors.red,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
