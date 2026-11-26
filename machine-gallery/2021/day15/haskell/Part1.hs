-- | Chiton: Dijkstra with a Data.Set of (distance, position) as the priority queue
--   (`S.deleteFindMin` pops) and a Map of best distances. The cave is a risk function
--   plus its size, so part 2's tiled cave is just a different function.
module Part1 (solve, Cave (..), parse, lowestRisk) where

import Data.Char (digitToInt)
import qualified Data.Map.Strict as M
import qualified Data.Set as S

type Pos = (Int, Int)

data Cave = Cave {rows :: Int, cols :: Int, risk :: Pos -> Int}

parse :: String -> Cave
parse input = Cave (length ls) (length (head ls)) (grid M.!)
  where
    ls = lines input
    grid = M.fromList [((r, c), digitToInt ch) | (r, row) <- zip [0 ..] ls, (c, ch) <- zip [0 ..] row]

lowestRisk :: Cave -> Int
lowestRisk cave = go (S.singleton (0, (0, 0))) (M.singleton (0, 0) 0)
  where
    goal = (rows cave - 1, cols cave - 1)
    go queue best
      | pos == goal = d
      | otherwise = uncurry go $ foldl' relax (queue', best) (neighbours pos)
      where
        ((d, pos), queue') = S.deleteFindMin queue
        relax (q, b) p
          | maybe False (<= d') (M.lookup p b) = (q, b)
          | otherwise = (S.insert (d', p) q, M.insert p d' b)
          where
            d' = d + risk cave p
    neighbours (r, c) =
      [ (r', c') | (r', c') <- [(r - 1, c), (r + 1, c), (r, c - 1), (r, c + 1)],
        r' >= 0, c' >= 0, r' < rows cave, c' < cols cave ]

solve :: String -> String
solve = show . lowestRisk . parse
