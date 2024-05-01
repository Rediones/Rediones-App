import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatview/chatview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/api/base.dart';
import 'package:rediones/api/message_service.dart';
import 'package:rediones/components/message_data.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/tools/widgets.dart';

class Inbox extends ConsumerStatefulWidget {
  final Conversation details;

  const Inbox({
    super.key,
    required this.details,
  });

  @override
  ConsumerState<Inbox> createState() => _InboxState();
}

class _InboxState extends ConsumerState<Inbox> {
  late ChatController chatController;
  late List<Message> messageList;
  late List<ChatUser> users;

  late String currentUserID, otherID, conversationID;
  late User otherUser;

  bool loading = true;

  @override
  void initState() {
    super.initState();

    User currentUser = ref.read(userProvider);
    currentUserID = currentUser.id;
    otherUser = widget.details.users
        .firstWhere((user) => user != currentUser, orElse: () => currentUser);
    otherID = otherUser.id;
    conversationID = widget.details.id;

    users = [
      ChatUser(
        id: currentUserID,
        name: currentUser.username,
        profilePhoto: currentUser.profilePicture,
      ),
      ChatUser(
        id: otherID,
        name: otherUser.username,
        profilePhoto: otherUser.profilePicture,
      ),
    ];

    messageList = [];
    chatController = ChatController(
      initialMessageList: messageList,
      scrollController: ScrollController(),
      chatUsers: users,
    );

    getMessagesFor(conversationID, otherID).then((response) {
      for (MessageData data in response) {
        messageList.add(
          Message(
            id: data.id,
            createdAt: data.timestamp,
            message: data.content,
            sendBy: data.sender,
          ),
        );
      }
      setState(() => loading = false);
    });
  }

  @override
  void dispose() {
    chatController.dispose();
    super.dispose();
  }

  void onSendTap(
      String rawMessage, ReplyMessage replyMessage, MessageType messageType) {
    sendMessage(
      MessageData(
        timestamp: DateTime.now(),
        id: "",
        content: rawMessage,
        sender: currentUserID,
        conversationID: conversationID,
      ),
    ).then((resp) {
      if (resp.payload == null) return;
      final message = Message(
        id: resp.payload!.id,
        message: resp.payload!.content,
        createdAt: resp.payload!.timestamp,
        sendBy: currentUserID,
        replyMessage: replyMessage,
        messageType: messageType,
      );
      chatController.addMessage(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ChatView(
          currentUser: users[0],
          chatController: chatController,
          appBar: ChatViewAppBar(
            elevation: 0.0,
            backGroundColor: context.isDark ? fadedPrimary : const Color(0xFFF5F5F5),
            leading: IconButton(
              iconSize: 26.r,
              splashRadius: 20.r,
              icon: const Icon(Icons.chevron_left_rounded),
              onPressed: () => context.router.pop(),
            ),
            profilePicture: otherUser.profilePicture,
            chatTitle: otherUser.username,
            chatTitleTextStyle: context.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
            ),
            userStatusTextStyle: context.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
                iconSize: 26.r,
                splashRadius: 20.r,
              )
            ],
          ),
          onSendTap: onSendTap,
          chatViewState: ChatViewState.hasMessages,
          chatBackgroundConfig: ChatBackgroundConfiguration(
              backgroundColor: context.isDark ? fadedPrimary : const Color(0xFFF5F5F5),
          ),
          // Add this state once data is available.
          featureActiveConfig: const FeatureActiveConfig(
            enableSwipeToReply: true,
            enableSwipeToSeeTime: false,
            enableDoubleTapToLike: true,
          ),
          sendMessageConfig: SendMessageConfiguration(
            replyMessageColor: context.isDark ? theme : primary,
            replyDialogColor: appRed.withOpacity(0.2),
            replyTitleColor: context.isDark ? theme : primary,
            closeIconColor: context.isDark ? theme : primary,
            allowRecordingVoice: false,
            defaultSendButtonColor: appRed,
            textFieldBackgroundColor: context.isDark ? fadedPrimary : const Color(0xFFF5F5F5),
            textFieldConfig: TextFieldConfiguration(
              textStyle: context.textTheme.bodyMedium!,
            ),
          ),
          chatBubbleConfig: ChatBubbleConfiguration(
            onDoubleTap: (message) {
              // Your code goes here
            },
            outgoingChatBubbleConfig: ChatBubble(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              textStyle: context.textTheme.bodyMedium!.copyWith(
                  color: theme,
                  fontWeight: FontWeight.w500),
              color: appRed,
            ),
            inComingChatBubbleConfig: ChatBubble(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              textStyle: context.textTheme.bodyMedium!.copyWith(
                  color: context.isDark ? theme : midPrimary,
                  fontWeight: FontWeight.w500),
              color: context.isDark ? primary : theme
            ),
          ),
          loadingWidget: loader,
        ),
      ),
    );
  }
}
