-- | Supply Stacks: `transpose` the drawing so each stack becomes a column string
--   (top crate first), keyed by its label digit. Moves fold over a Map of stacks;
--   the crane is a function on the lifted crates (reverse for the 9000, id for the 9001).
module Part1 (solve, run) where

import Data.Char (isDigit)
import Data.List (transpose)
import qualified Data.Map.Strict as M

type Stacks = M.Map Int String

parseStacks :: [String] -> Stacks
parseStacks rows =
  M.fromList [(read [last col], dropWhile (== ' ') (init col)) | col <- transpose rows, isDigit (last col)]

parseMove :: String -> (Int, Int, Int)
parseMove line = case words line of
  ["move", n, "from", a, "to", b] -> (read n, read a, read b)
  _ -> error ("bad move: " ++ line)

apply :: (String -> String) -> Stacks -> (Int, Int, Int) -> Stacks
apply crane stacks (n, from, to) =
  let (lifted, rest) = splitAt n (stacks M.! from)
   in M.adjust (crane lifted ++) to (M.insert from rest stacks)

run :: (String -> String) -> String -> String
run crane input =
  let (drawing, _ : moves) = break null (lines input)
      final = foldl' (apply crane) (parseStacks drawing) (map parseMove moves)
   in [top | top : _ <- M.elems final]

solve :: String -> String
solve = run reverse
