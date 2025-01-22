import 'package:dartz/dartz.dart';



import '../../../../core/error_handling/faliure.dart';
import '../../domain/location_repo.dart';
import '../data_source/location_remote_data_source.dart';
import '../models/location_model.dart';

class LocationRepoImpl extends LocationRepo {
  final LocationRemoteDataSource locationRemoteDataSource;

  LocationRepoImpl({required this.locationRemoteDataSource});

  @override
  Future<Either<Faliure, void>> addLocation(
      LocationModel newLocationModel) async {
    try {
      await locationRemoteDataSource.addLocation(newLocationModel);
      return Right(null);
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Faliure, void>> editLocation(
      LocationModel locationModel) async {
    try {
      await locationRemoteDataSource.editLocation(locationModel);
      return Right(null);
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Faliure, List<LocationModel>>> getAllLocations() async {
    try {
      List<LocationModel> dataList =
          await locationRemoteDataSource.getAllLocations();
      return Right(dataList);
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }
}
