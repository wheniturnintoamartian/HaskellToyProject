module Main where

-- import Lib
import SplitLines
import SimpleJSON
import PrettyJSON
import Prettify
import ContravariantFunctor
import TempFile
import ToUpperLazy
import ToUpperLazy2
import ElfMagic
import HighestClose

import Data.Char (toUpper)
import Text.Regex.Posix

import GlobRegex

main :: IO ()
main = do putStrLn $ globToRegex "f??.c"

