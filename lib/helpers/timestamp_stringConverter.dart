import 'package:cloud_firestore/cloud_firestore.dart';

Map<String, Object?> timestampStringConverter(
    Map<String, Object?> values,
    {List<String> timeStampKeys = const ['createdAt', 'updatedAt']}) {
  values.forEach((key, value) {
    print("-------Key: $key, Value: $value------ , Type: ${value.runtimeType}");
    if (timeStampKeys.contains(key) && value != null) {
      print("Before Conversion $key to String: ${values[key].runtimeType}");
      values[key] = (value as Timestamp).toDate().toIso8601String();
      print("After Conversion $key to String: ${values[key]}");
    } else {
      values[key] = value;
    }
  });

  return values;
}


