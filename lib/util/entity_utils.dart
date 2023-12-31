class EntityUtil {
  static bool idIsEmpty(String? id) {
    if (id == null || id.isEmpty) return true;
    for (int i = 0; i < id.length; i++) {
      if (id[i] != "0") return false;
    }
    return true;
  }
}
