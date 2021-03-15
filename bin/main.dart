import 'dart:convert';
import 'dart:io';

import 'token.dart';
import 'verifications.dart';

void main(List<String> arguments) async {
  var exec = 's';
  while (exec == 's') {
    String file;
    // Ler o arquivo para analise
    try {
      file = await File('input.txt').readAsString();
    } catch (_) {
      print('Digite um caminho válido!');
    }

    // Cria uma copia dos code units do arquivo
    final codeUnits = List.of(file.codeUnits);

    // transforma os code units em string
    final characters =
        codeUnits.map((e) => utf8.decode([e])).toList(growable: false);

    // extraindo lexemas
    final values = extractLexemes(characters);

    // verificando tokens
    final tokens = values.map((e) => verifyTokens(e)).toSet()..remove(null);

    tokens.forEach(print);

    print('~ Abra o arquivo input.txt edite e execute novamente');
    print('Digite "s" para continuar');
    exec = stdin.readLineSync(encoding: Encoding.getByName('utf-8'));
  }
}

List<String> extractLexemes(List<String> characters) {
  final values = <String>[];
  var control = '';
  void addControlToValues() {
    if (control.isNotEmpty) values.add(control);
    control = '';
  }

  characters.forEach((element) {
    // verifica se inicia com ' para ignorar o espaço em branco
    if (control.split('').isNotEmpty && control.split('').first == '\'') {
      control += element;

      if (control.split('').last == '\'') {
        addControlToValues();
      }
    } else {
      // verifica se eh um espaço em branco e adiciona a control atual
      if (element == ' ' || element == '\n') {
        addControlToValues();
      }
      // verifica se eh uma caractere especial e adiciona o control atual
      // e adiciona o caractere especial
      else if (specialCharacters.contains(element)) {
        addControlToValues();
        values.add(element);
      } else {
        control += element;
      }
    }
  });

  addControlToValues();
  return values;
}

Token verifyTokens(String value) {
  final type = Type();
  final finishStatement = FinishStatement();
  final equalStatement = EqualStatement();
  final mathOperator = MathOperator();
  final stringValue = StringValue();
  final booleanValue = BooleanValue();
  final numberValue = NumberValue();
  final variable = Variable();

  type.next = finishStatement;
  finishStatement.next = equalStatement;
  equalStatement.next = mathOperator;
  mathOperator.next = stringValue;
  stringValue.next = booleanValue;
  booleanValue.next = numberValue;
  numberValue.next = variable;

  return type.matchWith(value);
}
