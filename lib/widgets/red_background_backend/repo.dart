
import 'package:jaynetwork/network/api_result.dart';
import 'package:mp3_music_converter/error_handler/handler.dart';
import 'package:mp3_music_converter/utils/instance.dart';

class RedBackgroundRepo {
  Future<ApiResponse> image(Map map) async {
    try {
      final response =
      await jayNetworkClient.makePostRequest("updatepic", data: map);
      return ApiResponse.success(data: response);
    } catch (e) {
      return handleNetworkException(e);
    }
  }
}
