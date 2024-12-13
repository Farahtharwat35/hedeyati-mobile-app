import 'dart:developer';

List<Map<String, dynamic>> dbResultTypesConverter(
    List<Map<String, dynamic>> dbResult,
    List<Map<String, String>> columnsToConvert,
    ) {
  log('============ Converting database result to model types ===============');
  List<Map<String, dynamic>> models = [];

  // Iterating through each record in the database result
  for (var element in dbResult) {
    Map<String, dynamic> convertedElement = {};

    // Iterating through columnsToConvert and performing conversion
    for (var column in columnsToConvert) {
      column.forEach((columnName, columnType) {
        if (element.containsKey(columnName)) {
          // Checking the type and converting accordingly
          if (columnType == 'bool') {
            // Converting 0/1 to bool
            convertedElement[columnName] = element[columnName] == 1;
            log('Converted $columnName to bool: ${convertedElement[columnName]}');
          } else if (columnType == 'int') {
            // Handling int conversion
            convertedElement[columnName] = element[columnName] is int
                ? element[columnName]
                : int.tryParse(element[columnName].toString()) ?? 0;
            log('Converted $columnName to int: ${convertedElement[columnName]}');
          } else if (columnType == 'String') {
            // Handling string conversion
            convertedElement[columnName] = element[columnName].toString();
            log('Converted $columnName to String: ${convertedElement[columnName]}');
          }
        }
      });
    }

    // Adding any unconverted fields
    element.forEach((key, value) {
      if (!convertedElement.containsKey(key)) {
        convertedElement[key] = value;
      }
    });

    models.add(convertedElement);
  }

  return models;
}
