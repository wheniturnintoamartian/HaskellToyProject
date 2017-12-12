module Main where

import Lib
import SplitLines
import SimpleJSON
import PrettyJSON
import Prettify

main :: IO ()
main = do let value = renderJValue (JObject [("f", JNumber 1), ("q", JBool True)])
          putStrLn $ pretty 50 value
