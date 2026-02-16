

extension MyStringExtension on String {

  bool isNumeric() {
    return double.tryParse(this) != null;
  }

  bool isFileURL() {
    final urlPattern = r'^(https?:\/\/)?(([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,})([\/\w .-]*)*\/?$';
    final regex = RegExp(urlPattern);
    return regex.hasMatch(this);
  }

  bool isValidURL() {
    try {
      // Try to parse the string as a URI
      Uri uri = Uri.parse(this);

      // Check if the URI has a scheme (http, https, etc.) and is not empty
      return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      // If parsing fails, it's not a valid URL
      return false;
    }
  }

}

String toCamelCase(String input) {
  // Split the input string by spaces or underscores
  List<String> words = input.split(RegExp(r'[\s_]+'));

  // Capitalize the first letter of each word except the first one
  for (int i = 1; i < words.length; i++) {
    words[i] = words[i].substring(0, 1).toUpperCase() + words[i].substring(1).toLowerCase();
  }

  // Join all words together to form the camelCase string
  return words.join('');
}
String toFirstLetterCapitalCase(String input) {
  // Split the string into words by spaces
  List<String> words = input.split(RegExp(r'[\s_]+'));

  // Capitalize the first letter of each word and make the rest lowercase
  for (int i = 0; i < words.length; i++) {
    if (words[i].isNotEmpty) {
      words[i] = words[i].substring(0, 1).toUpperCase() + words[i].substring(1).toLowerCase();
    }
  }

  // Join the words back into a single string with spaces
  return words.join(' ');
}