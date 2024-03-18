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
