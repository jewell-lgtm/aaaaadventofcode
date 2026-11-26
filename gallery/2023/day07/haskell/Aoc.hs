-- | Harness helpers.
--   example: True when running an example (aoc test).
--   arg "size" 71: example-specific constant from examples.toml `args`, else the default.
module Aoc (example, arg, argStr) where

import Data.Char (isSpace)
import System.Environment (lookupEnv)
import System.IO.Unsafe (unsafePerformIO)

{-# NOINLINE example #-}
example :: Bool
example = unsafePerformIO $ (== Just "1") <$> lookupEnv "AOC_EXAMPLE"

{-# NOINLINE rawArgs #-}
rawArgs :: [(String, String)]
rawArgs = unsafePerformIO $ maybe [] parseFlat <$> lookupEnv "AOC_ARGS"

arg :: (Read a) => String -> a -> a
arg k d = maybe d read (lookup k rawArgs)

argStr :: String -> String -> String
argStr k d = maybe d id (lookup k rawArgs)

-- Flat JSON object {"k": 1, "s": "x", "b": true}: enough for AOC_ARGS.
parseFlat :: String -> [(String, String)]
parseFlat = go . dropWhile (/= '{')
  where
    go s = case dropWhile (\c -> isSpace c || c `elem` "{,") s of
      ('"' : rest) ->
        let (k, rest') = break (== '"') rest
            v0 = dropWhile (\c -> isSpace c || c == ':') (drop 1 rest')
         in case v0 of
              ('"' : vs) -> let (v, r) = break (== '"') vs in (k, v) : go (drop 1 r)
              _ -> let (v, r) = break (`elem` ",}") v0 in (k, trim v) : go r
      _ -> []
    trim = reverse . dropWhile isSpace . reverse . dropWhile isSpace
