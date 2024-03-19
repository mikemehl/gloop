import gleeunit
import gleeunit/should
import lex
import gleam/list

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
  |> should.equal(
    Ok([lex.Literal(lex.Minus), lex.Number(8_405_948_038.3490583048)]),
  )
}

pub fn lex_string_literal_test() {
  "\"hello world\""
  |> lex.lex()
  |> should.equal(Ok([lex.StringLiteral("hello world")]))

  "\"hello world\" \"hello world\""
  |> lex.lex()
  |> should.equal(
    Ok([lex.StringLiteral("hello world"), lex.StringLiteral("hello world")]),
  )

  "\"hello world\" \"hello world\" \"hello world"
  |> lex.lex()
  |> should.be_error()
}

pub fn lex_literal_brace() {
  [
    #("{", lex.Literal(lex.LBrace)),
    #("}", lex.Literal(lex.RBrace)),
    #(",", lex.Literal(lex.Comma)),
    #(":", lex.Literal(lex.Colon)),
    #(";", lex.Literal(lex.Semicolon)),
    #("(", lex.Literal(lex.LParen)),
    #(")", lex.Literal(lex.RParen)),
    #("[", lex.Literal(lex.LBracket)),
    #("]", lex.Literal(lex.RBracket)),
    #("=", lex.Literal(lex.Equal)),
    #("==", lex.Literal(lex.EqualEqual)),
    #("!=", lex.Literal(lex.NotEqual)),
    #(">", lex.Literal(lex.GreaterThan)),
    #(">=", lex.Literal(lex.GreaterThanEqual)),
    #("<", lex.Literal(lex.LessThan)),
    #("<=", lex.Literal(lex.LessThanEqual)),
    #("+", lex.Literal(lex.Plus)),
    #("-", lex.Literal(lex.Minus)),
    #("*", lex.Literal(lex.Star)),
    #("/", lex.Literal(lex.Slash)),
    #("%", lex.Literal(lex.Percent)),
    #("&&", lex.Literal(lex.And)),
    #("||", lex.Literal(lex.Or)),
    #("!", lex.Literal(lex.Not)),
    #("++", lex.Literal(lex.PlusPlus)),
    #("--", lex.Literal(lex.MinusMinus)),
    #("->", lex.Literal(lex.Arrow)),
    #("=>", lex.Literal(lex.FatArrow)),
    #("::", lex.Literal(lex.Cons)),
    #("::=", lex.Literal(lex.ConsEqual)),
    #("@", lex.Literal(lex.AtSign)),
    #("if", lex.Keyword(lex.TknIf)),
    #("else", lex.Keyword(lex.TknElse)),
    #("elif", lex.Keyword(lex.TknElseIf)),
    #("while", lex.Keyword(lex.TknWhile)),
    #("until", lex.Keyword(lex.TknUntil)),
    #("for", lex.Keyword(lex.TknFor)),
    #("module", lex.Keyword(lex.TknModule)),
    #("fn", lex.Keyword(lex.TknFn)),
    #("let", lex.Keyword(lex.TknLet)),
    #("return", lex.Keyword(lex.TknReturn)),
    #("break", lex.Keyword(lex.TknBreak)),
    #("continue", lex.Keyword(lex.TknContinue)),
    #("panic", lex.Keyword(lex.TknPanic)),
    #("todo", lex.Keyword(lex.TknTodo)),
    #("import", lex.Keyword(lex.TknImport)),
    #("type", lex.Keyword(lex.TknType)),
    #("enum", lex.Keyword(lex.TknEnum)),
    #("impl", lex.Keyword(lex.TknImpl)),
    #("interface", lex.Keyword(lex.TknInterface)),
    #("struct", lex.Keyword(lex.TknStruct)),
    #("\n", lex.NewLine),
    #(".", lex.Literal(lex.Period)),
  ]
  |> list.each(fn(pair) {
    let assert #(input, expected) = pair
    input
    |> lex.lex()
    |> should.equal(Ok([expected]))
  })
}

pub fn lex_identifier_test() {
  "    hello_world    "
  |> lex.lex()
  |> should.equal(Ok([lex.Identifier("hello_world")]))

  " hello_w@rld----"
  |> lex.lex()
  |> should.equal(
    Ok([
      lex.Identifier("hello_w"),
      lex.Literal(lex.AtSign),
      lex.Identifier("rld"),
      lex.Literal(lex.Minus),
      lex.Literal(lex.Minus),
      lex.Literal(lex.Minus),
      lex.Literal(lex.Minus),
    ]),
  )

  "ajfajsfl:dj8lfjsad_lfj"
  |> lex.lex()
  |> should.equal(
    Ok([
      lex.Identifier("ajfajsfl"),
      lex.Literal(lex.Colon),
      lex.Identifier("dj8lfjsad_lfj"),
    ]),
  )

  "ajfajsfl:dj8lfjsad_lfj0"
  |> lex.lex()
  |> should.equal(
    Ok([
      lex.Identifier("ajfajsfl"),
      lex.Literal(lex.Colon),
      lex.Identifier("dj8lfjsad_lfj0"),
    ]),
  )

  "ajfajsfl:dj8lfjsad_lfj\n0"
  |> lex.lex()
  |> should.equal(
    Ok([
      lex.Identifier("ajfajsfl"),
      lex.Literal(lex.Colon),
      lex.Identifier("dj8lfjsad_lfj"),
      lex.Number(0.0),
    ]),
  )
}
