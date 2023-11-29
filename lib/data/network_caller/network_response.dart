class NetworkResponse {
  final int? statusCode;
  final bool isSuccess;
  final Map<String, dynamic>? jsonResponse;
  final String? errorMessage;

  NetworkResponse(
      {this.statusCode = -1,
        required this.isSuccess,
        this.jsonResponse = null,
        this.errorMessage = 'Something Went Wrong'});
}