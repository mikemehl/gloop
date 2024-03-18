import gleam/iterator
import gleam/list
import gleam/string
import gleam/result
import gleam/regex
import gleam/float
import gleam/int

type Iterator =
  iterator.Iterator(String)

pub type LexResult =
  Result(List(Token), String)

pub type TokenLiteral {
  LBrace
  RBrace
}

pub type Token {
  Number(Float)
  StringLiteral(String)
  Literal(TokenLiteral)
  Comment(String)
  Empty
  LexError(String)
}

pub fn lex(input: String) -> LexResult {
  input
  |> tokenize([])
}

pub fn tokenize(input: String, output: List(Token)) -> LexResult {
  let get_token = case input {
    "" -> #(Empty, "")
    "0" <> _
    | "1" <> _
    | "2" <> _
    | "3" <> _
    | "4" <> _
    | "5" <> _
    | "6" <> _
    | "7" <> _
    | "8" <> _
    | "9" <> _ -> tokenize_number(input)
    "\"" <> rest -> tokenize_string_literal(rest)
    "[" <> rest -> #(Literal(LBrace), rest)
    _ -> #(Empty, string.drop_left(input, 1))
  }

  case get_token {
    #(Empty, "") -> Ok(output)
    #(Empty, rest) -> tokenize(rest, output)
    #(LexError(e), _) -> Error(e)
    #(token, rest) -> tokenize(rest, list.append(output, [token]))
  }
}

fn tokenize_number(input: String) -> #(Token, String) {
  case string.split_once(input, " ") {
    Ok(#(n, rest)) ->
      result.try(
        n
        |> to_num_token(),
        fn(t) { Ok(#(t, rest)) },
      )
    _ ->
      result.try(
        input
        |> to_num_token(),
        fn(t) { Ok(#(t, "")) },
      )
  }
  |> result.unwrap(#(LexError("Failed to parse number"), ""))
}

fn to_num_token(num_str: String) -> Result(Token, String) {
  case float.parse(num_str) {
    Ok(n) -> Ok(Number(n))
    _ ->
      case int.parse(num_str) {
        Ok(n) ->
          int.to_float(n)
          |> Number
          |> Ok
        _ -> Error("Failed to parse number")
      }
  }
}

fn tokenize_string_literal(rest: String) -> #(Token, String) {
  case string.split_once(rest, on: "\"") {
    Ok(#(str, rest)) -> #(StringLiteral(str), rest)
    _ -> #(LexError("Failed to parse string literal"), "")
  }
}
