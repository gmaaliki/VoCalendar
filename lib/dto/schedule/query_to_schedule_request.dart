class QueryToScheduleRequestDto {
  final String user_id;
  final String query;

  QueryToScheduleRequestDto({required this.user_id, required this.query});

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'query': query,
    };
  }
}
