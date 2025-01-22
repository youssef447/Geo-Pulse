import 'package:dartz/dartz.dart';

import '../../../../core/error_handling/faliure.dart';
import '../../../request/data/models/request_model.dart';
import '../../domain/repository/approval_repo.dart';
import '../data_source/approval_remote_data_source.dart';

class ApprovalRepoImpl extends ApprovalRepo {
  final ApprovalRemoteDataSource remoteDataSource;

  ApprovalRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Faliure, void>> updateApprovals(
      RequestModel requestModel) async {
    try {
      await remoteDataSource.updateApprovals(requestModel);
      return Right(null);
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }
}
