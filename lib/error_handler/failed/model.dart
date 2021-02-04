class FailedOrNormalResponsesModel {
  String message;

  FailedOrNormalResponsesModel({this.message,});

  FailedOrNormalResponsesModel.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? null;
  }
}
