import gleeunit
import gleeunit/should
import gleam/io
import gleam/list
import lex
import parse

pub fn parse_math_test() {
  "5+7"
  |> io.debug()
  |> parse.parse()
  |> io.debug()

  "   5+7   "
  |> io.debug()
  |> parse.parse()
  |> io.debug()

  "   5 + 7   "
  |> io.debug()
  |> parse.parse()
  |> io.debug()

  "  13    +     12  "
  |> io.debug()
  |> parse.parse()
  |> io.debug()

  "   5 + 7 / 13 + 12  "
  |> io.debug()
  |> parse.parse()
  |> io.debug()
}
