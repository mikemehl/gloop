import gleeunit
import gleeunit/should
import gleam/io
import gloop.{
  Ampersand, Arrow, AtSign, Bar, Caret, Colon, DoubleAmpersand, DoubleBar,
  DoubleColon, DoubleEqual, DoubleGt, DoubleLt, Equal, FatArrow, Gt, Gte, LBrace,
  LBracket, LParen, LitStr, Lt, Lte, Minus, NotEqual, Number, Plus, PoundSign,
  RBrace, RBracket, RParen, Slash, Star, TildeEqual,
}
import nibble/lexer.{Span, Token}

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  1
  |> should.equal(1)
}

pub fn lex_test() {
  "  ^ | || & && >> <<   -124.566 + / *  { } ( ) [ ] : :: -> => = == != > >= < <= ~= @ # 'hello' \" world \""
  |> lexer.run(gloop.get_lexer())
  |> should.be_ok()
  |> should.equal([
    Token(Span(1, 3, 1, 4), "^", Caret),
    Token(Span(1, 5, 1, 6), "|", Bar),
    Token(Span(1, 7, 1, 8), "|", Bar),
    Token(Span(1, 8, 1, 9), "|", Bar),
    Token(Span(1, 10, 1, 11), "&", Ampersand),
    Token(Span(1, 12, 1, 13), "&", Ampersand),
    Token(Span(1, 13, 1, 14), "&", Ampersand),
    Token(Span(1, 15, 1, 16), ">", Gt),
    Token(Span(1, 16, 1, 17), ">", Gt),
    Token(Span(1, 18, 1, 19), "<", Lt),
    Token(Span(1, 19, 1, 20), "<", Lt),
    Token(Span(1, 23, 1, 24), "-", Minus),
    Token(Span(1, 24, 1, 31), "124.566", Number(124.566)),
    Token(Span(1, 32, 1, 33), "+", Plus),
    Token(Span(1, 34, 1, 35), "/", Slash),
    Token(Span(1, 36, 1, 37), "*", Star),
    Token(Span(1, 39, 1, 40), "{", RBrace),
    Token(Span(1, 41, 1, 42), "}", LBrace),
    Token(Span(1, 43, 1, 44), "(", RParen),
    Token(Span(1, 45, 1, 46), ")", LParen),
    Token(Span(1, 47, 1, 48), "[", RBracket),
    Token(Span(1, 49, 1, 50), "]", LBracket),
    Token(Span(1, 51, 1, 52), ":", Colon),
    Token(Span(1, 53, 1, 54), ":", Colon),
    Token(Span(1, 54, 1, 55), ":", Colon),
    Token(Span(1, 56, 1, 57), "-", Minus),
    Token(Span(1, 57, 1, 58), ">", Gt),
    Token(Span(1, 59, 1, 60), "=", Equal),
    Token(Span(1, 60, 1, 61), ">", Gt),
    Token(Span(1, 62, 1, 63), "=", Equal),
    Token(Span(1, 64, 1, 65), "=", Equal),
    Token(Span(1, 65, 1, 66), "=", Equal),
    Token(Span(1, 67, 1, 69), "!=", NotEqual),
    Token(Span(1, 70, 1, 71), ">", Gt),
    Token(Span(1, 72, 1, 73), ">", Gt),
    Token(Span(1, 73, 1, 74), "=", Equal),
    Token(Span(1, 75, 1, 76), "<", Lt),
    Token(Span(1, 77, 1, 78), "<", Lt),
    Token(Span(1, 78, 1, 79), "=", Equal),
    Token(Span(1, 80, 1, 82), "~=", TildeEqual),
    Token(Span(1, 83, 1, 84), "@", AtSign),
    Token(Span(1, 85, 1, 86), "#", PoundSign),
    Token(Span(1, 87, 1, 94), "'hello'", LitStr("hello")),
    Token(Span(1, 95, 1, 104), "\" world \"", LitStr(" world ")),
  ])
}
