import 'package:dartz/dartz.dart';

import '../../../core/error_handling/faliure.dart';
import '../data/models/request_type_model.dart';

abstract class RequestTypeRepo {
  Future<Either<Faliure, void>> deleteReqType(
      RequestTypeModel requestTypeModel);
  Future<Either<Faliure, void>> updateRequestType(
      RequestTypeModel requestTypeModel);
  Future<Either<Faliure, void>> addNewRequestType(
      RequestTypeModel requestTypeModel);
  Future<Either<Faliure, List<RequestTypeModel>>> getRequestTypes();
}
