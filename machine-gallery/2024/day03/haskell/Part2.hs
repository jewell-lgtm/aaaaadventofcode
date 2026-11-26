-- | Same scanner; now fold with an "enabled" flag that do()/don't() toggle.
module Part2 (solve) where

import Part1 (Instr (..), instructions)

step :: (Bool, Int) -> Instr -> (Bool, Int)
step (_, total) Do = (True, total)
step (_, total) Dont = (False, total)
step (on, total) (Mul a b) = (on, if on then total + a * b else total)

solve :: String -> String
solve = show . snd . foldl' step (True, 0) . instructions
