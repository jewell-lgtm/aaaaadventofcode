-- | Monkey Math: parse each line into a Job (a number or an operation on two monkeys),
--   store them in a Map, and evaluate recursively from "root".
--   Haskell: an ADT plus pattern matching mirrors the puzzle text directly.
module Part1 (solve, Job (..), parse, eval) where

import qualified Data.Map.Strict as M

data Job = Num Int | Op Char String String

parse :: String -> M.Map String Job
parse = M.fromList . map (job . words) . lines
  where
    job [name, n] = (init name, Num (read n))
    job [name, a, [op], b] = (init name, Op op a b)
    job ws = error ("bad job: " ++ unwords ws)

apply :: Char -> Int -> Int -> Int
apply '+' = (+)
apply '-' = (-)
apply '*' = (*)
apply '/' = div
apply op = error ("bad op: " ++ [op])

eval :: M.Map String Job -> String -> Int
eval jobs name = case jobs M.! name of
  Num n -> n
  Op op a b -> apply op (eval jobs a) (eval jobs b)

solve :: String -> String
solve input = show (eval (parse input) "root")
