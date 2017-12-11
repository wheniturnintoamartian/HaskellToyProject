module Main where

import Lib
import SplitLines
import SimpleJSON
import PrettyJSON
import Prettify

main :: IO ()
main = do let value = renderJValue (JObject [("f", JNumber 1), ("q", JBool True)])
          print $ pretty 10 value
