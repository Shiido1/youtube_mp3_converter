import 'package:jaynetwork/network/api_result.dart';
import 'package:mp3_music_converter/error_handler/handler.dart';
import 'package:mp3_music_converter/screens/world_radio/model/radio_model.dart';
import 'package:mp3_music_converter/utils/instance.dart';

class RadioRepo{
  Future<ApiResponse<RadioModel>> radiox(Map map) async {
    try {
      final res = await jayNetworkClient.makePostRequest("radiox", data: map);
      return ApiResponse.success(data: RadioModel.fromJson(res.data));
    } catch (e) {
      return handleNetworkException(e);
    }
  }
}