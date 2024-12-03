class QueryArg {
  Object? isEqualTo;
  Object? isNotEqualTo;
  Object? isLessThan;
  Object? isLessThanOrEqualTo;
  Object? isGreaterThan;
  Object? isGreaterThanOrEqualTo;
  Object? arrayContains;
  Iterable<Object?>? arrayContainsAny;
  Iterable<Object?>? whereIn;
  Iterable<Object?>? whereNotIn;
  bool? isNull;
  QueryArg(
      {this.isEqualTo,
        this.isNotEqualTo,
        this.isLessThan,
        this.isLessThanOrEqualTo,
        this.isGreaterThan,
        this.isGreaterThanOrEqualTo,
        this.arrayContains,
        this.arrayContainsAny,
        this.whereIn,
        this.whereNotIn,
        this.isNull});
  Map<Symbol, dynamic> argMap() {
    Map<Symbol, dynamic> argMap = {};
    if (isEqualTo != null) {
      argMap[#isEqualTo] = isEqualTo;
    }
    if (isNotEqualTo != null) {
      argMap[#isNotEqualTo] = isNotEqualTo;
    }
    if (isLessThan != null) {
      argMap[#isLessThan] = isLessThan;
    }
    if (isLessThanOrEqualTo != null) {
      argMap[#isLessThanOrEqualTo] = isLessThanOrEqualTo;
    }
    if (isGreaterThan != null) {
      argMap[#isGreaterThan] = isGreaterThan;
    }
    if (isGreaterThanOrEqualTo != null) {
      argMap[#isGreaterThanOrEqualTo] = isGreaterThanOrEqualTo;
    }
    if (arrayContains != null) {
      argMap[#arrayContains] = arrayContains;
    }
    if (arrayContainsAny != null) {
      argMap[#arrayContainsAny] = arrayContainsAny;
    }
    if (whereIn != null) {
      argMap[#whereIn] = whereIn;
    }
    if (whereNotIn != null) {
      argMap[#whereNotIn] = whereNotIn;
    }
    if (isNull != null) {
      argMap[#isNull] = isNull;
    }
    return argMap;
  }
}