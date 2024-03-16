import gleam/result
import gleam/list
import gleam/float
import lua
import glance

pub fn extract(
  lua_module: lua.Module,
  gleam_module: glance.Module,
) -> lua.Module {
  gleam_module.constants
  |> list.map(fn(c) { c.definition })
  |> list.map(translate_constant)
  |> fn(stmts) { lua.Module(..lua_module, stmts: stmts) }
}

fn translate_constant(gleam_const: glance.Constant) -> lua.Statement {
  let var = lua.VarName(lua.Name(gleam_const.name))
  let expr =
    case gleam_const.value {
      glance.Int(i) ->
        i
        |> float.parse()
        |> result.lazy_unwrap(panic)
      _ -> todo
    }
    |> fn(f) { lua.ExprNumber(f) }
  lua.StmtVar(var, expr)
}
