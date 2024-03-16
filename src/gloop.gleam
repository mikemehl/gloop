import gleam/io
import simplifile
import argv
import glance
import gleam/result
import gleam/list
import translate

pub fn main() {
  io.println("Hello from gloop!")
  use fname <- result.try(get_fname())
  use content <- result.try(read_file(fname))
  use ast <- result.try(to_ast(content))
  Ok(
    ast
    |> translate.translate(),
  )
}

fn get_fname() -> Result(String, Nil) {
  argv.load().arguments
  |> list.first()
}

fn read_file(fname: String) -> Result(String, Nil) {
  simplifile.read(fname)
  |> result.replace_error(Nil)
}

fn to_ast(content: String) -> Result(glance.Module, Nil) {
  glance.module(content)
  |> result.replace_error(Nil)
}
