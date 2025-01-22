import 'package:cloud_firestore/cloud_firestore.dart';

class Faliure {
  String message;
  Faliure({required this.message});
}

class ServiceFailure extends Faliure {
  ServiceFailure(String message) : super(message: message);

  factory ServiceFailure.fromFirebase(FirebaseException err) {
    switch (err.code) {
      case '400' || '401' || '403':
        return ServiceFailure(err.message!);

      case '404':
        return ServiceFailure('Your request not found, Please try later!');

      case '500':
        return ServiceFailure('Internal Server error, Please try later');

      default:
        return ServiceFailure('Opps There was an Error, Please try again');
    }
  }
}
