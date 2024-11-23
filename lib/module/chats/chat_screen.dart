import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/models/user_creater.dart';
import 'package:social_media/module/chats/chat_details.dart';
import 'package:social_media/module/layout/cubit/cubit.dart';
import 'package:social_media/module/layout/cubit/state.dart';
import 'package:social_media/shared/companants.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.users.length > 0,
          builder: (context) => ListView.separated(
            itemBuilder: (context, index) =>
                buildChatItems(SocialCubit.get(context).users[index], context),
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(),
            ),
            itemCount: cubit.users.length,
          ),
          fallback: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget buildChatItems(UserCreateModel model, context) => Padding(
        padding: const EdgeInsets.all(10),
        child: InkWell(
          onTap: () {
            navigatorTo(
                context,
                ChatDetails(
                  userModel: model,
                ));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage('${model.image}'),
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                model.name,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15, height: 1.4),
              )
            ],
          ),
        ),
      );
}
