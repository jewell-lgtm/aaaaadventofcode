-- | Report Repair: pair each entry with the set of entries seen before it (a scanl of
--   IntSets), and take the first whose complement is already in there.
--   Haskell: laziness means the list comprehension stops at the first hit.
module Part1 (solve, pairProduct) where

import qualified Data.IntSet as S
import Data.Maybe (fromJust, listToMaybe)

pairProduct :: Int -> [Int] -> Maybe Int
pairProduct target xs =
  listToMaybe
    [ x * (target - x)
    | (x, seen) <- zip xs (scanl (flip S.insert) S.empty xs)
    , (target - x) `S.member` seen
    ]

solve :: String -> String
solve = show . fromJust . pairProduct 2020 . map read . lines
