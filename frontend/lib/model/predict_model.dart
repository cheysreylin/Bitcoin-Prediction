class PredictModel {
  String? predict;

  PredictModel({
    this.predict,
  });

  PredictModel.fromJson(Map<String, dynamic> json) {
    predict = json['predict'].toString();
  }
}
