module Main where

import Barcode (checkDigit)

main :: IO ()
main = do  
    args <- getArgs  forM_ args $ \arg -> do    
        e <- parse parseRawPPM <$> L.readFile arg    
        case e of      
            Left err ->     print $ "error: " ++ err      
            Right pixmap -> print $ findEAN13 pixmap 