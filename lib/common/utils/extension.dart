extension RoutePath on String {
  String get path {
    return "/$this";
  }

  String get rootPath {
    return "/";
  }
}

extension UserName on String {
  String get addUserName {
    return "@$this";
  }
}

extension DoubleFormatter on double {
  String get formatPrice {
    return (this % 1 == 0) ? toInt().toString() : toStringAsFixed(2);
  }
}

extension AddRsPrefix on String {
  String get addRsPrefix {
    return "Rs.$this";
  }
}
