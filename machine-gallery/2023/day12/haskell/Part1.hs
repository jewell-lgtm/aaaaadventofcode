-- | Hot Springs: DP over (spring index, groups placed), memoised by laziness: `table`
--   is a boxed Array whose cells are thunks that refer to other cells. Each '?' is
--   tried both as operational and as the start of the next damaged group.
module Part1 (solve, arrangements, parseLine) where

import Data.Array

arrangements :: String -> [Int] -> Int
arrangements springs groups = table ! (0, 0)
  where
    n = length springs
    m = length groups
    s = listArray (0, n - 1) springs
    g = listArray (0, m - 1) groups
    table = array ((0, 0), (n, m)) [((i, j), count i j) | i <- [0 .. n], j <- [0 .. m]]
    count i j
      | i == n = if j == m then 1 else 0
      | otherwise = case s ! i of
          '.' -> operational
          '#' -> damaged
          _ -> operational + damaged
      where
        operational = table ! (i + 1, j)
        damaged
          | j < m, fits i (g ! j) = table ! (min n (i + g ! j + 1), j + 1)
          | otherwise = 0
    -- a run of `len` damaged springs can start at i: no '.', then not followed by '#'
    fits i len =
      i + len <= n
        && all (\k -> s ! k /= '.') [i .. i + len - 1]
        && (i + len == n || s ! (i + len) /= '#')

parseLine :: String -> (String, [Int])
parseLine line = (springs, read ("[" ++ groups ++ "]"))
  where
    [springs, groups] = words line

solve :: String -> String
solve = show . sum . map (uncurry arrangements . parseLine) . lines
