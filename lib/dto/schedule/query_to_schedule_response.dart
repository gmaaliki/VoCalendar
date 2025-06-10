class QueryToScheduleResponseDto {
  final String response;
  final bool isScheduleChanged;

  QueryToScheduleResponseDto({required this.response, required this.isScheduleChanged});

  Map<String, dynamic> toJson() {
    return {
      'response': response,
      'isScheduleChanged': isScheduleChanged,
    };
  }

  factory QueryToScheduleResponseDto.fromJson(Map<String, dynamic> json) {
    return QueryToScheduleResponseDto(
      response: json['response'],
      isScheduleChanged: json['isScheduleChanged'] ?? false,
    );
  }

}
