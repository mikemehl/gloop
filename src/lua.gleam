import gleam/option

type Option(a) =
  option.Option(a)

pub type Block {
  Block(List(Statement), LastStmt)
}

pub type UnaryOp {
  Dash
  Not
  PoundSign
}

pub type BinOp {
  Plus
  Minus
  Star
  Slash
  Caret
  Mod
  DotDot
  Lt
  Lte
  Gt
  Gte
  EqualEqual
  NotEqual
}

pub type FieldSep {
  Comma
  SemiColon
}

pub type Field {
  FieldBracket(Expr, Expr)
  FieldName(Expr)
}

pub type FieldList =
  List(Field)

pub type TableConstructor {
  TableConstructor(FieldList)
}

pub type PairList =
  List(Name)

pub type FuncBody {
  FuncBody(PairList, Block)
}

pub type Function {
  Function(FuncBody)
}

pub type ArgsString {
  ArgsString(String)
}

pub type ArgsExprList {
  ArgsExprList(ExprList)
}

pub type ArgsTable(t, s) {
  ArgsTable(TableConstructor)
}

pub type Args {
  Args
}

pub type FuncCall {
  FuncCallPlain(PrefixExpr, Args)
  FuncCallMethod(PrefixExpr, Args)
}

pub type PrefixExpr {
  PrefixExpr
}

pub type Expr {
  ExprNil
  ExprTrue
  ExprFalse
  ExprNumber(Float)
  ExprString(String)
  ExprVarArgs
  ExprFunction(Function)
  ExprPrefixExpr(PrefixExpr)
  ExprTableConstructor(TableConstructor)
  ExprBinOp(Expr, BinOp, Expr)
  ExprUnOp(UnaryOp, Expr)
}

pub type ExprList =
  List(Expr)

pub type Var {
  VarName(Name)
  VarPrefixEpr(PrefixExpr, Expr)
  VarDot(PrefixExpr, Name)
}

pub type VarList =
  List(Var)

pub type FuncName {
  FuncName(main: String, dot: Option(String), colon: Option(String))
}

pub type LastStmt {
  LastStmtReturn(ExprList)
  LastStmtBreak
}

pub type Statement {
  StmtVar(Var, Expr)
  StmtVarListExprList(VarList, ExprList)
  StmtFuncCall(FuncCall)
  StmtDo(Block)
  StmtWhile(Expr, Block)
  StmtUntil(Block, Expr)
  StmtIf(Expr, Block, List(Option(#(Expr, Block))), Option(Block))
  StmtForExpr(Name, Expr, Expr, Option(Expr), Block)
  StmtForIn(NameList, ExprList, Block)
}

pub type Name {
  Name(String)
}

pub type NameList =
  List(Name)

pub type Module {
  Module(requires: ExprList, stmts: List(Statement), ret: LastStmt)
}
