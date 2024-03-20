import gleam/option.{type Option}
import gleam/result
import gleam/list
import lex.{
  type Token, type TokenLiteral, Comment, Empty, Identifier, Keyword, LexError,
  Literal, NewLine, Number, StringLiteral,
}

// GRAMMAR TIME
// program: statement*
// statement: expression | expression statement
// expression: literal binary_operation expression | literal 
// literal: number | identifier

pub type AstNode {
  End
  Bad
  AstNode(AstNode, List(AstNode))
  Program(List(AstNode))
  Statement(AstNode, List(AstNode))
  Expr(List(AstNode))
  Num(Token)
  Id(Token)
  BinOp(TokenLiteral)
  NoMatch
}

pub fn parse(input: List(Token)) -> AstNode {
  program(input)
}

fn program(input: List(Token)) -> AstNode {
  case input {
    [] -> NoMatch
    _ -> {
      let #(stmt, rest) = statement(input)
      case stmt {
        NoMatch -> NoMatch
        _ -> {
          let prog = program(rest)
          Program([stmt, prog])
        }
      }
    }
  }
}

fn statement(input: List(Token)) -> #(AstNode, List(Token)) {
  case input {
    [] -> #(NoMatch, [])
    _ -> {
      let #(expr, rest) = expression(input)
      let #(stmt, more) = statement(input)
      case stmt {
        NoMatch -> {
          #(Statement(expr, []), rest)
        }
        _ -> #(Statement(expr, [stmt]), more)
      }
    }
  }
}

fn expression(input: List(Token)) -> #(AstNode, List(Token)) {
  let #(lit, rest) = literal(input)
  case binary_operation(rest) {
    #(NoMatch, []) -> #(Expr([lit]), rest)
    #(BinOp(_) as b, rest) -> {
      let #(expr, rest) = expression(rest)
      #(Expr([lit, b, expr]), rest)
    }
    _ -> #(Bad, input)
  }
}

fn binary_operation(input: List(Token)) -> #(AstNode, List(Token)) {
  case input {
    [Literal(c), ..rest] -> {
      case c {
        lex.Plus | lex.Minus | lex.Star | lex.Slash -> #(BinOp(c), rest)
        _ -> #(NoMatch, [])
      }
    }
    _ -> #(NoMatch, [])
  }
}

fn literal(input: List(Token)) -> #(AstNode, List(Token)) {
  case input {
    [Number(_) as t, ..rest] -> #(Num(t), rest)
    [Identifier(_) as t, ..rest] -> #(Id(t), rest)
    _ -> #(Bad, input)
  }
}
