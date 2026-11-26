-- Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
module Main (main) where

import qualified Part1
import qualified Part2
import System.Environment (lookupEnv)

main :: IO ()
main = do
  part <- lookupEnv "AOC_PART"
  input <- getContents
  putStrLn $ (if part == Just "2" then Part2.solve else Part1.solve) input
