class MultiUtils {

  ///usado para definir a altura de tiles om base na qtd de itens
  static double calculaHeightTile(int length) {
    if(length>2){
      double  qtdLines = length/2;
      return (qtdLines.round() * 40).toDouble();
    }
    return 40;
  }

  static bool isListNotNullNotEmpty(Iterable iterable) {
    return iterable != null && iterable.length > 0;
  }

  static bool isMapNotNullNotEmpty(Map map) {
    return map != null && map.length > 0;
  }
}