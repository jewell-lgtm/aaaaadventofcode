-- | Monkey in the Middle: parse each paragraph into a Monkey record whose operation is
--   a function, then fold rounds over an IntMap of item lists. `relief` keeps worry in
--   check: `div` 3 in part 1, `mod` the product of all divisors in part 2.
module Part1 (solve, Monkey (..), parse, monkeyBusiness) where

import Data.List (sortOn)
import qualified Data.IntMap.Strict as IM
import Data.Ord (Down (..))

data Monkey = Monkey {operation :: Int -> Int, divisor :: Int, onTrue :: Int, onFalse :: Int}

paragraphs :: [String] -> [[String]]
paragraphs ls = case break null (dropWhile null ls) of
  ([], _) -> []
  (p, rest) -> p : paragraphs rest

parseMonkey :: [String] -> ([Int], Monkey)
parseMonkey (_ : items : op : test : yes : no : _) =
  (map read (words (map comma (afterColon items))), Monkey (parseOp (words op)) (lastInt test) (lastInt yes) (lastInt no))
  where
    afterColon = drop 1 . dropWhile (/= ':')
    comma c = if c == ',' then ' ' else c
    lastInt = read . last . words
parseMonkey p = error ("bad monkey: " ++ unlines p)

parseOp :: [String] -> Int -> Int
parseOp ws = case drop 3 ws of
  ["old", "*", "old"] -> \x -> x * x
  ["old", "*", n] -> (* read n)
  ["old", "+", n] -> (+ read n)
  other -> error ("bad operation: " ++ unwords other)

parse :: String -> ([[Int]], [Monkey])
parse = unzip . map parseMonkey . paragraphs . lines

monkeyBusiness :: Int -> ([Monkey] -> Int -> Int) -> String -> Int
monkeyBusiness rounds relief input = product . take 2 . sortOn Down $ IM.elems counts
  where
    (items, monkeys) = parse input
    start = (IM.fromList (zip [0 ..] items), IM.fromList [(i, 0) | i <- [0 .. length monkeys - 1]])
    (_, counts) = iterate playRound start !! rounds
    playRound st = foldl' turn st (zip [0 ..] monkeys)
    turn (held, seen) (i, m) =
      let thrown = [(target, w') | w <- held IM.! i, let w' = relief monkeys (operation m w), let target = if w' `mod` divisor m == 0 then onTrue m else onFalse m]
          held' = foldl' (\h (t, w) -> IM.adjust (++ [w]) t h) (IM.insert i [] held) thrown
       in (held', IM.adjust (+ length thrown) i seen)

solve :: String -> String
solve = show . monkeyBusiness 20 (const (`div` 3))
