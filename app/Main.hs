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
main = do print (("my left foot" =~ "foo")::Bool)
          print (("your right hand" =~ "bar")::Bool)
          print (("your right hand" =~ "(hand|foot)")::Bool)
          print (("a star called henry" =~ "planet")::Int)
          print (("honorificabilitudinitatibus" =~ "[aeiou]")::Int)
          print $ (("I, B. Ionsonii, uurit a lift'd batch" =~ "(uu|ii)")::String)
          print (("hi ludi, F. Baconis nati, tuiti orbi" =~ "Shakespeare")::String)
--          print $ (("I, B. Ionsonii, uurit a lift'd batch" =~ "(uu|ii)")::[String])
--          print $ (("hi ludi, F. Baconis nati, tuiti orbi" =~ "Shakespeare")::[String])
          let pat = "(foo[a-z]*bar|quux)"
          print (("before foodiebar after" =~ pat)::(String, String, String))
          print (("no match here" =~ pat)::(String, String, String))
          print (("before foodiebar after" =~ pat)::(String, String, String, [String]))
          print (("before foodiebar after" =~ pat)::(Int, Int))
--          print $ (("i foobarbar a quux" =~ pat)::[(Int, Int)])
          print (("eleemosynary" =~ pat)::(Int, Int))
--          print $ (("mondegreen" =~ pat)::[(Int, Int)])

