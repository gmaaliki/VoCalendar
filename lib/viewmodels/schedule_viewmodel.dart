import 'package:flutter/foundation.dart';
import 'package:flutterapi/dto/schedule/query_to_schedule_response.dart';
import 'package:flutterapi/dto/schedule/query_to_schedule_request.dart';
import '../api/chat_api.dart';

class ScheduleViewModel extends ChangeNotifier {
  final ChatApi _chatApi;
  // final ScheduleService _scheduleService;

  ScheduleViewModel(
      this._chatApi,
      // this._scheduleService
  );

  bool isLoading = false;
  String? error;

  // TODO: jadikan void return karena viewmodel, return dto hanya untuk testing
  Future<String?> generateScheduleFromQuery(String query) async {
    isLoading = true;
    notifyListeners();

    QueryToScheduleResponseDto? responseDto;
    Map<String, dynamic> jsonResponse  = {};
    String? response = null;
    try {
      jsonResponse = await _chatApi.postChat(QueryToScheduleRequestDto(user_id: 0, query: query));
      responseDto = QueryToScheduleResponseDto.fromJson(jsonResponse);
      response = responseDto?.toJson()['response'];
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
    print(jsonResponse);
    print(responseDto);
    print(response);
    return response;
  }
}