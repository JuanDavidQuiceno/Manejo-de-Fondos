class CustomFomatter {
  static final RegExp pass = RegExp('^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])');
  // static final RegExp pass =
  // RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
  static final RegExp email = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );
  static final RegExp url = RegExp(r'https?:\/\/(?:www\.)?[^\s/$.?#].[^\s]*');
  static final RegExp phone = RegExp(
    r'^(?:[+0]9)?[0-9]{5,10}$',
  ); //r'(^(?:[+0]9)?[0-9]{10,12}$
  static final RegExp number = RegExp(r'\B(?=(\d{3})+(?!\d))');
  // number phone
  static final RegExp numberPhone = RegExp('[^0-9-]');
  // Acepta solo letras de la a-z,A-Z y espacios
  static final RegExp onlyLetters = RegExp(r'[a-zA-Z\s ]');
  // only number
  static final RegExp onlyNumber = RegExp(r'^[0-9]*$');
  // acepta letras numero y guion medio
  static final RegExp onlyLettersNumberAndHyphen = RegExp(r'^[a-zA-Z0-9-]+$');
  // expersion regular para validar si el texto expieza con * y finaliza con *
  //y  elimina los * que cumplan con la condicion
  static final RegExp onlyLettersWithBold = RegExp(r'^\*.*\*[\.\,\?]?$');
  // Patrón que COINCIDE con caracteres NO permitidos
  static final denyUnwantedChars = RegExp('[^A-Za-z0-9-]');
}
