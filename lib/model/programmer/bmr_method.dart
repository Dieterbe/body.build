enum BMRMethod {
  cunningham,
  tinsley,
  tenHaaf;

  String get displayName {
    switch (this) {
      case BMRMethod.cunningham:
        return 'Cunningham 1991';
      case BMRMethod.tinsley:
        return 'Tinsley';
      case BMRMethod.tenHaaf:
        return 'Ten Haaf';
    }
  }
}
