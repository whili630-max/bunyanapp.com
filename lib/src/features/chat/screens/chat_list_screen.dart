import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/language_service.dart';
import '../../../core/database/database_service.dart';
import '../../../core/models/chat_message.dart';
import '../../../core/models/user.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  final String currentUserId;

  const ChatListScreen({
    super.key,
    required this.currentUserId,
  });

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  List<ChatRoom> _chatRooms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadChatRooms();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadChatRooms() async {
    try {
      final chatIds =
          await DatabaseService.instance.getUserChats(widget.currentUserId);
      final rooms = <ChatRoom>[];

      for (final chatId in chatIds) {
        final messages = await DatabaseService.instance.getChatMessages(chatId);
        if (messages.isNotEmpty) {
          final lastMessage = messages.last;
          final participants = await _getChatParticipants(chatId);

          final room = ChatRoom(
            id: chatId,
            name: await _getChatName(chatId, participants),
            participants: participants,
            lastMessageId: lastMessage.id,
            lastMessageContent: lastMessage.content,
            lastMessageTime: lastMessage.timestamp,
          );
          rooms.add(room);
        }
      }

      rooms.sort((a, b) => (b.lastMessageTime ?? DateTime.now())
          .compareTo(a.lastMessageTime ?? DateTime.now()));

      setState(() {
        _chatRooms = rooms;
        _isLoading = false;
      });

      _animationController.forward();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<String>> _getChatParticipants(String chatId) async {
    // Extract participant IDs from chat ID format: "user1_user2" or "order_orderId_user1_user2"
    if (chatId.startsWith('order_')) {
      final parts = chatId.split('_');
      return parts.skip(2).toList();
    } else {
      return chatId.split('_');
    }
  }

  Future<String> _getChatName(String chatId, List<String> participants) async {
    final otherParticipants =
        participants.where((id) => id != widget.currentUserId).toList();

    if (otherParticipants.isEmpty) return 'الدردشة';

    final users = await DatabaseService.instance.getAllUsers();
    final otherUser = users.firstWhere(
      (user) => user.id == otherParticipants.first,
      orElse: () => User(
        id: 'unknown',
        name: 'مستخدم غير معروف',
        email: '',
        password: '',
        userType: UserType.client,
        phone: '',
      ),
    );

    return otherUser.name;
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          languageService.getLocalizedText('الرسائل', 'Messages'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showNewChatDialog,
            icon: const Icon(Icons.add_comment, color: Colors.white),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
              ),
            )
          : _chatRooms.isEmpty
              ? _buildEmptyState(languageService)
              : FadeTransition(
                  opacity: _fadeAnimation,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _chatRooms.length,
                    itemBuilder: (context, index) {
                      return _buildChatRoomCard(_chatRooms[index], index);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState(LanguageService languageService) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 60,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            languageService.getLocalizedText(
                'لا توجد محادثات', 'No conversations'),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            languageService.getLocalizedText(
              'ابدأ محادثة جديدة مع الموردين أو العملاء',
              'Start a new conversation with suppliers or clients',
            ),
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _showNewChatDialog,
            icon: const Icon(Icons.add),
            label: Text(
                languageService.getLocalizedText('محادثة جديدة', 'New Chat')),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatRoomCard(ChatRoom room, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _openChat(room),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Hero(
                          tag: 'avatar_${room.id}',
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: const Color(0xFF2E7D32),
                            child: Text(
                              room.name.isNotEmpty ? room.name[0] : '؟',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                room.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                room.lastMessageContent ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _formatTime(room.lastMessageTime),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF999999),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2E7D32),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';

    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}د';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}س';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}ق';
    } else {
      return 'الآن';
    }
  }

  void _openChat(ChatRoom room) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ChatScreen(
          chatId: room.id,
          chatName: room.name,
          currentUserId: widget.currentUserId,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
      ),
    );
  }

  void _showNewChatDialog() {
    showDialog(
      context: context,
      builder: (context) => NewChatDialog(currentUserId: widget.currentUserId),
    );
  }
}

class NewChatDialog extends StatefulWidget {
  final String currentUserId;

  const NewChatDialog({super.key, required this.currentUserId});

  @override
  State<NewChatDialog> createState() => _NewChatDialogState();
}

class _NewChatDialogState extends State<NewChatDialog> {
  List<User> _users = [];
  List<User> _filteredUsers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    final users = await DatabaseService.instance.getAllUsers();
    final filteredUsers =
        users.where((user) => user.id != widget.currentUserId).toList();

    setState(() {
      _users = filteredUsers;
      _filteredUsers = filteredUsers;
    });
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = _users
          .where((user) =>
              user.name.toLowerCase().contains(query) ||
              user.email.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              languageService.getLocalizedText('محادثة جديدة', 'New Chat'),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: languageService.getLocalizedText(
                    'البحث عن مستخدم', 'Search users'),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = _filteredUsers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getUserTypeColor(user.userType),
                      child: Text(
                        user.name.isNotEmpty ? user.name[0] : '؟',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(user.name),
                    subtitle:
                        Text(_getUserTypeText(user.userType, languageService)),
                    onTap: () => _startChat(user),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getUserTypeColor(UserType userType) {
    switch (userType) {
      case UserType.client:
        return const Color(0xFF2E7D32);
      case UserType.supplier:
        return const Color(0xFF8D6E63);
      case UserType.driver:
        return const Color(0xFFFF9800);
      case UserType.admin:
        return const Color(0xFF455A64);
    }
  }

  String _getUserTypeText(UserType userType, LanguageService languageService) {
    switch (userType) {
      case UserType.client:
        return languageService.customer;
      case UserType.supplier:
        return languageService.supplier;
      case UserType.driver:
        return languageService.driver;
      case UserType.admin:
        return languageService.admin;
    }
  }

  Future<void> _startChat(User user) async {
    final chatId = '${widget.currentUserId}_${user.id}';

    await DatabaseService.instance.addUserToChat(widget.currentUserId, chatId);
    await DatabaseService.instance.addUserToChat(user.id, chatId);

    if (mounted) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            chatId: chatId,
            chatName: user.name,
            currentUserId: widget.currentUserId,
          ),
        ),
      );
    }
  }
}
