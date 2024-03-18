import gleam/dict
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
  Comma
  Colon
  Semicolon
  LParen
  RParen
  LBracket
  RBracket
  Equal
  EqualEqual
  NotEqual
  GreaterThan
  GreaterThanEqual
  LessThan
  LessThanEqual
  Plus
  Minus
  Star
  Slash
  Percent
  And
  Or
  Not
  PlusPlus
  MinusMinus
  Arrow
  FatArrow
  Cons
  ConsEqual
  AtSign
  Period
}

pub type TokenKeyword {
  TknIf
  TknElse
  TknElseIf
  TknWhile
  TknUntil
  TknFor
  TknModule
  TknFn
  TknLet
  TknReturn
  TknBreak
  TknContinue
  TknPanic
  TknTodo
  TknImport
  TknType
  TknEnum
  TknImpl
  TknInterface
  TknStruct
}

pub type Token {
  Number(Float)
  StringLiteral(String)
  Literal(TokenLiteral)
  Comment(String)
  Empty
  LexError(String)
  Keyword(TokenKeyword)
  NewLine
  Identifier(String)
}

const illegal_identifier_characters = [
  "\"", "{", "}", ",", ";", "(", ")", "[", "]", "=", "!", ">", ",", "+", "-",
  "*", "/", "%", "&&", "|", "!", "+", "-", ">", ":", "@", "'", "'",
]

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
    "{" <> rest -> #(Literal(LBrace), rest)
    "}" <> rest -> #(Literal(RBrace), rest)
    "," <> rest -> #(Literal(Comma), rest)
    ":" <> rest -> #(Literal(Colon), rest)
    ";" <> rest -> #(Literal(Semicolon), rest)
    "(" <> rest -> #(Literal(LParen), rest)
    ")" <> rest -> #(Literal(RParen), rest)
    "[" <> rest -> #(Literal(LBracket), rest)
    "]" <> rest -> #(Literal(RBracket), rest)
    "=" <> rest -> #(Literal(Equal), rest)
    "==" <> rest -> #(Literal(EqualEqual), rest)
    "!=" <> rest -> #(Literal(NotEqual), rest)
    ">" <> rest -> #(Literal(GreaterThan), rest)
    ">=" <> rest -> #(Literal(GreaterThanEqual), rest)
    "<" <> rest -> #(Literal(LessThan), rest)
    "<=" <> rest -> #(Literal(LessThanEqual), rest)
    "+" <> rest -> #(Literal(Plus), rest)
    "-" <> rest -> #(Literal(Minus), rest)
    "*" <> rest -> #(Literal(Star), rest)
    "/" <> rest -> #(Literal(Slash), rest)
    "%" <> rest -> #(Literal(Percent), rest)
    "&&" <> rest -> #(Literal(And), rest)
    "||" <> rest -> #(Literal(Or), rest)
    "!" <> rest -> #(Literal(Not), rest)
    "++" <> rest -> #(Literal(PlusPlus), rest)
    "--" <> rest -> #(Literal(MinusMinus), rest)
    "->" <> rest -> #(Literal(Arrow), rest)
    "=>" <> rest -> #(Literal(FatArrow), rest)
    "::" <> rest -> #(Literal(Cons), rest)
    "::=" <> rest -> #(Literal(ConsEqual), rest)
    "@" <> rest -> #(Literal(AtSign), rest)
    "." <> rest -> #(Literal(Period), rest)
    "if" <> rest -> #(Keyword(TknIf), rest)
    "else" <> rest -> #(Keyword(TknElse), rest)
    "elif" <> rest -> #(Keyword(TknElseIf), rest)
    "while" <> rest -> #(Keyword(TknWhile), rest)
    "until" <> rest -> #(Keyword(TknUntil), rest)
    "for" <> rest -> #(Keyword(TknFor), rest)
    "module" <> rest -> #(Keyword(TknModule), rest)
    "fn" <> rest -> #(Keyword(TknFn), rest)
    "let" <> rest -> #(Keyword(TknLet), rest)
    "return" <> rest -> #(Keyword(TknReturn), rest)
    "break" <> rest -> #(Keyword(TknBreak), rest)
    "continue" <> rest -> #(Keyword(TknContinue), rest)
    "panic" <> rest -> #(Keyword(TknPanic), rest)
    "todo" <> rest -> #(Keyword(TknTodo), rest)
    "import" <> rest -> #(Keyword(TknImport), rest)
    "type" <> rest -> #(Keyword(TknType), rest)
    "enum" <> rest -> #(Keyword(TknEnum), rest)
    "impl" <> rest -> #(Keyword(TknImpl), rest)
    "interface" <> rest -> #(Keyword(TknInterface), rest)
    "struct" <> rest -> #(Keyword(TknStruct), rest)
    "\n" <> rest -> #(NewLine, rest)
    " " <> rest | "\t" <> rest | "\r" <> rest -> #(Empty, rest)
    _ -> tokenize_identifier(input, "")
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

fn tokenize_identifier(input: String, output: String) -> #(Token, String) {
  // NOTE: Similar to our regular tokenize, just terminate when you see any characters that are not allowed
  todo
}
