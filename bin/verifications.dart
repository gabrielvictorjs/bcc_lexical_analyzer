import 'token.dart';

final mathCharacters = Map.unmodifiable({
  '+': 'adição',
  '-': 'subtração',
  '/': 'divisão',
  '*': 'multiplicação',
});

final specialCharacters = List.unmodifiable([
  ...mathCharacters.entries.map((e) => e.key),
  ';',
  '=',
]);

abstract class TokenVerification {
  String get token;
  TokenVerification next;
  Token matchWith(String value);
}

class Type extends TokenVerification {
  @override
  String get token => 'Tipo';

  final _checkers = ['String', 'Number', 'Boolean'];

  @override
  Token matchWith(String value) {
    if (_checkers.contains(value.trim())) {
      return Token(value, token);
    }
    return next.matchWith(value);
  }
}

class FinishStatement extends TokenVerification {
  @override
  String get token => 'Fim da declaração';

  @override
  Token matchWith(String value) {
    if (value.trim() == ';') {
      return Token(value, token);
    }
    return next.matchWith(value);
  }
}

class EqualStatement extends TokenVerification {
  @override
  String get token => 'Atribuição';

  @override
  Token matchWith(String value) {
    if (value.trim() == '=') {
      return Token(value, token);
    }
    return next.matchWith(value);
  }
}

class MathOperator extends TokenVerification {
  @override
  String get token => 'Operador de';

  final _checkers = mathCharacters;

  @override
  Token matchWith(String value) {
    if (_checkers.containsKey(value.trim())) {
      return Token(value, '$token ${_checkers[value.trim()]}');
    }
    return next.matchWith(value);
  }
}

class StringValue extends TokenVerification {
  @override
  String get token => 'Valor de uma String';

  @override
  Token matchWith(String value) {
    final regex = RegExp(r'''(["'])(?:(?=(\\?))\2.)*?\1''');
    if (regex.hasMatch(value.trim())) {
      return Token(value, token);
    }
    return next.matchWith(value);
  }
}

class BooleanValue extends TokenVerification {
  @override
  String get token => 'Valor booleano';

  final _checkers = ['true', 'false'];

  @override
  Token matchWith(String value) {
    if (_checkers.contains(value.trim())) {
      return Token(value, token);
    }
    return next.matchWith(value);
  }
}

class NumberValue extends TokenVerification {
  @override
  String get token => 'Número';

  @override
  Token matchWith(String value) {
    final regex = RegExp(r'^[1-9]\d*(\.\d+)?$');
    if (regex.hasMatch(value.trim())) {
      return Token(value, token);
    }
    return next.matchWith(value);
  }
}

class Variable extends TokenVerification {
  @override
  String get token => 'Variável';

  @override
  Token matchWith(String value) {
    final regex = RegExp(r'^[a-zA-Z_$][a-zA-Z_$0-9]*$');
    if (regex.hasMatch(value.trim())) {
      return Token(value, token);
    }
    return null;
  }
}
