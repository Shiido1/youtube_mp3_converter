import 'package:jaynetwork/jaynetwork.dart';

import 'failed/model.dart';

ApiResponse<dynamic> handleNetworkException(e) {
  try {
    final _response = FailedOrNormalResponsesModel.fromJson(e.response.data);
    return ApiResponse.failure(
      error: NetworkExceptions.getJayNetworkException(e),
      statusMessage: _response.message,
    );
  } catch (_) {
    return ApiResponse.failure(
      error: NetworkExceptions.getJayNetworkException(e),
    );
  }
}
