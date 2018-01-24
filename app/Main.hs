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

main :: IO ()
main = do a <- simpleFind (\p -> takeExtension p == ".cpp") "."
          mapM_ print $ a
          b <- getRecursiveContents "."
          mapM_ print $ b