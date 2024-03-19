import gleeunit
import gleeunit/should
import gleam/list
import lex
import parse

pub fn parse_math_test() {
  let assert Ok([lex.Number(5.0), lex.Literal(lex.Plus), lex.Number(4.0)]) as tokens =
    "5 + 4"
    |> lex.lex()

  let assert Ok(tokens) = tokens

  tokens
  |> parse.parse()
  |> should.equal(
    Ok([parse.AddOperation(parse.NumberLiteral(5.0), parse.NumberLiteral(4.0))]),
  )

  let assert Ok([
    lex.Number(5.0),
    lex.Literal(lex.Plus),
    lex.Number(4.0),
    lex.Literal(lex.Plus),
    lex.Number(3.0),
  ]) as tokens =
    "5 + 4 + 3"
    |> lex.lex()

  let assert Ok(tokens) = tokens

  tokens
  |> parse.parse()
  |> should.equal(
    Ok([
      parse.AddOperation(
        parse.AddOperation(parse.NumberLiteral(5.0), parse.NumberLiteral(4.0)),
        parse.NumberLiteral(3.0),
      ),
    ]),
  )
}
