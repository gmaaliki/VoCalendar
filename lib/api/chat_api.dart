import 'package:flutterapi/dto/schedule/query_to_schedule_request.dart';
import 'package:flutterapi/dto/schedule/query_to_schedule_response.dart';
import 'package:flutterapi/api/api.dart';

class ChatApi extends Api {
  Future<Map<String, dynamic>> postChat(QueryToScheduleRequestDto chat) async {
    final response = await post('/chat', chat.toJson());
    return response;
  }
}
