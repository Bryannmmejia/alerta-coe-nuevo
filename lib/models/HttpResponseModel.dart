class HttpResponseModel<T> {
  final int httpStatus;
  final String message;
  final bool hasError;
  final T data;

  HttpResponseModel({
    required this.data,
    required this.hasError,
    required this.httpStatus,
    required this.message,
  });

  factory HttpResponseModel.fromJson(Map<String, dynamic> json) {
    return HttpResponseModel(
        data: json['data'],
        hasError: json['hasError'],
        httpStatus: json['httpStatus'],
        message: json['message']);
  }
}
