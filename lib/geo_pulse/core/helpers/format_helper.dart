// Date: 23/10/2024
// Last update: 23/10/2024

abstract class FormatHelper {
  static String capitalize(String input) {
    if (input.isEmpty) {
      return "";
    }

    List<String> words = input.split(" ");
    words = words.map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      } else {
        return "";
      }
    }).toList();

    return words.join(" ");
  }
}
