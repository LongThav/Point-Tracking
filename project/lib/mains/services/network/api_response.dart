import 'api_status.dart';

class ApiResponse<T> {
  Loadingstatus? status;
  T? data;
  String? message;

  ApiResponse(this.status, this.data, this.message);

  ApiResponse.loading() : status = Loadingstatus.loading;

  ApiResponse.completed(this.data) : status = Loadingstatus.complete;

  ApiResponse.error(this.message) : status = Loadingstatus.error;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data: $data";
  }
}
