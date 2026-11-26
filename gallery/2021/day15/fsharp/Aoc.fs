/// Harness helpers.
///   example: true when running an example (aoc test).
///   arg "size" 71: example-specific constant from examples.toml `args`, else the default.
module Aoc

open System
open System.Text.Json

let example = Environment.GetEnvironmentVariable "AOC_EXAMPLE" = "1"

let private args =
    match Environment.GetEnvironmentVariable "AOC_ARGS" with
    | null | "" -> Map.empty
    | json -> JsonSerializer.Deserialize<Collections.Generic.Dictionary<string, JsonElement>> json |> Seq.map (|KeyValue|) |> Map.ofSeq

let arg<'T> (name: string) (fallback: 'T) : 'T =
    match args.TryFind name with
    | Some v -> v.Deserialize<'T>()
    | None -> fallback
