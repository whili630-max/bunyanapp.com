import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../core/services/language_service.dart';
import '../../../core/database/database_service.dart';
import '../../../core/models/chat_message.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String chatName;
  final String currentUserId;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.chatName,
    required this.currentUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    try {
      final messages =
          await DatabaseService.instance.getChatMessages(widget.chatId);
      setState(() {
        _messages = messages;
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _isSending = true;
    });

    final message = ChatMessage(
      id: const Uuid().v4(),
      chatId: widget.chatId,
      senderId: widget.currentUserId,
      senderName: 'أنت', // This should be fetched from user data
      content: text,
      type: MessageType.text,
      status: MessageStatus.sending,
    );

    // Add message to local list immediately for better UX
    setState(() {
      _messages.add(message);
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      await DatabaseService.instance.sendMessage(widget.chatId, message);

      // Update message status to sent
      final updatedMessage = message.copyWith(status: MessageStatus.sent);
      setState(() {
        final index = _messages.indexWhere((m) => m.id == message.id);
        if (index != -1) {
          _messages[index] = updatedMessage;
        }
      });
    } catch (e) {
      // Update message status to failed
      final failedMessage = message.copyWith(status: MessageStatus.failed);
      setState(() {
        final index = _messages.indexWhere((m) => m.id == message.id);
        if (index != -1) {
          _messages[index] = failedMessage;
        }
      });
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 1,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Row(
          children: [
            Hero(
              tag: 'avatar_${widget.chatId}',
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Text(
                  widget.chatName.isNotEmpty ? widget.chatName[0] : '؟',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    languageService.getLocalizedText('متصل', 'Online'),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _showChatOptions,
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
                    ),
                  )
                : _messages.isEmpty
                    ? _buildEmptyState(languageService)
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          final isMe = message.senderId == widget.currentUserId;
                          final showAvatar = index == _messages.length - 1 ||
                              _messages[index + 1].senderId != message.senderId;

                          return _buildMessageBubble(
                              message, isMe, showAvatar, index);
                        },
                      ),
          ),
          _buildMessageInput(languageService),
        ],
      ),
    );
  }

  Widget _buildEmptyState(LanguageService languageService) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 50,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            languageService.getLocalizedText(
                'ابدأ المحادثة', 'Start the conversation'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            languageService.getLocalizedText(
              'اكتب رسالتك الأولى أدناه',
              'Type your first message below',
            ),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
      ChatMessage message, bool isMe, bool showAvatar, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!isMe && showAvatar) ...[
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFF2E7D32),
                      child: Text(
                        message.senderName.isNotEmpty
                            ? message.senderName[0]
                            : '؟',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ] else if (!isMe) ...[
                    const SizedBox(width: 40),
                  ],
                  Flexible(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isMe ? const Color(0xFF2E7D32) : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(18),
                          topRight: const Radius.circular(18),
                          bottomLeft: Radius.circular(isMe ? 18 : 4),
                          bottomRight: Radius.circular(isMe ? 4 : 18),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.content,
                            style: TextStyle(
                              color:
                                  isMe ? Colors.white : const Color(0xFF333333),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _formatTime(message.timestamp),
                                style: TextStyle(
                                  color: isMe
                                      ? Colors.white.withOpacity(0.7)
                                      : const Color(0xFF999999),
                                  fontSize: 12,
                                ),
                              ),
                              if (isMe) ...[
                                const SizedBox(width: 4),
                                _buildMessageStatusIcon(message.status),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isMe) const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 1,
            valueColor:
                AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.7)),
          ),
        );
      case MessageStatus.sent:
        return Icon(
          Icons.check,
          size: 14,
          color: Colors.white.withOpacity(0.7),
        );
      case MessageStatus.delivered:
        return Icon(
          Icons.done_all,
          size: 14,
          color: Colors.white.withOpacity(0.7),
        );
      case MessageStatus.read:
        return const Icon(
          Icons.done_all,
          size: 14,
          color: Colors.lightBlue,
        );
      case MessageStatus.failed:
        return const Icon(
          Icons.error_outline,
          size: 14,
          color: Colors.red,
        );
    }
  }

  Widget _buildMessageInput(LanguageService languageService) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F5),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: languageService.getLocalizedText(
                    'اكتب رسالة...',
                    'Type a message...',
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: _showAttachmentOptions,
                        icon: const Icon(
                          Icons.attach_file,
                          color: Color(0xFF666666),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // TODO: Implement camera
                        },
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: FloatingActionButton(
              onPressed: _isSending ? null : _sendMessage,
              backgroundColor: const Color(0xFF2E7D32),
              mini: true,
              child: _isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(time.year, time.month, time.day);

    if (messageDate == today) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.day}/${time.month} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  void _showChatOptions() {
    final languageService =
        Provider.of<LanguageService>(context, listen: false);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.info_outline, color: Color(0xFF2E7D32)),
              title: Text(languageService.getLocalizedText(
                  'معلومات المحادثة', 'Chat Info')),
              onTap: () {
                Navigator.pop(context);
                // TODO: Show chat info
              },
            ),
            ListTile(
              leading: const Icon(Icons.search, color: Color(0xFF2E7D32)),
              title: Text(languageService.getLocalizedText(
                  'البحث في المحادثة', 'Search Chat')),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement search
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: Text(
                languageService.getLocalizedText('حذف المحادثة', 'Delete Chat'),
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions() {
    final languageService =
        Provider.of<LanguageService>(context, listen: false);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              languageService.getLocalizedText('إرفاق ملف', 'Attach File'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  Icons.photo,
                  languageService.getLocalizedText('صورة', 'Photo'),
                  const Color(0xFF2E7D32),
                  () {
                    Navigator.pop(context);
                    // TODO: Pick image
                  },
                ),
                _buildAttachmentOption(
                  Icons.insert_drive_file,
                  languageService.getLocalizedText('ملف', 'File'),
                  const Color(0xFF8D6E63),
                  () {
                    Navigator.pop(context);
                    // TODO: Pick file
                  },
                ),
                _buildAttachmentOption(
                  Icons.location_on,
                  languageService.getLocalizedText('موقع', 'Location'),
                  const Color(0xFFFF9800),
                  () {
                    Navigator.pop(context);
                    // TODO: Share location
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    final languageService =
        Provider.of<LanguageService>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            languageService.getLocalizedText('حذف المحادثة', 'Delete Chat')),
        content: Text(
          languageService.getLocalizedText(
            'هل أنت متأكد من حذف هذه المحادثة؟ لا يمكن التراجع عن هذا الإجراء.',
            'Are you sure you want to delete this chat? This action cannot be undone.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(languageService.getLocalizedText('إلغاء', 'Cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              // TODO: Delete chat
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(languageService.getLocalizedText('حذف', 'Delete')),
          ),
        ],
      ),
    );
  }
}
