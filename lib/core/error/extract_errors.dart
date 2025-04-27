import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:task_manager/core/error/failures.dart';

class ErrorHelpers {
  static String? extractErrorMessage(dynamic responseData) {
    if (responseData == null) return null;
    if (responseData is String) return responseData;
    if (responseData is Map) {
      return responseData['message']?.toString() ??
          responseData['error']?.toString() ??
          responseData['detail']?.toString();
    }
    return responseData.toString();
  }

  static String handleDioError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final errorMessage = extractErrorMessage(e.response?.data);

      if (statusCode == 401) {
        return errorMessage ?? 'Unauthorized access';
      }
      if (statusCode == 404) {
        return errorMessage ?? 'Resource not found';
      }
      if (statusCode == 400) {
        return errorMessage ?? 'Invalid request';
      }
      if (statusCode == 500) {
        return errorMessage ?? 'Internal server error';
      }

      return errorMessage ?? 'Server error (status $statusCode)';
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.connectionError:
        return 'Connection timeout. Please check your internet connection';
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Request timeout. Please try again';
      default:
        return e.message ?? 'Network error occurred';
    }
  }

  static void handleAuthError(Failure failure) {
    String message;

    if (failure is UnauthorizedFailure) {
      message = 'Session expired. Please login again';
    } else if (failure is NetworkFailure) {
      message = 'Connection error: ${failure.message}';
    } else {
      message = failure.message;
    }

    Get.snackbar('Error', message,
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 5),);
  }
}
