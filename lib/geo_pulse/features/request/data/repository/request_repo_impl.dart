import 'package:dartz/dartz.dart';

import '../../../../core/error_handling/faliure.dart';
import '../../domain/request_repo.dart';
import '../data_source/request_remote_data_source.dart';
import '../models/request_model.dart';

class RequestRepoImpl extends RequestRepo {
  final RequestRemoteDataSource requestRemoteDataSource;

  RequestRepoImpl({required this.requestRemoteDataSource});
  @override
  Future<Either<Faliure, List<RequestModel>>> getRequests(String userId) async {
    List<RequestModel> requests = [];
    try {
      final response = await requestRemoteDataSource.getRequests(userId);
      requests = List.generate(
        response.length,
        (index) => RequestModel.fromMap(
            response[index].data() as Map<String, dynamic>),
      );

      return Right(requests);
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Faliure, List<RequestModel>>> getRequiredRequests() async {
    List<RequestModel> requests = [];
    try {
      requests = await requestRemoteDataSource.getRequiredRequests();
      return Right(requests);
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Faliure, void>> sendReminder(
      RequestModel requestModel, String supervisor) async {
    try {
      // Attempt to send the reminder to the remote data source
      await requestRemoteDataSource.sendReminder(requestModel, supervisor);

      return Right(null);
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Faliure, void>> sendRequest(
      {required RequestModel requestModel,
      required String requestId,
      required String userId}) async {
    try {
      await requestRemoteDataSource.sendRequest(
        requestModel: requestModel,
        userId: userId,
        requestId: requestId,
      );

      return Right(null);
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Faliure, List<RequestModel>>> getAllRequests(
      [String? dep]) async {
    List<RequestModel> requests = [];

    try {
      requests = await requestRemoteDataSource.getAllRequests(dep);
      return Right(requests);
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }
}
