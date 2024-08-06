import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/api/message_service.dart';
import 'package:rediones/components/message_data.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/tools/widgets.dart';
import 'package:uuid/uuid.dart';

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

  bool loading = true, hasError = false;

  final Uuid uuid = const Uuid();

  @override
  void initState() {
    super.initState();

    User currentUser = ref.read(userProvider);
    currentUserID = currentUser.uuid;
    otherUser = widget.details.users
        .firstWhere((user) => user != currentUser, orElse: () => currentUser);
    otherID = otherUser.uuid;
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

    fetchMessages();
  }

  void assignMessages(List<MessageData> messages, {bool online = false}) {
    List<Message> msgs = messages
        .map(
          (msg) => Message(
            message: msg.content,
            createdAt: msg.timestamp,
            sendBy: msg.sender,
            id: msg.id,
          ),
        )
        .toList();

    if (online) {
      chatController.clearMessages();
    }

    chatController.addAll(msgs);
    setState(() {
      loading = false;
      hasError = false;
    });
  }

  Future<void> fetchMessages() async {
    var response = await getMessagesFor(conversationID, otherID);
    if (!mounted) return;

    if (response.status == Status.failed) {
      showToast(response.message, context);
      setState(() {
        loading = false;
        hasError = true;
      });
      return;
    }

    assignMessages(response.payload, online: true);
  }

  void refresh() {
    setState(() {
      loading = true;
      hasError = false;
    });
    fetchMessages();
  }

  @override
  void dispose() {
    chatController.dispose();
    super.dispose();
  }

  void onSendTap(
      String rawMessage, ReplyMessage replyMessage, MessageType messageType) {
    final message = Message(
      id: uuid.v4(),
      message: rawMessage,
      createdAt: DateTime.now(),
      sendBy: currentUserID,
      replyMessage: replyMessage,
      messageType: messageType,
    );
    chatController.addMessage(message);

    sendMessage(
      MessageData(
        timestamp: DateTime.now(),
        id: uuid.v4(),
        content: rawMessage,
        sender: currentUserID,
        conversationID: conversationID,
      ),
    );
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
            backGroundColor:
                context.isDark ? fadedPrimary : const Color(0xFFF5F5F5),
            leading: IconButton(
              iconSize: 26.r,
              splashRadius: 20.r,
              icon: const Icon(Icons.chevron_left_rounded),
              onPressed: () => context.router.pop(),
            ),
            profilePicture: otherUser.profilePicture,
            chatTitle: otherUser.username,
            userStatus: "Online",
            chatTitleTextStyle: context.textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.w700,
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
          chatViewState: loading
              ? ChatViewState.loading
              : hasError
                  ? ChatViewState.error
                  : ChatViewState.hasMessages,
          chatViewStateConfig: ChatViewStateConfiguration(
            loadingWidgetConfig: const ChatViewStateWidgetConfiguration(
              widget: loader,
            ),
            errorWidgetConfig: ChatViewStateWidgetConfiguration(
              widget: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/No Data.png",
                      width: 150.r,
                      height: 150.r,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "An error occurred",
                      style: context.textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    GestureDetector(
                      onTap: refresh,
                      child: Text(
                        "Refresh",
                        style: context.textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: appRed,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            noMessageWidgetConfig: ChatViewStateWidgetConfiguration(
              widget: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/No Data.png",
                      width: 150.r,
                      height: 150.r,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "There are no messages yet",
                      style: context.textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          chatBackgroundConfig: ChatBackgroundConfiguration(
            backgroundColor:
                context.isDark ? fadedPrimary : const Color(0xFFF5F5F5),
            messageTimeAnimationCurve: Curves.easeOut,
            defaultGroupSeparatorConfig: DefaultGroupSeparatorConfiguration(
              textStyle: context.textTheme.bodyMedium
            ),
          ),
          // showTypingIndicator: true,
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
            textFieldBackgroundColor:
                context.isDark ? fadedPrimary : const Color(0xFFF5F5F5),
            textFieldConfig: TextFieldConfiguration(
              textStyle: context.textTheme.bodyLarge!,
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
              textStyle: context.textTheme.bodyLarge!.copyWith(
                color: theme,
                fontWeight: FontWeight.w500,
              ),
              color: appRed,
            ),
            inComingChatBubbleConfig: ChatBubble(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              textStyle: context.textTheme.bodyLarge!.copyWith(
                color: context.isDark ? theme : midPrimary,
                fontWeight: FontWeight.w500,
              ),
              color: context.isDark ? primary : theme,
            ),
          ),
          loadingWidget: loader,
        ),
      ),
    );
  }
}
