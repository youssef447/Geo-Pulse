import 'package:dartz/dartz.dart';

import '../../../core/error_handling/faliure.dart';
import '../data/models/request_model.dart';

abstract class RequestRepo {
  Future<Either<Faliure, void>> sendReminder(
      RequestModel requestModel, String supervisor);
  Future<Either<Faliure, void>> sendRequest(
      {required RequestModel requestModel,
      required String requestId,
      required String userId});
  Future<Either<Faliure, List<RequestModel>>> getRequests(String userId);
  Future<Either<Faliure, List<RequestModel>>> getAllRequests([String? dep]);
  Future<Either<Faliure, List<RequestModel>>> getRequiredRequests();
}
