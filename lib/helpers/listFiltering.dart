

import 'dart:developer';

List<T> filterList<T>(List<T> inputList, bool Function(T) condition) {
  log('Filtering list...');
  List<T> output = inputList.where(condition).toList();
  log('Filtered list length: ${output.length}');
  return output;
}
