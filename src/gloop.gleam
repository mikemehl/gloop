import gleam/io
import simplifile
import argv
import gleam/result
import gleam/list

pub fn main() {
  io.println("Hello from gloop!")
  case
    {
      use fname <- result.try(get_fname())
      use content <- result.try(read_file(fname))
      Ok(io.println(content))
    }
  {
    Ok(_) -> Nil
    _ -> io.println("Error reading file")
  }
}

fn get_fname() -> Result(String, Nil) {
  argv.load().arguments
  |> list.first()
}

fn read_file(fname: String) -> Result(String, Nil) {
  simplifile.read(fname)
  |> result.replace_error(Nil)
}
