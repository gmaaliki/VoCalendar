class Chat {
  final int user_id;
  final String query;

  Chat({required this.user_id, required this.query});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      user_id: json['user_id'],
      query: json['query'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'query': query,
    };
  }
}
