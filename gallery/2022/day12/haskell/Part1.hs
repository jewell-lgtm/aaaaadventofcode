-- | Hill Climbing: level-by-level BFS where each frontier is a Set and the next one is
--   `neighbours \\ seen`. `bfs` takes the step rule and goal as functions, so part 2
--   runs the same search backwards from E.
module Part1 (solve, Grid, parse, height, find, bfs) where

import qualified Data.Map.Strict as M
import qualified Data.Set as S

type Pos = (Int, Int)

type Grid = M.Map Pos Char

parse :: String -> Grid
parse input = M.fromList [((r, c), ch) | (r, row) <- zip [0 ..] (lines input), (c, ch) <- zip [0 ..] row]

height :: Grid -> Pos -> Int
height g p = fromEnum $ case g M.! p of
  'S' -> 'a'
  'E' -> 'z'
  ch -> ch

find :: Char -> Grid -> Pos
find ch g = head [p | (p, x) <- M.toList g, x == ch]

-- | Fewest steps from start to a position satisfying the goal.
bfs :: Grid -> (Pos -> Pos -> Bool) -> (Pos -> Bool) -> Pos -> Maybe Int
bfs g canStep goal start = go 0 (S.singleton start) (S.singleton start)
  where
    go steps frontier seen
      | S.null frontier = Nothing
      | any goal frontier = Just steps
      | otherwise =
          let next = S.fromList (concatMap moves (S.toList frontier)) `S.difference` seen
           in go (steps + 1) next (seen <> next)
    moves p@(r, c) = [q | q <- [(r - 1, c), (r + 1, c), (r, c - 1), (r, c + 1)], M.member q g, canStep p q]

solve :: String -> String
solve input = maybe "unreachable" show $ bfs g up (== find 'E' g) (find 'S' g)
  where
    g = parse input
    up a b = height g b <= height g a + 1
