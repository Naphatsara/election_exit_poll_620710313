class ApiResult {
  final String status;
  final String? message;
  final dynamic data;

  ApiResult({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ApiResult.fromJson(Map<String, dynamic> json) { // factory ต้องทำการ return เองแล้วเลือกได้ว่าจะ return อะไร ในที่นี้คือ return instance
    return ApiResult(
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }
}