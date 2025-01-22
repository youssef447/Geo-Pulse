import 'package:dartz/dartz.dart';

import '../../../core/error_handling/faliure.dart';
import '../data/models/location_model.dart';

abstract class LocationRepo {
  Future<Either<Faliure, void>> addLocation(LocationModel newLocationModel);
  Future<Either<Faliure, void>> editLocation(LocationModel locationModel);
  Future<Either<Faliure, List<LocationModel>>> getAllLocations();
}
