(* Camel Cards: map each hand to a sortable key (type, card strengths), sort, then
   sum bid * rank. The hand type is a pattern match on the sorted group sizes.
   [~joker] makes J the weakest card and lets it join the biggest group. *)
let card_order ~joker = if joker then "J23456789TQKA" else "23456789TJQKA"

let group_sizes cards =
  cards |> List.sort compare |> List.fold_left (fun acc c ->
      match acc with (c', n) :: rest when c = c' -> (c, n + 1) :: rest | _ -> (c, 1) :: acc) []
  |> List.map snd |> List.sort (Fun.flip compare)

let hand_type ~joker cards =
  let jokers = if joker then List.length (List.filter (( = ) 'J') cards) else 0 in
  let rest = if joker then List.filter (( <> ) 'J') cards else cards in
  match group_sizes rest with
  | [] -> 6 (* JJJJJ *)
  | biggest :: others -> (
      match (biggest + jokers) :: others with
      | [ 5 ] -> 6
      | [ 4; 1 ] -> 5
      | [ 3; 2 ] -> 4
      | [ 3; 1; 1 ] -> 3
      | [ 2; 2; 1 ] -> 2
      | [ 2; 1; 1; 1 ] -> 1
      | _ -> 0)

let key ~joker hand =
  let cards = String.to_seq hand |> List.of_seq in
  (hand_type ~joker cards, List.map (String.index (card_order ~joker)) cards)

let winnings ~joker input =
  String.trim input |> String.split_on_char '\n'
  |> List.map (fun line -> Scanf.sscanf line "%s %d" (fun hand bid -> (key ~joker hand, bid)))
  |> List.sort compare
  |> List.mapi (fun i (_, bid) -> (i + 1) * bid)
  |> List.fold_left ( + ) 0

let solve input = winnings ~joker:false input |> string_of_int
