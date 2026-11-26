-- | Mull It Over: no regex library needed. Walk the string, trying each instruction
--   with `stripPrefix` in the Maybe monad; on failure drop one character and retry.
--   Haskell: pattern guards + Maybe do-notation make a tiny hand-rolled scanner.
module Part1 (solve, Instr (..), instructions) where

import Data.Char (isDigit)
import Data.List (stripPrefix)

data Instr = Do | Dont | Mul Int Int

instructions :: String -> [Instr]
instructions [] = []
instructions s@(_ : rest)
  | Just r <- stripPrefix "do()" s = Do : instructions r
  | Just r <- stripPrefix "don't()" s = Dont : instructions r
  | Just (a, b, r) <- mul s = Mul a b : instructions r
  | otherwise = instructions rest

mul :: String -> Maybe (Int, Int, String)
mul s = do
  r0 <- stripPrefix "mul(" s
  (a, r1) <- number r0
  r2 <- stripPrefix "," r1
  (b, r3) <- number r2
  r4 <- stripPrefix ")" r3
  pure (a, b, r4)

number :: String -> Maybe (Int, String)
number s = case span isDigit s of
  (ds, r) | not (null ds), length ds <= 3 -> Just (read ds, r)
  _ -> Nothing

solve :: String -> String
solve input = show $ sum [a * b | Mul a b <- instructions input]
