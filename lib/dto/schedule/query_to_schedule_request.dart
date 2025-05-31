class PostRequestDto {
  final String title;
  final String body;

  PostRequestDto({required this.title, required this.body});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': body, // Note: API expects "content" instead of "body"
    };
  }
}
