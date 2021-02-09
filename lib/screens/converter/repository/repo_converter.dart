import 'package:flutter/material.dart';
import 'package:jaynetwork/network/api_result.dart';
import 'package:mp3_music_converter/error_handler/handler.dart';
import 'package:mp3_music_converter/screens/converter/model/youtube_model.dart';
import 'package:mp3_music_converter/utils/instance.dart';

class ConverterRepo {
  Future<ApiResponse<YoutubeModel>> convert() async {
    try {
      final response = await jayNetworkClient.makeGetRequest("youtubetomp3");
      return ApiResponse.success(data: YoutubeModel.fromJson(response.data));
    } catch (e) {
      return handleNetworkException(e);
    }
  }
}
