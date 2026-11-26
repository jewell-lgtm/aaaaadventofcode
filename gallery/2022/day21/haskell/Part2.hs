-- | "humn" is the unknown. From root, descend the side that depends on humn,
--   inverting each operation against the other side's (constant) value.
module Part2 (solve) where

import qualified Data.Map.Strict as M
import Part1 (Job (..), eval, parse)

solve :: String -> String
solve input = show $ case jobs M.! "root" of
  Op _ a b | dependsOnHumn a -> solveFor a (eval jobs b)
  Op _ a b -> solveFor b (eval jobs a)
  Num _ -> error "root must be an operation"
  where
    jobs = parse input
    dependsOnHumn "humn" = True
    dependsOnHumn name = case jobs M.! name of
      Num _ -> False
      Op _ a b -> dependsOnHumn a || dependsOnHumn b
    -- the value humn must take for `name` to evaluate to `target`
    solveFor "humn" target = target
    solveFor name target = case jobs M.! name of
      Num _ -> error "constant has no unknown"
      Op op a b
        | dependsOnHumn a -> solveFor a (invertLeft op target (eval jobs b))
        | otherwise -> solveFor b (invertRight op target (eval jobs a))
    -- target = x `op` v
    invertLeft op t v = case op of '+' -> t - v; '-' -> t + v; '*' -> t `div` v; _ -> t * v
    -- target = v `op` x
    invertRight op t v = case op of '+' -> t - v; '-' -> v - t; '*' -> t `div` v; _ -> v `div` t
