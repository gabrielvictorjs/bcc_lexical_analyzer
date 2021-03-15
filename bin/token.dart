class Token {
  final String lexeme;
  final String token;

  Token(this.lexeme, this.token);

  @override
  String toString() => 'lexeme: | $lexeme |, token: $token';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Token &&
      other.lexeme == lexeme &&
      other.token == token;
  }

  @override
  int get hashCode => lexeme.hashCode ^ token.hashCode;
}
