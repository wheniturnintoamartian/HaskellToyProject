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
import Glob
import Useful
import RecursiveContents
import Data.Char (toUpper)
import Text.Regex.Posix
import GlobRegex
import SimpleFinder
import System.FilePath(takeExtension)
import BetterPredicate

main :: IO ()
main = do a <- betterFind (sizeP `equalP` 521) "."
          print a