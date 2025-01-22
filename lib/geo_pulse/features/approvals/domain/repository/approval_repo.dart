import 'package:dartz/dartz.dart';
import '../../../../core/error_handling/faliure.dart';
import '../../../../features/request/data/models/request_model.dart';

abstract class ApprovalRepo {
  Future<Either<Faliure, void>> updateApprovals(RequestModel requestModel);
}
