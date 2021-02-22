import 'package:flutter/cupertino.dart';
import 'package:jaynetwork/jaynetwork.dart';
import 'package:mp3_music_converter/error_handler/handler.dart';
import 'package:mp3_music_converter/screens/otp/model/otp_model.dart';
import 'package:mp3_music_converter/utils/instance.dart';

class OtpApiRepository {
  Future<ApiResponse<OtpModel>> verify({@required Map data}) async {
    try {
      final response =
          await jayNetworkClient.makePostRequest("verify", data: data);
      return ApiResponse.success(data: OtpModel.fromJson(response.data));
    } catch (e) {
      return handleNetworkException(e);
    }
  }

  Future<ApiResponse<OtpModel>> resend({@required String email}) async {
    try {
      final response = await jayNetworkClient.makeGetRequest(
        "verify/resend?email=$email&channel=email",
      );
      return ApiResponse.success(data: OtpModel.fromJson(response.data));
    } catch (e) {
      return handleNetworkException(e);
    }
  }
}
