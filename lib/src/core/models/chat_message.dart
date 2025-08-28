import 'dart:convert';

enum MessageType { text, image, file, location, order, system }

enum MessageStatus { sending, sent, delivered, read, failed }

class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String content;
  final MessageType type;
  final MessageStatus status;
  final DateTime timestamp;
  final String? replyToId;
  final Map<String, dynamic>? metadata;
  final List<String> attachments;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.content,
    this.type = MessageType.text,
    this.status = MessageStatus.sent,
    DateTime? timestamp,
    this.replyToId,
    this.metadata,
    this.attachments = const [],
  }) : timestamp = timestamp ?? DateTime.now();

  ChatMessage copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? senderName,
    String? content,
    MessageType? type,
    MessageStatus? status,
    DateTime? timestamp,
    String? replyToId,
    Map<String, dynamic>? metadata,
    List<String>? attachments,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      content: content ?? this.content,
      type: type ?? this.type,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      replyToId: replyToId ?? this.replyToId,
      metadata: metadata ?? this.metadata,
      attachments: attachments ?? this.attachments,
    );
  }

  bool get isSystemMessage => type == MessageType.system;
  bool get hasAttachments => attachments.isNotEmpty;
  bool get isReply => replyToId != null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'senderName': senderName,
      'content': content,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'replyToId': replyToId,
      'metadata': metadata,
      'attachments': attachments,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      chatId: json['chatId'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      content: json['content'],
      type: MessageType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => MessageType.text,
      ),
      status: MessageStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => MessageStatus.sent,
      ),
      timestamp: DateTime.parse(json['timestamp']),
      replyToId: json['replyToId'],
      metadata: json['metadata'],
      attachments: List<String>.from(json['attachments'] ?? []),
    );
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, senderId: $senderId, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class ChatRoom {
  final String id;
  final String name;
  final List<String> participants;
  final String? lastMessageId;
  final String? lastMessageContent;
  final DateTime? lastMessageTime;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;
  final bool isGroup;
  final String? orderId;

  ChatRoom({
    required this.id,
    required this.name,
    required this.participants,
    this.lastMessageId,
    this.lastMessageContent,
    this.lastMessageTime,
    DateTime? createdAt,
    this.metadata,
    this.isGroup = false,
    this.orderId,
  }) : createdAt = createdAt ?? DateTime.now();

  ChatRoom copyWith({
    String? id,
    String? name,
    List<String>? participants,
    String? lastMessageId,
    String? lastMessageContent,
    DateTime? lastMessageTime,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
    bool? isGroup,
    String? orderId,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      name: name ?? this.name,
      participants: participants ?? this.participants,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      lastMessageContent: lastMessageContent ?? this.lastMessageContent,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
      isGroup: isGroup ?? this.isGroup,
      orderId: orderId ?? this.orderId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'participants': participants,
      'lastMessageId': lastMessageId,
      'lastMessageContent': lastMessageContent,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
      'isGroup': isGroup,
      'orderId': orderId,
    };
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      name: json['name'],
      participants: List<String>.from(json['participants']),
      lastMessageId: json['lastMessageId'],
      lastMessageContent: json['lastMessageContent'],
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.parse(json['lastMessageTime'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      metadata: json['metadata'],
      isGroup: json['isGroup'] ?? false,
      orderId: json['orderId'],
    );
  }

  @override
  String toString() {
    return 'ChatRoom(id: $id, name: $name, participants: ${participants.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatRoom && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
