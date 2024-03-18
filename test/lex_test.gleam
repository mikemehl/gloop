import gleeunit
import gleeunit/should
import lex
import gleam/list

pub fn lex_numbers_test() {
  "2345  4576  "
  |> lex.lex()
  |> should.equal(Ok([lex.Number(2345.0), lex.Number(4576.0)]))

  "676767"
  |> lex.lex()
  |> should.equal(Ok([lex.Number(676_767.0)]))

  "8405948038.3490583048"
  |> lex.lex()
  |> should.equal(Ok([lex.Number(8_405_948_038.3490583048)]))

  // NOTE: The leading '-' is not part of the number
  "       -8405948038.3490583048"
  |> lex.lex()
  |> should.equal(
    Ok([lex.Literal(lex.Minus), lex.Number(8_405_948_038.3490583048)]),
  )
}

pub fn lex_string_literal_test() {
  "\"hello world\""
  |> lex.lex()
  |> should.equal(Ok([lex.StringLiteral("hello world")]))

  "\"hello world\" \"hello world\""
  |> lex.lex()
  |> should.equal(
    Ok([lex.StringLiteral("hello world"), lex.StringLiteral("hello world")]),
  )

  "\"hello world\" \"hello world\" \"hello world"
  |> lex.lex()
  |> should.be_error()
}

pub fn lex_literal_brace() {
  [
    #("{", lex.Literal(lex.LBrace)),
    #("}", lex.Literal(lex.RBrace)),
    #(",", lex.Literal(lex.Comma)),
    #(":", lex.Literal(lex.Colon)),
    #(";", lex.Literal(lex.Semicolon)),
    #("(", lex.Literal(lex.LParen)),
    #(")", lex.Literal(lex.RParen)),
    #("[", lex.Literal(lex.LBracket)),
    #("]", lex.Literal(lex.RBracket)),
    #("=", lex.Literal(lex.Equal)),
    #("==", lex.Literal(lex.EqualEqual)),
    #("!=", lex.Literal(lex.NotEqual)),
    #(">", lex.Literal(lex.GreaterThan)),
    #(">=", lex.Literal(lex.GreaterThanEqual)),
    #("<", lex.Literal(lex.LessThan)),
    #("<=", lex.Literal(lex.LessThanEqual)),
    #("+", lex.Literal(lex.Plus)),
    #("-", lex.Literal(lex.Minus)),
    #("*", lex.Literal(lex.Star)),
    #("/", lex.Literal(lex.Slash)),
    #("%", lex.Literal(lex.Percent)),
    #("&&", lex.Literal(lex.And)),
    #("||", lex.Literal(lex.Or)),
    #("!", lex.Literal(lex.Not)),
    #("++", lex.Literal(lex.PlusPlus)),
    #("--", lex.Literal(lex.MinusMinus)),
    #("->", lex.Literal(lex.Arrow)),
    #("=>", lex.Literal(lex.FatArrow)),
    #("::", lex.Literal(lex.Cons)),
    #("::=", lex.Literal(lex.ConsEqual)),
    #("@", lex.Literal(lex.AtSign)),
  ]
  |> list.each(fn(pair) {
    let assert #(input, expected) = pair
    input
    |> lex.lex()
    |> should.equal(Ok([expected]))
  })
}
