import gleam/io
import gleam/int
import nibble/lexer

pub type Token {
  Number(Float)
  Plus
  Minus
  Star
  Slash
  RBrace
  LBrace
  RBracket
  LBracket
  RParen
  LParen
  Colon
  DoubleColon
  Arrow
  FatArrow
  Equal
  DoubleEqual
  Gt
  Gte
  Lt
  Lte
  NotEqual
  TildeEqual
  AtSign
  PoundSign
  Caret
  Bar
  DoubleBar
  Ampersand
  DoubleAmpersand
  DoubleGt
  DoubleLt
  LitStr(String)
}

pub type Ast

pub fn main() {
  io.println("Hello from gloop!")
}

pub fn get_lexer() {
  lexer.simple([
    lexer.number(fn(a) { Number(int.to_float(a)) }, Number(_)),
    lexer.token("+", Plus),
    lexer.token("-", Minus),
    lexer.token("*", Star),
    lexer.token("/", Slash),
    lexer.token("{", RBrace),
    lexer.token("}", LBrace),
    lexer.token("[", RBracket),
    lexer.token("]", LBracket),
    lexer.token("(", RParen),
    lexer.token(")", LParen),
    lexer.token(":", Colon),
    lexer.token("::", DoubleColon),
    lexer.token("->", Arrow),
    lexer.token("=>", FatArrow),
    lexer.token("=", Equal),
    lexer.token("==", DoubleEqual),
    lexer.token(">", Gt),
    lexer.token(">=", Gte),
    lexer.token("<", Lt),
    lexer.token("<=", Lte),
    lexer.token("!=", NotEqual),
    lexer.token("~=", TildeEqual),
    lexer.token("@", AtSign),
    lexer.token("#", PoundSign),
    lexer.token("^", Caret),
    lexer.token("|", Bar),
    lexer.token("||", DoubleBar),
    lexer.token("&", Ampersand),
    lexer.token("&&", DoubleAmpersand),
    lexer.token(">>", DoubleGt),
    lexer.token("<<", DoubleLt),
    lexer.string("\"", LitStr(_)),
    lexer.string("'", LitStr(_)),
    lexer.ignore(lexer.whitespace(Nil)),
  ])
}
