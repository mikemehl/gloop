import lua
import glance
import constants
import imports

pub fn translate(gleam_module: glance.Module) -> lua.Module {
  lua.Module(requires: [], stmts: [], ret: lua.LastStmtReturn([]))
  |> constants.extract(gleam_module)
  |> imports.extract(gleam_module)
}
