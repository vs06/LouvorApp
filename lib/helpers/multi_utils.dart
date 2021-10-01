class MultiUtils {

  ///usado para definir a altura de tiles om base na qtd de itens
  static double calculaHeightTile(int length) {
    if(length>2){
      double  qtdLines = length/2;
      return (qtdLines.round() * 40).toDouble();
    }
    return 40;
  }

}