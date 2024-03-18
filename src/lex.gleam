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

pub type Token {
  Number(Float)
}

pub fn lex(input: String) -> LexResult {
  input
  |> tokenize([])
}

pub fn tokenize(input: String, output: List(Token)) -> LexResult {
  case input {
    "" -> Ok(output)
    "0" <> _
    | "1" <> _
    | "2" <> _
    | "3" <> _
    | "4" <> _
    | "5" <> _
    | "6" <> _
    | "7" <> _
    | "8" <> _
    | "9" <> _ ->
      case string.split_once(input, " ") {
        Ok(#(n, rest)) ->
          result.try(
            n
            |> to_num_token(),
            fn(t) {
              tokenize(
                rest,
                output
                |> list.append([t]),
              )
            },
          )
        _ ->
          result.try(to_num_token(input), fn(t) { Ok(list.append(output, [t])) })
      }
    _ -> {
      input
      |> string.drop_left(1)
      |> tokenize(output)
    }
  }
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
