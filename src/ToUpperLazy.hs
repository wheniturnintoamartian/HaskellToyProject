module ToUpperLazy where

import System.IO
import Data.Char (toUpper)

toUpperLazy :: IO ()
toUpperLazy = do inh <- openFile "input.txt" ReadMode
                 outh <- openFile "output.txt" WriteMode
                 inpStr <- hGetContents inh
                 let result = processData inpStr
                 hPutStr outh result
                 hClose inh
                 hClose outh

processData :: String -> String
processData = map toUpper