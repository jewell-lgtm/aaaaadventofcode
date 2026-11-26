(* Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last. *)
let () =
  let input = In_channel.input_all stdin in
  let solve = if Sys.getenv_opt "AOC_PART" = Some "2" then Part2.solve else Part1.solve in
  print_endline (solve input)
