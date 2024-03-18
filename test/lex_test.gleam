import gleeunit
import gleeunit/should
import lex

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
  |> should.equal(Ok([lex.Number(8_405_948_038.3490583048)]))
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
  "["
  |> lex.lex()
  |> should.equal(Ok([lex.Literal(lex.LBrace)]))
}
