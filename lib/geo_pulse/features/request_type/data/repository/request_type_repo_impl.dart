import 'package:dartz/dartz.dart';

import '../../../../core/error_handling/faliure.dart';
import '../../domain/request_type_repo.dart';
import '../data_source/request_type_remote_data_source.dart';
import '../models/request_type_model.dart';

class RequestTypeRepoImpl extends RequestTypeRepo {
  final RequestTypeRemoteDataSource requestTypeRemoteDataSource;
  RequestTypeRepoImpl({required this.requestTypeRemoteDataSource});
  @override

  /// Adds a new request type to the database.
  Future<Either<Faliure, void>> addNewRequestType(
      RequestTypeModel requestTypeModel) async {
    try {
      // Add the new request type to the database
      await requestTypeRemoteDataSource.addNewRequestType(
          requestTypeModel, DateTime.now().toString());

      // Return a Right with a null value if the operation is successful
      return Right(null);
    } catch (e) {
      // Return a Left with a Faliure if the operation fails
      return Left(Faliure(message: e.toString()));
    }
  }

  @override

  /// Deletes a request type from the database.

  Future<Either<Faliure, void>> deleteReqType(
      RequestTypeModel requestTypeModel) async {
    try {
      await requestTypeRemoteDataSource.deleteReqType(requestTypeModel);

      return Right(null);
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }

  /// Gets all active request types from the database.

  @override
  Future<Either<Faliure, List<RequestTypeModel>>> getRequestTypes() async {
    List<RequestTypeModel> requestTypes = [];
    try {
      final result = await requestTypeRemoteDataSource.getRequestTypes();
      requestTypes = List.generate(
          result.length,
          (index) => RequestTypeModel.fromJson(
              result[index].data() as Map<String, dynamic>));

      return Right(requestTypes);
    } catch (e) {
      return Left(Faliure(message: e.toString()));
      // Attempt to get the request types from the remote data source
    }
  }

  @override

  /// Updates an existing request type in the database.

  Future<Either<Faliure, void>> updateRequestType(
      RequestTypeModel requestTypeModel) async {
    try {
      await requestTypeRemoteDataSource.updateRequestType(requestTypeModel);

      return Right(null);
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }
}
