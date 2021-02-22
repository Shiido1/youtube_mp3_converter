
import 'package:jaynetwork/network/api_result.dart';
import 'package:mp3_music_converter/error_handler/handler.dart';
import 'package:mp3_music_converter/save_convert/model/save_convert_model.dart';
import 'package:mp3_music_converter/utils/instance.dart';

class SaveConvertRepo {
  Future<ApiResponse<SaveConvert>> saveConvert(Map id) async {
    try {
      final response =
          await jayNetworkClient.makePostRequest("saveconvert", data: id);
      return ApiResponse.success(data: SaveConvert.fromJson(response.data.data));
    } catch (e) {
      return handleNetworkException(e);
    }
  }
}
