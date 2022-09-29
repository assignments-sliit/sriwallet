String nicValidator(String? input) {
  String pattern = r'^([0-9]{9}[x|X|v|V]|[0-9]{12})$)';
  //regexp obtained from https://www.regextester.com/100137
  RegExp exp = RegExp(pattern);

  if (exp.hasMatch(input!)) {
    return "";
  } else {
    return "INVALID NIC";
  }
}

String emailValidator(String? input) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(input!)) {
    return "INVALID EMAIL";
  } else {
    return "";
  }
}
