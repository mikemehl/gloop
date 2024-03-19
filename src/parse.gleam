import gleam/list
import lex.{
  Comment, Empty, Identifier, Keyword, LexError, Literal, NewLine, Number,
  StringLiteral,
}

pub type AstNode {
  AddOperation(AstNode, AstNode)
  NumberLiteral(Float)
}

// GRAMMAR TIME:
// program -> statement [statement]
// statement -> expr | declaration
// declaration -> ??? // TODO
// expr -> math_expr
// math_expr -> add_expr | numeric
// add_expr -> nueric PLUS math_expr
// numeric -> number | numeric_identifier
//

pub fn parse(input: List(lex.Token)) -> Result(List(AstNode), String) {
  input
  |> parse_tokens([])
}

pub fn parse_tokens(
  input: List(lex.Token),
  output: List(AstNode),
) -> Result(List(AstNode), String) {
  todo
}
