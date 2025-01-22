import 'package:get/get.dart';

abstract class ValidationHelper {
  /// Validates a given string as an email.
  ///
  /// The given string is a valid email if it matches the following pattern:
  ///   ^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$
  ///
  /// If the given string is not a valid email, the function returns a localized
  /// error message. Otherwise, it returns null.
  static String? email(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return Get.locale.toString().contains("en")
          ? 'Invalid Email'.tr
          : 'حساب غير صحيح';
    } else {
      return null;
    }
  }

  /// Validates a given string as a valid name.
  ///
  /// A valid name is considered a name that:
  ///   - Is not empty
  ///   - Contains at least one letter
  ///   - Contains only letters and numbers
  ///   - Has a length of at least 2
  ///
  /// If the given string is not a valid name, the function returns the provided
  /// error message. Otherwise, it returns null.
  String? name(String? value, String invalid) {
    if (value == null || value.isEmpty) {
      return invalid;
    }
    String pattern = r'^(?=.*[a-zA-Z])[a-zA-Z0-9]+$';
    RegExp regex = RegExp(pattern, unicode: true);
    if (!regex.hasMatch(value) || value.length <= 1) {
      return invalid;
    } else {
      return null;
    }
  }

  /// Validates if a given string contains only English characters.
  ///
  /// The given string is valid if it contains only English letters.
  ///
  /// If the given string is not valid, the function returns a localized error
  /// message. Otherwise, it returns null.
  static String? isEnglish(String? value) {
    final RegExp english = RegExp(r'^[a-zA-Z]+');
    if (value != null && !english.hasMatch(value)) {
      return 'Please Enter The Text In English Language'.tr;
    } else {
      return null;
    }
  }

  /// Checks if the given string is written in Arabic language.
  ///
  /// The given string is written in Arabic language if it matches the following pattern:
  ///   ^[\u0621-\u064A]+$
  /// This pattern allows only Arabic characters.
  ///
  /// If the given string is not written in Arabic language, this function returns
  /// 'Please Enter The Text In Arabic Language'. Otherwise, it returns null.
  static String? isArabic(String? value) {
    final RegExp arabic = RegExp(r'^[\u0621-\u064A]+');
    if (value != null && !arabic.hasMatch(value)) {
      return 'Please Enter The Text In Arabic Language'.tr;
    } else {
      return null;
    }
  }

  /// Validates a given string as a generic text.
  ///
  /// The given string is considered a valid text if it matches the following pattern
  /// This pattern allows for alphabetic characters, numbers, spaces, and certain punctuation marks.
  ///
  /// If the given string is not a valid text or its length is less than or equal to 1,
  /// the function returns the provided error message. Otherwise, it returns null.
  static String? text(String? value, String invalid) {
    String pattern = r"^[a-zA-Z0-9\s.,#-]+$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!) || value.length <= 1) {
      return invalid;
    } else {
      return null;
    }
  }

  /// Validates a given string as a country name.
  ///
  /// The given string is considered a valid country name if it consists only
  /// of alphabetic characters and spaces.
  ///
  /// If the given string is not a valid country name, the function returns
  /// a localized error message. Otherwise, it returns null.
  static String? countryName(String? value) {
    String pattern = r'^[a-zA-Z\s]+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return Get.locale.toString().contains('en')
          ? 'Invalid Country Name'
          : "اسم الدولة غير صالح";
    } else {
      return null;
    }
  }

  /// Validates a given string as a postal code.
  ///
  /// The given string is considered a valid postal code if it matches the following pattern
  /// This pattern allows for a 5-digit postal code, optionally followed by a separator and 4 more digits.
  ///

  static String? postalCode(String? value) {
    String pattern = r'^\d{5}(?:[-\s]?\d{4})?$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return Get.locale.toString().contains('en')
          ? 'Invalid Postal Code'
          : "الرمز البريدي غير صالح";
    } else {
      return null;
    }
  }

  /// Checks if a given string is null or empty.
  ///
  /// If the given string is null or empty, the function returns a localized
  /// error message. Otherwise, it returns null.
  static dynamic isEmpty(String? value, String label) {
    if (value == null || value.isEmpty) {
      return "${label.tr} ${'Required'.tr}";
    } else {
      return null;
    }
  }

  /// Validates a given string as a valid ID.
  ///
  /// A valid ID is considered a string that:
  ///   - Is not empty
  ///   - Contains only letters and numbers
  ///
  /// If the given string is not a valid ID, the function returns the provided
  /// error message. Otherwise, it returns null.
  static String? id(String? value) {
    if (value == null || value.isEmpty) {
      return Get.locale.toString().contains('en')
          ? 'ID Required'
          : 'الرمز التعريفي مطلوب'.tr;
    }
    String pattern = r'^[a-zA-Z0-9]+$';
    RegExp regex = RegExp(pattern, unicode: true);
    if (!regex.hasMatch(value) || value.isEmpty) {
      return Get.locale.toString().contains('en')
          ? 'Invalid ID'
          : "الرمز التعريفي غير صالح";
    } else {
      return null;
    }
  }

  /// Checks if the given string is a valid phone number.

  /// This pattern checks for a phone number starting with 010, 011, 012, or 015,
  /// followed by 8 digits.
  ///
  /// If the given string is a valid phone number, the function returns true.
  /// Otherwise, it returns false.
  static String? isPhoneNumberValid(String? value) {
    if (value == null || value.isEmpty) {
      return Get.locale.toString().contains('en')
          ? 'Phone Number Required'
          : 'رقم الهاتف مطلوب'.tr;
    }
    String pattern = r'^(010|011|012|015)[0-9]{8}$';
    RegExp regex = RegExp(pattern, unicode: true);

    if (!regex.hasMatch(value) || value.isEmpty) {
      return Get.locale.toString().contains('en')
          ? 'Invalid Phone Number'
          : "رقم الهاتف غير صالح";
    } else {
      return null;
    }
  }

  /// Validates if the given string is a valid number.

  static String? number(String? value, String invalidMessage) {
    if (value == null || value.isEmpty) {
      return invalidMessage;
    }
    String pattern = r'^\d+$'; // Matches only digits
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return '${'Invalid'.tr} ${invalidMessage.tr}';
    }
    return null;
  }

  /// Validates if the given string is a valid double.
  ///
  /// A valid double consists of digits, and may include a decimal point.
  /// If the number doesn't meet this criterion or is null/empty,
  /// the function returns a localized error message. Otherwise, it returns null.
  static String? isDouble(String? value, String invalidMessage) {
    if (value == null || value.isEmpty) {
      return invalidMessage;
    }
    String pattern =
        r'^-?\d+(\.\d+)?$'; // Matches integers or floating-point numbers
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return invalidMessage;
    }
    return null;
  }
}
