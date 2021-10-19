class MultiUtils {

  ///usado para definir a altura de tiles om base na qtd de itens
  static double calculaHeightTile(int length) {
    return (40 * length).toDouble();
  }

  static bool isListNotNullNotEmpty(Iterable? iterable) {
    return iterable != null && iterable.length > 0;
  }

  static bool isMapNotNullNotEmpty(Map? map) {
    return map != null && map.length > 0;
  }
}