open Aoc [@@warning "-33"]

let solve input =
  let _lines = String.split_on_char '\n' (String.trim input) in
  string_of_int 0
