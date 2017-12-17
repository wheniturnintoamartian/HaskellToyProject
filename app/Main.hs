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

main :: IO ()
main = print $ (("my left foot" =~ "foo")::Bool)
