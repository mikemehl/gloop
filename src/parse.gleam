import gleam/io
import gleam/int
import gleam/string
import gleam/option.{type Option}
import gleam/result
import gleam/list
import pears.{type ParseError, type Parsed, type Parser}
import pears/combinators.{
  alt, between, choice, just, lazy, left, many0, many1, map, one_of, recognize,
  right, sep_by0, seq, to,
}
import pears/chars.{type Char, char, digit, number}

pub type Cst(a) {
  Leaf(a)
  Cst(a, List(Cst(a)))
}

pub type Node {
  BinExpr
  Number(Int)
  Plus
  Minus
  Multiply
  Divide
}

pub fn parse(
  input: String,
) -> Result(Parsed(String, List(Cst(Node))), ParseError(String)) {
  let parser = parser()
  input
  |> string.trim()
  |> pears.parse_string(parser)
}

fn parser() -> Parser(String, List(Cst(Node))) {
  many1(bin_expr())
}

fn bin_expr() -> Parser(String, Cst(Node)) {
  [num(), bin_op(), num()]
  |> seq()
  |> map(Cst(BinExpr, _))
}

fn num() -> Parser(String, Cst(Node)) {
  digit()
  |> many1()
  |> map(fn(d: List(String)) -> Node {
    d
    |> string.join("")
    |> int.parse()
    |> result.unwrap(-666)
    |> Number
  })
  |> map(Leaf)
}

fn bin_op() -> Parser(String, Cst(Node)) {
  choice([plus(), minus(), multiply(), divide()])
}

fn plus() -> Parser(String, Cst(Node)) {
  just("+")
  |> padded()
  |> map(fn(_) { Plus })
  |> map(Leaf)
}

fn minus() -> Parser(String, Cst(Node)) {
  just("-")
  |> padded()
  |> map(fn(_) { Minus })
  |> map(Leaf)
}

fn multiply() -> Parser(String, Cst(Node)) {
  just("*")
  |> padded()
  |> map(fn(_) { Multiply })
  |> map(Leaf)
}

fn divide() -> Parser(String, Cst(Node)) {
  just("/")
  |> padded()
  |> map(fn(_) { Divide })
  |> map(Leaf)
}

fn padded(p: Parser(String, String)) -> Parser(String, String) {
  p
  |> left(ws())
  |> right(ws(), _)
}

fn ws() -> Parser(String, List(String)) {
  one_of([" ", "\n", "\t", "\r"])
  |> many0()
}
