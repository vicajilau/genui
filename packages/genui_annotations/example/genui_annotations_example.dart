import 'package:genui_annotations/genui_annotations.dart';

void main() {
  var awesome = GenerativeUI(name: 'AwesomeComponent');
  print('awesome: ${awesome.name}');
  
  var awesome2 = GenerativeUI();
  print('awesome2: ${awesome2.name}');
}
