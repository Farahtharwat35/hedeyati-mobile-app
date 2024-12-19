

List<T> filterList<T>(List<T> inputList, bool Function(T) condition) {
  return inputList.where(condition).toList();
}
