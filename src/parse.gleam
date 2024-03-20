import gleam/io
import gleam/option.{type Option}
import gleam/result
import gleam/list
import pears.{type ParseError, type Parsed, type Parser}
import pears/combinators.{
  alt, between, choice, just, lazy, left, many1, map, one_of, recognize, sep_by0,
  seq,
}
import pears/chars.{type Char, char, number}

pub type Cst(a) {
  Leaf(a)
  Cst(a, List(Cst(a)))
}

pub type Node {
  BinExpr
  Number(Int)
  Plus
  Minus
  Star
  Slash
}

pub fn parse(
  input: String,
) -> Result(Parsed(String, Cst(Node)), ParseError(String)) {
  let parser = parser()
  pears.parse_string(input, parser)
}

fn parser() -> Parser(String, Cst(Node)) {
  [num(), bin_op(), num()]
  |> io.debug()
  |> seq()
  |> io.debug()
  |> map(Cst(BinExpr, _))
  |> io.debug()
}

fn num() -> Parser(String, Cst(Node)) {
  number()
  |> io.debug()
  |> map(Number)
  |> io.debug()
  |> map(Leaf)
  |> io.debug()
}

fn bin_op() -> Parser(String, Cst(Node)) {
  choice([plus(), minus()])
  |> io.debug()
}

fn plus() -> Parser(String, Cst(Node)) {
  just("+")
  |> io.debug()
  |> map(fn(_) { Plus })
  |> io.debug()
  |> map(Leaf)
  |> io.debug()
}

fn minus() -> Parser(String, Cst(Node)) {
  just("-")
  |> io.debug()
  |> map(fn(_) { Minus })
  |> io.debug()
  |> map(Leaf)
  |> io.debug()
}
