module ToUpperLazy2 where

import Data.Char (toUpper)

toUpperLazy2 = do inpStr <- readFile "input.txt"
                  writeFile "output.txt" (map toUpper inpStr)