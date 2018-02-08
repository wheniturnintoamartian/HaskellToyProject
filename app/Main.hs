module Main where

-- import Lib
import SplitLines
import SimpleJSON
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
import Parse

import qualified Data.ByteString.Lazy.Char8 as L8

main :: IO ()
main = print $ parse parseByte (L8.pack "8")