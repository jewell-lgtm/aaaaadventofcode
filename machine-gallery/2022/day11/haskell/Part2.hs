-- | No more relief: reduce worry modulo the product of every monkey's (prime) divisor,
--   which leaves all divisibility tests unchanged.
module Part2 (solve) where

import Part1 (Monkey (..), monkeyBusiness)

solve :: String -> String
solve = show . monkeyBusiness 10000 (\ms w -> w `mod` product (map divisor ms))
